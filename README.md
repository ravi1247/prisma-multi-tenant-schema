# 🏢 Prisma Multi-Tenant Schema Architecture

A production-ready implementation of multi-tenant database architecture using **Prisma ORM** + **PostgreSQL schemas**, providing complete data isolation for SaaS applications.

## 🌟 Key Features

- ✅ **Complete Data Isolation** - Each organization gets its own PostgreSQL schema
- ✅ **Hybrid Approach** - Prisma for shared data + Raw SQL for tenant schemas
- ✅ **Custom Migration System** - Version-controlled tenant schema migrations
- ✅ **Connection Management** - Efficient singleton-based connection pooling
- ✅ **Type Safety** - Full TypeScript support with generated Prisma clients
- ✅ **Production Ready** - Error handling, validation, and graceful shutdown

## 🏗️ Architecture Overview

```mermaid
graph TB
    A[Client Request] --> B[JWT Authentication]
    B --> C[Tenant Middleware]
    C --> D{Resolve Organization}
    D --> E[Get Tenant Schema]
    E --> F[Dynamic Prisma Client]
    F --> G[Tenant-Isolated Database]

    H[Shared Schema] --> I[Organizations & Users]
    G --> J[Business Logic Data]

    subgraph "Database Structure"
        H
        J
    end

    subgraph "Schema Per Tenant"
        K[org_acme_123]
        L[org_beta_456]
        M[org_gamma_789]
    end
```

## 🚀 Quick Start

### Prerequisites

- Node.js 18+
- PostgreSQL 12+
- TypeScript knowledge

### 1. Installation

```bash
git clone https://github.com/ravi1247/prisma-multi-tenant-schema.git
cd prisma-multi-tenant-schema
npm install
```

### 2. Environment Setup

```bash
cp .env.example .env
# Edit .env with your database credentials
```

### 3. Database Setup

```bash
# Create database
createdb your_database_name

# Generate Prisma clients
npm run prisma:generate

# Run shared schema migrations
npm run prisma:migrate:shared
```

### 4. Create Your First Organization

```bash
npm start
```

```bash
# API call to create organization
curl -X POST http://localhost:3000/api/organizations/create \
  -H "Content-Type: application/json" \
  -d '{
    "name": "Demo Company",
    "email": "contact@demo.com",
    "adminEmail": "admin@demo.com",
    "adminPassword": "secure123",
    "adminFirstName": "Admin"
  }'
```

**✨ This automatically:**

- Creates organization record in shared schema
- Creates dedicated `org_demo_company_xxxxx` schema
- Applies all tenant migrations
- Creates admin user in both shared and tenant schemas

## 📊 Database Structure

### Shared Schema (Prisma-managed)

```sql
-- Organizations and authentication
public.Organization
public.User
```

### Tenant Schema (Custom migrations)

```sql
-- Business logic per organization
org_acme_123.Employee
org_acme_123.Doctor
org_acme_123.Patient
org_acme_123.Orders
-- ... all business entities
```

## 🔧 Core Components

### 1. Schema Management Service

The heart of the system - handles all tenant operations:

```typescript
import SchemaManagementService from "./services/SchemaManagementService.js";

const schemaService = SchemaManagementService.getInstance();

// Create new tenant schema
const schemaName = await schemaService.createOrganizationSchema(orgId, orgName);

// Get tenant database client
const tenantDb = await schemaService.getTenantClient(schemaName);

// Apply migrations to all tenants
await schemaService.applyMigrationsToAllExistingTenants();
```

### 2. Tenant Middleware

Automatic tenant resolution for every request:

```typescript
// JWT token → User → Organization → Tenant DB
app.use(tenantMiddleware);

// In your controllers:
async function getOrders(req, res) {
  // req.tenantDb is automatically available
  const orders = await req.tenantDb.order.findMany({
    where: { userId: req.user.id },
  });
  res.json(orders);
}
```

### 3. Migration System

Version-controlled schema changes:

```sql
-- tenant-migrations/V002_add_new_table.sql
CREATE TABLE patients (
  id TEXT PRIMARY KEY,
  name VARCHAR(255) NOT NULL,
  email VARCHAR(255),
  created_at TIMESTAMP DEFAULT now()
);
```

```bash
# Apply to all tenants
npm run migrations:apply:all
```

## 📁 Project Structure

```
src/
├── services/
│   └── SchemaManagementService.ts  # Core tenant management
├── middlewares/
│   └── tenantMiddleware.ts         # Request-level tenant resolution
├── scripts/
│   └── onboardOrganization.ts     # New tenant setup
├── controllers/
│   ├── organizationController.ts  # Tenant CRUD operations
│   └── authController.ts          # Authentication logic
└── types/
    └── express.d.ts               # Type definitions

prisma-shared/
└── schema.prisma                  # Shared models (Org, User)

prisma-tenant/
└── schema.prisma                  # Tenant models (Business logic)

tenant-migrations/
└── V001_initial_schema.sql        # Tenant schema DDL
```

## 🛠️ Usage Examples

### Creating New Organization

```typescript
import { onboardNewOrganization } from "./scripts/onboardOrganization.js";

const result = await onboardNewOrganization({
  name: "Healthcare Corp",
  email: "contact@healthcare.com",
  adminEmail: "admin@healthcare.com",
  adminPassword: "securePassword123",
  adminFirstName: "John",
  adminLastName: "Admin",
});

console.log(`Created organization with schema: ${result.schemaName}`);
```

### Tenant-Aware Controller

```typescript
async function createPatient(req: Request, res: Response) {
  try {
    // req.tenantDb automatically points to correct tenant schema
    const patient = await req.tenantDb.patient.create({
      data: {
        name: req.body.name,
        email: req.body.email,
        organizationId: req.user.organizationId, // Tenant isolation
      },
    });

    res.json({ success: true, patient });
  } catch (error) {
    res.status(500).json({ error: "Failed to create patient" });
  }
}
```

### Adding New Migration

```bash
# 1. Create migration file
echo "ALTER TABLE employees ADD COLUMN department VARCHAR(100);" > tenant-migrations/V003_add_department.sql

# 2. Apply to all tenants
npm run migrations:apply:all
```

## 🔐 Security Features

### Data Isolation

- **Schema-level separation** - PostgreSQL native isolation
- **JWT-based tenant resolution** - No direct tenant ID exposure
- **Middleware validation** - Automatic tenant access control

### Example Request Flow

```
1. Client sends JWT: { email: "user@acme.com", ... }
2. Middleware looks up user → organization → schema name
3. Gets tenant DB client for "org_acme_123"
4. All queries automatically isolated to that schema
```

## 🚀 Production Deployment

### Environment Variables

```env
DATABASE_URL="postgresql://user:pass@prod-db:5432/app_db?schema=public"
JWT_SECRET="your-production-jwt-secret"
NODE_ENV="production"
```

### Database Permissions

```sql
-- Grant schema permissions to app user
GRANT ALL ON SCHEMA "org_tenant_*" TO app_user;
GRANT ALL ON ALL TABLES IN SCHEMA "org_tenant_*" TO app_user;
```

### Health Checks

```typescript
// Verify tenant connectivity
app.get("/health/tenants", async (req, res) => {
  const results = await schemaService.verifyAllTenantConnections();
  res.json({ healthy: results.every((r) => r.healthy) });
});
```

## 📈 Performance Considerations

### Connection Pooling

- **Singleton pattern** - One Prisma client per schema (cached)
- **Connection limits** - Monitor active connections per tenant
- **Graceful shutdown** - Proper cleanup on app termination

### Scaling Strategies

- **Horizontal scaling** - Move large tenants to dedicated databases
- **Read replicas** - Per-schema read scaling
- **Monitoring** - Track tenant schema sizes and performance

## 🧪 Testing

```bash
npm test
```

**Test Coverage:**

- Schema creation and migration application
- Tenant isolation verification
- Connection management
- Error handling scenarios

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 🙏 Acknowledgments

- **Prisma Team** - For the excellent ORM foundation
- **PostgreSQL** - For robust schema-based multi-tenancy support
- **Community** - For feedback and contributions

## 📞 Support

- 📧 **Email**: meenaravi1247@gmail.com

---

⭐ **Star this repository if it helped you build better multi-tenant applications!**

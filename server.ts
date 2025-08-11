import express from 'express';
import cors from 'cors';
import dotenv from 'dotenv';
import SchemaManagementService from './src/service/SchemaManagementService';
import organizationRoutes from './src/routes/organizationRoutes';

// Load environment variables
dotenv.config();

const app = express();
const PORT = process.env.PORT || 3000;

// Initialize schema service
const schemaService = SchemaManagementService.getInstance();

// Middleware
app.use(cors({
    origin: '*', // Configure for production
    credentials: true
}));
app.use(express.json());
app.use(express.urlencoded({ extended: true }));

// Request logging
app.use((req, res, next) => {
    console.log(`${new Date().toISOString()} - ${req.method} ${req.path}`);
    next();
});

// Health check
app.get('/', (req, res) => {
    res.json({
        status: 'ok',
        message: 'Prisma Multi-Tenant Schema API is running!',
        timestamp: new Date().toISOString()
    });
});


// Routes
app.use('/api/organizations', organizationRoutes);

// 404 handler
app.use((req, res) => {
    res.status(404).json({
        error: 'Not Found',
        message: `Cannot ${req.method} ${req.path}`
    });
});

// Error handler
app.use((err: any, req: express.Request, res: express.Response, next: express.NextFunction) => {
    console.error('Error:', err);

    if (err.code === 'P2002') {
        return res.status(409).json({
            error: 'Duplicate entry',
            field: err.meta?.target
        });
    }

    res.status(500).json({
        error: 'Internal Server Error',
        message: process.env.NODE_ENV === 'development' ? err.message : 'Something went wrong'
    });
});

// Start server
const server = app.listen(PORT, () => {
    console.log(`
🚀 Multi-Tenant Schema API Server is running!
📡 API URL: http://localhost:${PORT}
🌍 Environment: ${process.env.NODE_ENV || 'development'}
📅 Started at: ${new Date().toISOString()}
  `);
});

// Graceful shutdown
const gracefulShutdown = async (signal: string) => {
    console.log(`\n${signal} received: closing server...`);
    server.close(async () => {
        console.log('HTTP server closed');
        try {
            await schemaService.closeAllConnections();
            console.log('Database connections closed');
            process.exit(0);
        } catch (error) {
            console.error('Error during shutdown:', error);
            process.exit(1);
        }
    });
};

process.on('SIGTERM', () => gracefulShutdown('SIGTERM'));
process.on('SIGINT', () => gracefulShutdown('SIGINT'));
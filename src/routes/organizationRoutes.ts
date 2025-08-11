import express from 'express';
import SchemaManagementService from '../service/SchemaManagementService';
import { createOrganizationController } from '../controllers/organizationController';

const router = express.Router();
const schemaService = SchemaManagementService.getInstance();



console.log('Starting application initialization...');
// IMPORTANT: Load tenant migrations before any requests can come in
await schemaService.initializeMigrations();
console.log('✅ Tenant migrations loaded successfully.');

console.log("organization ROutes");


router.post('/create', createOrganizationController)



export default router;







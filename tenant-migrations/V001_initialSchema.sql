-- CreateEnum
CREATE TYPE "EmployeeRole" AS ENUM ('MEDICAL_REPRESENTATIVE', 'SALES_MANAGER', 'SYSTEM_ADMINISTRATOR');

-- CreateEnum
CREATE TYPE "TaskType" AS ENUM ('DOCTOR', 'CHEMIST', 'TOUR_PLANNER');

-- CreateEnum
CREATE TYPE "TaskStatus" AS ENUM ('PENDING', 'COMPLETED', 'RESCHEDULED');

-- CreateEnum
CREATE TYPE "AssociationType" AS ENUM ('DOCTOR', 'CHEMIST');

-- CreateEnum
CREATE TYPE "DayOfWeek" AS ENUM ('MONDAY', 'TUESDAY', 'WEDNESDAY', 'THURSDAY', 'FRIDAY', 'SATURDAY', 'SUNDAY');

-- CreateEnum
CREATE TYPE "ConsultationType" AS ENUM ('OPD', 'EMERGENCY', 'SURGERY', 'SPECIAL');

-- CreateEnum
CREATE TYPE "InteractionType" AS ENUM ('MEETING', 'CALL', 'EMAIL', 'WHATSAPP');

-- CreateEnum
CREATE TYPE "OrderStatus" AS ENUM ('PENDING', 'CONFIRMED', 'DISPATCHED', 'DELIVERED', 'CANCELLED');

-- CreateEnum
CREATE TYPE "EventType" AS ENUM ('MEETING', 'VISIT', 'TRAINING', 'OTHER');

-- CreateEnum
CREATE TYPE "EventStatus" AS ENUM ('SCHEDULED', 'COMPLETED', 'CANCELLED', 'RESCHEDULED');

-- CreateEnum
CREATE TYPE "ExpenseClaimStatus" AS ENUM ('PENDING', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "TaskPlannerStatus" AS ENUM ('DRAFT', 'PENDING_APPROVAL', 'APPROVED', 'REJECTED');

-- CreateEnum
CREATE TYPE "TaskTypeReference" AS ENUM ('DOCTOR_TASK', 'CHEMIST_TASK', 'TOUR_PLAN_TASK');

-- CreateEnum
CREATE TYPE "ChemistType" AS ENUM ('CHEMIST', 'STOCKIST');

-- CreateTable
CREATE TABLE "employees" (
    "id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "email" VARCHAR(255) NOT NULL,
    "password_hash" VARCHAR(255) NOT NULL,
    "first_name" VARCHAR(100) NOT NULL,
    "last_name" VARCHAR(100),
    "phone" VARCHAR(20),
    "profile_pic" TEXT,
    "role" "EmployeeRole" NOT NULL,
    "reporting_manager_id" TEXT,
    "team_id" TEXT,
    "employee_code" VARCHAR(50),
    "city" VARCHAR(100),
    "state" VARCHAR(100),
    "assignedLatitude" DECIMAL(10,8),
    "assignedLongitude" DECIMAL(11,8),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "last_login_at" TIMESTAMP(3),
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "employees_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "Team" (
    "id" TEXT NOT NULL,
    "team_name" VARCHAR(255) NOT NULL,
    "lead_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "Team_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "territories" (
    "territory_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "type" VARCHAR(100) NOT NULL,
    "parent_territory_id" TEXT,
    "boundaries" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "territories_pkey" PRIMARY KEY ("territory_id")
);

-- CreateTable
CREATE TABLE "employee_territories" (
    "id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "territory_id" TEXT NOT NULL,
    "assigned_at" TIMESTAMP(3) NOT NULL,
    "unassigned_at" TIMESTAMP(3),
    "is_primary" BOOLEAN NOT NULL DEFAULT false,

    CONSTRAINT "employee_territories_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "employee_training_records" (
    "id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "training_name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "completion_date" DATE NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "employee_training_records_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "hospital_chains" (
    "id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "headquarters_address" TEXT,
    "contact_email" VARCHAR(255),
    "contact_phone" VARCHAR(20),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hospital_chains_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chemist_chains" (
    "chemist_chain_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "headquarters_address" TEXT,
    "contact_email" VARCHAR(255),
    "contact_phone" VARCHAR(20),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "chemist_chains_pkey" PRIMARY KEY ("chemist_chain_id")
);

-- CreateTable
CREATE TABLE "hospitals" (
    "hospital_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "hospital_chain_id" TEXT,
    "territory_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "type" VARCHAR(100) NOT NULL,
    "address" TEXT NOT NULL,
    "city" VARCHAR(100),
    "state" VARCHAR(100),
    "pincode" VARCHAR(10),
    "latitude" DECIMAL(10,8),
    "longitude" DECIMAL(11,8),
    "phone" VARCHAR(20),
    "email" VARCHAR(255),
    "website" VARCHAR(255),
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "hospitals_pkey" PRIMARY KEY ("hospital_id")
);

-- CreateTable
CREATE TABLE "doctors" (
    "doctor_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "designation" VARCHAR(255),
    "specialization" VARCHAR(255),
    "email" VARCHAR(255),
    "phone" VARCHAR(20),
    "description" TEXT,
    "profile_picture_url" VARCHAR(500),
    "qualification" VARCHAR(255),
    "experience_years" INTEGER,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "doctors_pkey" PRIMARY KEY ("doctor_id")
);

-- CreateTable
CREATE TABLE "doctor_hospital_associations" (
    "id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "hospital_id" TEXT NOT NULL,
    "department" VARCHAR(255),
    "position" VARCHAR(255),
    "is_primary" BOOLEAN NOT NULL DEFAULT false,
    "association_start_date" TIMESTAMP(3),
    "association_end_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctor_hospital_associations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_consultation_schedules" (
    "id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "hospital_id" TEXT NOT NULL,
    "day_of_week" "DayOfWeek" NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "consultation_type" "ConsultationType" NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "effective_from" TIMESTAMP(3),
    "effective_to" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctor_consultation_schedules_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_notes" (
    "id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctor_notes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_interactions" (
    "id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "hospital_id" TEXT,
    "interaction_type" "InteractionType" NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3),
    "purpose" TEXT,
    "outcome" TEXT,
    "comments" TEXT,
    "rating" SMALLINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "doctorTaskId" TEXT,

    CONSTRAINT "doctor_interactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "drugs" (
    "drug_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "composition" TEXT,
    "manufacturer" VARCHAR(255),
    "indications" TEXT,
    "side_effects" TEXT,
    "safety_advice" TEXT,
    "dosage_forms" JSONB,
    "price" DECIMAL(10,2),
    "schedule" VARCHAR(10),
    "regulatory_approvals" TEXT,
    "category" VARCHAR(100),
    "is_available" BOOLEAN NOT NULL DEFAULT true,
    "images" JSONB,
    "marketing_materials" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "drugs_pkey" PRIMARY KEY ("drug_id")
);

-- CreateTable
CREATE TABLE "chemists" (
    "chemist_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "chemist_chain_id" TEXT,
    "territory_id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "type" "ChemistType" NOT NULL,
    "email" VARCHAR(255),
    "phone" VARCHAR(20),
    "address" TEXT,
    "city" VARCHAR(100),
    "state" VARCHAR(100),
    "pincode" VARCHAR(10),
    "latitude" DECIMAL(10,8),
    "longitude" DECIMAL(11,8),
    "description" TEXT,
    "profile_picture_url" VARCHAR(500),
    "visiting_hours" VARCHAR(255),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "chemists_pkey" PRIMARY KEY ("chemist_id")
);

-- CreateTable
CREATE TABLE "chemist_notes" (
    "id" TEXT NOT NULL,
    "chemist_id" TEXT NOT NULL,
    "created_by" TEXT NOT NULL,
    "content" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "chemist_notes_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chemist_interactions" (
    "id" TEXT NOT NULL,
    "chemist_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "interaction_type" "InteractionType" NOT NULL,
    "start_time" TIMESTAMP(3) NOT NULL,
    "end_time" TIMESTAMP(3),
    "purpose" TEXT,
    "outcome" TEXT,
    "comments" TEXT,
    "rating" SMALLINT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "chemistTaskId" TEXT,

    CONSTRAINT "chemist_interactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_chemist_relations" (
    "id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "chemist_id" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "created_by" TEXT NOT NULL,

    CONSTRAINT "doctor_chemist_relations_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "orders" (
    "order_id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "chemist_id" TEXT,
    "total_amount" DECIMAL(10,2) NOT NULL,
    "status" "OrderStatus" NOT NULL,
    "order_date" TIMESTAMP(3) NOT NULL,
    "delivery_date" TIMESTAMP(3),
    "special_instructions" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT NOT NULL,

    CONSTRAINT "orders_pkey" PRIMARY KEY ("order_id")
);

-- CreateTable
CREATE TABLE "order_items" (
    "order_id" TEXT NOT NULL,
    "drug_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unit_price" DECIMAL(10,2) NOT NULL,
    "subtotal" DECIMAL(10,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "order_items_pkey" PRIMARY KEY ("order_id","drug_id")
);

-- CreateTable
CREATE TABLE "dcr_reports" (
    "id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "task_id" TEXT,
    "task_type" "TaskTypeReference",
    "report_date" DATE NOT NULL,
    "products_discussed" TEXT,
    "comments" TEXT,
    "is_draft" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "dcr_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rcpa_reports" (
    "id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "chemist_id" TEXT NOT NULL,
    "remarks" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "rcpa_reports_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "rcpa_drug_data" (
    "id" TEXT NOT NULL,
    "rcpa_report_id" TEXT NOT NULL,
    "drug_id" TEXT,
    "competitor_drug_name" VARCHAR(255),
    "own_quantity" INTEGER NOT NULL,
    "competitor_quantity" INTEGER NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "rcpa_drug_data_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "check_ins" (
    "id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "check_in_time" TIMESTAMP(3),
    "check_out_time" TIMESTAMP(3),
    "check_in_latitude" DECIMAL(10,8),
    "check_in_longitude" DECIMAL(11,8),
    "check_out_latitude" DECIMAL(10,8),
    "check_out_longitude" DECIMAL(11,8),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "check_ins_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "task_planners" (
    "id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "start_date" DATE NOT NULL,
    "end_date" DATE NOT NULL,
    "status" "TaskPlannerStatus" NOT NULL DEFAULT 'DRAFT',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "task_planners_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_tasks" (
    "id" TEXT NOT NULL,
    "task_planner_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "doctor_id" TEXT NOT NULL,
    "taskDate" DATE NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "taskStatus" "TaskStatus" NOT NULL DEFAULT 'PENDING',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctor_tasks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "chemist_tasks" (
    "id" TEXT NOT NULL,
    "task_planner_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "chemist_id" TEXT NOT NULL,
    "taskDate" DATE NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "taskStatus" "TaskStatus" NOT NULL DEFAULT 'PENDING',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "chemist_tasks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_plan_tasks" (
    "id" TEXT NOT NULL,
    "task_planner_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "tour_plan_id" TEXT NOT NULL,
    "location" VARCHAR(255) NOT NULL,
    "taskDate" DATE NOT NULL,
    "start_time" TIME NOT NULL,
    "end_time" TIME NOT NULL,
    "taskStatus" "TaskStatus" NOT NULL DEFAULT 'PENDING',
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tour_plan_tasks_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_plans" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(255) NOT NULL,
    "description" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tour_plans_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "tour_planner_interactions" (
    "id" TEXT NOT NULL,
    "task_for_tour_planner_id" TEXT NOT NULL,
    "interaction_time" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "purpose" VARCHAR(255),
    "outcome" TEXT,
    "comments" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "tour_planner_interactions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expense_types" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(50) NOT NULL,
    "description" TEXT,
    "icon" TEXT,
    "form_fields" JSONB NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "expense_types_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expense_role_configs" (
    "id" TEXT NOT NULL,
    "expense_type_id" TEXT NOT NULL,
    "role" "EmployeeRole" NOT NULL,
    "limits" JSONB NOT NULL,
    "rates" JSONB,
    "validation_rules" JSONB NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "expense_role_configs_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "expense_claims" (
    "id" TEXT NOT NULL,
    "claim_number" VARCHAR(50) NOT NULL,
    "employee_id" TEXT NOT NULL,
    "expense_type_id" TEXT NOT NULL,
    "expense_role_config_id" TEXT NOT NULL,
    "expense_data" JSONB NOT NULL,
    "status" "ExpenseClaimStatus" NOT NULL DEFAULT 'PENDING',
    "submitted_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "approved_at" TIMESTAMP(3),
    "approved_by" TEXT,
    "approval_comments" TEXT,
    "rejection_reason" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "expense_claims_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "gifts" (
    "id" TEXT NOT NULL,
    "name" VARCHAR(200) NOT NULL,
    "description" TEXT,
    "unit_cost" DECIMAL(10,2) NOT NULL,
    "specifications" JSONB,
    "gift_images" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "created_by" TEXT NOT NULL,
    "is_active" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "gifts_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_drug_inventory" (
    "id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "drug_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "last_restocked_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_drug_inventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "user_gift_inventory" (
    "id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "gift_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "last_restocked_date" TIMESTAMP(3),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "user_gift_inventory_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_distributions" (
    "id" TEXT NOT NULL,
    "doctor_interaction_id" TEXT NOT NULL,
    "employee_id" TEXT NOT NULL,
    "distributed_at" TIMESTAMP(3) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctor_distributions_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_distribution_drug_items" (
    "id" TEXT NOT NULL,
    "doctor_distribution_id" TEXT NOT NULL,
    "drug_id" TEXT NOT NULL,
    "from_inventory_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unit_cost" DECIMAL(10,2) NOT NULL,
    "total_cost" DECIMAL(10,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctor_distribution_drug_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "doctor_distribution_gift_items" (
    "id" TEXT NOT NULL,
    "doctor_distribution_id" TEXT NOT NULL,
    "gift_id" TEXT NOT NULL,
    "from_inventory_id" TEXT NOT NULL,
    "quantity" INTEGER NOT NULL,
    "unit_cost" DECIMAL(10,2) NOT NULL,
    "total_cost" DECIMAL(10,2) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "doctor_distribution_gift_items_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "audit_logs" (
    "id" TEXT NOT NULL,
    "organization_id" TEXT NOT NULL,
    "employee_id" TEXT,
    "table_name" VARCHAR(100) NOT NULL,
    "action_type" VARCHAR(50) NOT NULL,
    "record_id" TEXT NOT NULL,
    "old_values" JSONB,
    "new_values" JSONB,
    "ip_address" VARCHAR(45),
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "audit_logs_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "employees_email_key" ON "employees"("email");

-- CreateIndex
CREATE UNIQUE INDEX "Team_lead_id_key" ON "Team"("lead_id");

-- CreateIndex
CREATE UNIQUE INDEX "doctor_hospital_associations_doctor_id_hospital_id_key" ON "doctor_hospital_associations"("doctor_id", "hospital_id");

-- CreateIndex
CREATE UNIQUE INDEX "expense_types_name_key" ON "expense_types"("name");

-- CreateIndex
CREATE UNIQUE INDEX "expense_role_configs_expense_type_id_role_key" ON "expense_role_configs"("expense_type_id", "role");

-- CreateIndex
CREATE UNIQUE INDEX "expense_claims_claim_number_key" ON "expense_claims"("claim_number");

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_reporting_manager_id_fkey" FOREIGN KEY ("reporting_manager_id") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employees" ADD CONSTRAINT "employees_team_id_fkey" FOREIGN KEY ("team_id") REFERENCES "Team"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "Team" ADD CONSTRAINT "Team_lead_id_fkey" FOREIGN KEY ("lead_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "territories" ADD CONSTRAINT "territories_parent_territory_id_fkey" FOREIGN KEY ("parent_territory_id") REFERENCES "territories"("territory_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_territories" ADD CONSTRAINT "employee_territories_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_territories" ADD CONSTRAINT "employee_territories_territory_id_fkey" FOREIGN KEY ("territory_id") REFERENCES "territories"("territory_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "employee_training_records" ADD CONSTRAINT "employee_training_records_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospitals" ADD CONSTRAINT "hospitals_hospital_chain_id_fkey" FOREIGN KEY ("hospital_chain_id") REFERENCES "hospital_chains"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "hospitals" ADD CONSTRAINT "hospitals_territory_id_fkey" FOREIGN KEY ("territory_id") REFERENCES "territories"("territory_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctors" ADD CONSTRAINT "doctors_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_hospital_associations" ADD CONSTRAINT "doctor_hospital_associations_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("doctor_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_hospital_associations" ADD CONSTRAINT "doctor_hospital_associations_hospital_id_fkey" FOREIGN KEY ("hospital_id") REFERENCES "hospitals"("hospital_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_consultation_schedules" ADD CONSTRAINT "doctor_consultation_schedules_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("doctor_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_consultation_schedules" ADD CONSTRAINT "doctor_consultation_schedules_hospital_id_fkey" FOREIGN KEY ("hospital_id") REFERENCES "hospitals"("hospital_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_notes" ADD CONSTRAINT "doctor_notes_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("doctor_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_notes" ADD CONSTRAINT "doctor_notes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_interactions" ADD CONSTRAINT "doctor_interactions_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("doctor_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_interactions" ADD CONSTRAINT "doctor_interactions_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_interactions" ADD CONSTRAINT "doctor_interactions_hospital_id_fkey" FOREIGN KEY ("hospital_id") REFERENCES "hospitals"("hospital_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_interactions" ADD CONSTRAINT "doctor_interactions_doctorTaskId_fkey" FOREIGN KEY ("doctorTaskId") REFERENCES "doctor_tasks"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "drugs" ADD CONSTRAINT "drugs_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemists" ADD CONSTRAINT "chemists_chemist_chain_id_fkey" FOREIGN KEY ("chemist_chain_id") REFERENCES "chemist_chains"("chemist_chain_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemists" ADD CONSTRAINT "chemists_territory_id_fkey" FOREIGN KEY ("territory_id") REFERENCES "territories"("territory_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemists" ADD CONSTRAINT "chemists_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_notes" ADD CONSTRAINT "chemist_notes_chemist_id_fkey" FOREIGN KEY ("chemist_id") REFERENCES "chemists"("chemist_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_notes" ADD CONSTRAINT "chemist_notes_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_interactions" ADD CONSTRAINT "chemist_interactions_chemist_id_fkey" FOREIGN KEY ("chemist_id") REFERENCES "chemists"("chemist_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_interactions" ADD CONSTRAINT "chemist_interactions_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_interactions" ADD CONSTRAINT "chemist_interactions_chemistTaskId_fkey" FOREIGN KEY ("chemistTaskId") REFERENCES "chemist_tasks"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_chemist_relations" ADD CONSTRAINT "doctor_chemist_relations_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("doctor_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_chemist_relations" ADD CONSTRAINT "doctor_chemist_relations_chemist_id_fkey" FOREIGN KEY ("chemist_id") REFERENCES "chemists"("chemist_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_chemist_relations" ADD CONSTRAINT "doctor_chemist_relations_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_chemist_id_fkey" FOREIGN KEY ("chemist_id") REFERENCES "chemists"("chemist_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "orders" ADD CONSTRAINT "orders_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_items" ADD CONSTRAINT "order_items_order_id_fkey" FOREIGN KEY ("order_id") REFERENCES "orders"("order_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "order_items" ADD CONSTRAINT "order_items_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("drug_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dcr_reports" ADD CONSTRAINT "dcr_reports_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dcr_reports" ADD CONSTRAINT "dcr_reports_doctor_task_fkey" FOREIGN KEY ("task_id") REFERENCES "doctor_tasks"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dcr_reports" ADD CONSTRAINT "dcr_reports_chemist_task_fkey" FOREIGN KEY ("task_id") REFERENCES "chemist_tasks"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "dcr_reports" ADD CONSTRAINT "dcr_reports_tour_plan_task_fkey" FOREIGN KEY ("task_id") REFERENCES "tour_plan_tasks"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rcpa_reports" ADD CONSTRAINT "rcpa_reports_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rcpa_reports" ADD CONSTRAINT "rcpa_reports_chemist_id_fkey" FOREIGN KEY ("chemist_id") REFERENCES "chemists"("chemist_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rcpa_drug_data" ADD CONSTRAINT "rcpa_drug_data_rcpa_report_id_fkey" FOREIGN KEY ("rcpa_report_id") REFERENCES "rcpa_reports"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "rcpa_drug_data" ADD CONSTRAINT "rcpa_drug_data_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("drug_id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "check_ins" ADD CONSTRAINT "check_ins_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "task_planners" ADD CONSTRAINT "task_planners_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_tasks" ADD CONSTRAINT "doctor_tasks_task_planner_id_fkey" FOREIGN KEY ("task_planner_id") REFERENCES "task_planners"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_tasks" ADD CONSTRAINT "doctor_tasks_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_tasks" ADD CONSTRAINT "doctor_tasks_doctor_id_fkey" FOREIGN KEY ("doctor_id") REFERENCES "doctors"("doctor_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_tasks" ADD CONSTRAINT "chemist_tasks_task_planner_id_fkey" FOREIGN KEY ("task_planner_id") REFERENCES "task_planners"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_tasks" ADD CONSTRAINT "chemist_tasks_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "chemist_tasks" ADD CONSTRAINT "chemist_tasks_chemist_id_fkey" FOREIGN KEY ("chemist_id") REFERENCES "chemists"("chemist_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_plan_tasks" ADD CONSTRAINT "tour_plan_tasks_task_planner_id_fkey" FOREIGN KEY ("task_planner_id") REFERENCES "task_planners"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_plan_tasks" ADD CONSTRAINT "tour_plan_tasks_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_plan_tasks" ADD CONSTRAINT "tour_plan_tasks_tour_plan_id_fkey" FOREIGN KEY ("tour_plan_id") REFERENCES "tour_plans"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "tour_planner_interactions" ADD CONSTRAINT "tour_planner_interactions_task_for_tour_planner_id_fkey" FOREIGN KEY ("task_for_tour_planner_id") REFERENCES "tour_plan_tasks"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_role_configs" ADD CONSTRAINT "expense_role_configs_expense_type_id_fkey" FOREIGN KEY ("expense_type_id") REFERENCES "expense_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_claims" ADD CONSTRAINT "expense_claims_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_claims" ADD CONSTRAINT "expense_claims_expense_type_id_fkey" FOREIGN KEY ("expense_type_id") REFERENCES "expense_types"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_claims" ADD CONSTRAINT "expense_claims_expense_role_config_id_fkey" FOREIGN KEY ("expense_role_config_id") REFERENCES "expense_role_configs"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "expense_claims" ADD CONSTRAINT "expense_claims_approved_by_fkey" FOREIGN KEY ("approved_by") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "gifts" ADD CONSTRAINT "gifts_created_by_fkey" FOREIGN KEY ("created_by") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_drug_inventory" ADD CONSTRAINT "user_drug_inventory_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_drug_inventory" ADD CONSTRAINT "user_drug_inventory_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("drug_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_gift_inventory" ADD CONSTRAINT "user_gift_inventory_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "user_gift_inventory" ADD CONSTRAINT "user_gift_inventory_gift_id_fkey" FOREIGN KEY ("gift_id") REFERENCES "gifts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distributions" ADD CONSTRAINT "doctor_distributions_doctor_interaction_id_fkey" FOREIGN KEY ("doctor_interaction_id") REFERENCES "doctor_interactions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distributions" ADD CONSTRAINT "doctor_distributions_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distribution_drug_items" ADD CONSTRAINT "doctor_distribution_drug_items_doctor_distribution_id_fkey" FOREIGN KEY ("doctor_distribution_id") REFERENCES "doctor_distributions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distribution_drug_items" ADD CONSTRAINT "doctor_distribution_drug_items_drug_id_fkey" FOREIGN KEY ("drug_id") REFERENCES "drugs"("drug_id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distribution_drug_items" ADD CONSTRAINT "doctor_distribution_drug_items_from_inventory_id_fkey" FOREIGN KEY ("from_inventory_id") REFERENCES "user_drug_inventory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distribution_gift_items" ADD CONSTRAINT "doctor_distribution_gift_items_doctor_distribution_id_fkey" FOREIGN KEY ("doctor_distribution_id") REFERENCES "doctor_distributions"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distribution_gift_items" ADD CONSTRAINT "doctor_distribution_gift_items_gift_id_fkey" FOREIGN KEY ("gift_id") REFERENCES "gifts"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "doctor_distribution_gift_items" ADD CONSTRAINT "doctor_distribution_gift_items_from_inventory_id_fkey" FOREIGN KEY ("from_inventory_id") REFERENCES "user_gift_inventory"("id") ON DELETE RESTRICT ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "audit_logs" ADD CONSTRAINT "audit_logs_employee_id_fkey" FOREIGN KEY ("employee_id") REFERENCES "employees"("id") ON DELETE SET NULL ON UPDATE CASCADE;


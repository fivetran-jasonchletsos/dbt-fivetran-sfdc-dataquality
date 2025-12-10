-- Database initialization script
-- Run this script to create the required databases for the project

-- Note: JASON_CHLETSOS_SALESFORCE_SANDBOX already exists as the source database

-- Create the staging database
CREATE DATABASE IF NOT EXISTS JASON_CHLETSOS_SALESFORCE_STG;

-- Create the fact/mart database
CREATE DATABASE IF NOT EXISTS JASON_CHLETSOS_SALESFORCE_FCT;

-- Grant permissions (customize as needed for your environment)
-- GRANT USAGE ON DATABASE JASON_CHLETSOS_SALESFORCE_SANDBOX TO ROLE analyst_role;
-- GRANT USAGE ON DATABASE JASON_CHLETSOS_SALESFORCE_STG TO ROLE analyst_role;
-- GRANT USAGE ON DATABASE JASON_CHLETSOS_SALESFORCE_FCT TO ROLE analyst_role;
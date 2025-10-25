-- ============================================================================
-- Zenith Insurance Intelligence Agent - Database and Schema Setup
-- ============================================================================
-- Purpose: Initialize the database, schema, and warehouse for the Zenith
--          Insurance Intelligence Agent solution
-- ============================================================================

-- Create the database
CREATE DATABASE IF NOT EXISTS ZENITH_INSURANCE_INTELLIGENCE;

-- Use the database
USE DATABASE ZENITH_INSURANCE_INTELLIGENCE;

-- Create schemas
CREATE SCHEMA IF NOT EXISTS RAW;
CREATE SCHEMA IF NOT EXISTS ANALYTICS;

-- Create a virtual warehouse for query processing
CREATE OR REPLACE WAREHOUSE ZENITH_WH WITH
    WAREHOUSE_SIZE = 'X-SMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    INITIALLY_SUSPENDED = TRUE
    COMMENT = 'Warehouse for Zenith Insurance Intelligence Agent queries';

-- Set the warehouse as active
USE WAREHOUSE ZENITH_WH;

-- Display confirmation
SELECT 'Database, schema, and warehouse setup completed successfully' AS STATUS;


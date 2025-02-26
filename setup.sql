USE ROLE ACCOUNTADMIN;
CREATE ROLE IF NOT EXISTS NOTEBOOK_ROLE;

GRANT CREATE DATABASE ON ACCOUNT TO ROLE NOTEBOOK_ROLE;
GRANT CREATE WAREHOUSE ON ACCOUNT TO ROLE NOTEBOOK_ROLE;
GRANT CREATE COMPUTE POOL ON ACCOUNT TO ROLE NOTEBOOK_ROLE;
GRANT CREATE INTEGRATION ON ACCOUNT TO ROLE NOTEBOOK_ROLE;
GRANT MONITOR USAGE ON ACCOUNT TO ROLE NOTEBOOK_ROLE;
GRANT BIND SERVICE ENDPOINT ON ACCOUNT TO ROLE NOTEBOOK_ROLE;
GRANT IMPORTED PRIVILEGES ON DATABASE SNOWFLAKE TO ROLE NOTEBOOK_ROLE;
GRANT ROLE NOTEBOOK_ROLE TO ROLE ACCOUNTADMIN;

// Create Database, Warehouse, and Image stage
USE ROLE NOTEBOOK_ROLE;
CREATE OR REPLACE DATABASE NOTEBOOK_DEMO_DB;
CREATE OR REPLACE SCHEMA MERIDIAN_SCHEMA;

USE DATABASE NOTEBOOK_DEMO_DB;
USE SCHEMA MERIDIAN_SCHEMA;

USE ROLE NOTEBOOK_ROLE;

// Create the warehouse for notebook usage
// Note - this is not the compute that runs the models, just orchestrates the notebook itself.
CREATE OR REPLACE WAREHOUSE NOTEBOOK_WH
    WAREHOUSE_SIZE = XSMALL
    AUTO_SUSPEND = 120
    AUTO_RESUME = TRUE;

// We will create two separate pools for general usage
CREATE COMPUTE POOL IF NOT EXISTS NOTEBOOK_POOL_CPU_XS
    MIN_NODES = 1
    MAX_NODES = 1
    INSTANCE_FAMILY = CPU_X64_XS
    AUTO_SUSPEND_SECS = 100
    INITIALLY_SUSPENDED = TRUE
    AUTO_RESUME = true
    COMMENT = 'XS CPU Pool for Notebook usage';

CREATE COMPUTE POOL IF NOT EXISTS NOTEBOOK_POOL_GPU_S
    MIN_NODES = 1
    MAX_NODES = 1
    INSTANCE_FAMILY = GPU_NV_S
    AUTO_SUSPEND_SECS = 100
    INITIALLY_SUSPENDED = TRUE
    AUTO_RESUME = true
    COMMENT = 'S GPU Pool for Notebook usage';

////////////////////////////////////////////////////////////////////////////////////////////////////
// Create the external access integrations that allow us to access pypi
////////////////////////////////////////////////////////////////////////////////////////////////////
USE ROLE ACCOUNTADMIN;

-- Integration: Pypi for access to key python packages like `diffusers`
CREATE OR REPLACE NETWORK RULE PYPI_NETWORK_RULE
    TYPE = HOST_PORT
    MODE = EGRESS
    VALUE_LIST = ('pypi.org', 'pypi.python.org', 'pythonhosted.org',  
                  'files.pythonhosted.org', 'github.com');

CREATE OR REPLACE EXTERNAL ACCESS INTEGRATION PYPI_ACCESS_INTEGRATION
    ALLOWED_NETWORK_RULES = (PYPI_NETWORK_RULE)
    ENABLED = true;

GRANT USAGE ON INTEGRATION PYPI_ACCESS_INTEGRATION TO ROLE NOTEBOOK_ROLE;

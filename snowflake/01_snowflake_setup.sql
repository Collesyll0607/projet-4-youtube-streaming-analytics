-- =============================================================================
-- PROJET 4 : Script de Configuration Snowflake Cloud Data Warehouse
-- Informations extraites directement de l'interface Snowflake :
--   - Compte Snowflake : kyykmpb-lu82975 (Account Locator: LU82975)
--   - Utilisateur      : COLLE
--   - Rôle Utilisé     : ACCOUNTADMIN
--   - Virtual Warehouse: COMPUTE_WH (X-Small)
--   - Database         : YOUTUBE_DATA_WH
--   - Schéma           : PUBLIC
-- =============================================================================

USE ROLE ACCOUNTADMIN;

-- 1. Utilisation ou création du Virtual Warehouse
CREATE WAREHOUSE IF NOT EXISTS COMPUTE_WH
    WITH WAREHOUSE_SIZE = 'XSMALL'
    AUTO_SUSPEND = 300
    AUTO_RESUME = TRUE
    COMMENT = 'Virtual Warehouse par défaut pour les traitements YouTube Data v3';

USE WAREHOUSE COMPUTE_WH;

-- 2. Création de la Base de Données YOUTUBE_DATA_WH
CREATE DATABASE IF NOT EXISTS YOUTUBE_DATA_WH;
USE DATABASE YOUTUBE_DATA_WH;
USE SCHEMA PUBLIC;

-- 3. Validation des droits d'accès pour l'utilisateur COLLE
GRANT ALL PRIVILEGES ON DATABASE YOUTUBE_DATA_WH TO USER COLLE;
GRANT ALL PRIVILEGES ON WAREHOUSE COMPUTE_WH TO USER COLLE;
GRANT USAGE ON SCHEMA YOUTUBE_DATA_WH.PUBLIC TO USER COLLE;

-- 4. Création du Format de Fichier JSON et Stage de Préparation
CREATE OR REPLACE FILE FORMAT json_file_format
    TYPE = 'JSON'
    STRIP_OUTER_ARRAY = TRUE
    IGNORE_UTF8_ERRORS = TRUE;

CREATE OR REPLACE STAGE YOUTUBE_STAGE
    FILE_FORMAT = json_file_format
    COMMENT = 'Stage Snowflake pour le chargement des données streaming YouTube Kafka';

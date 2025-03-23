/*
=============================================================
Create Database and Schemas
=============================================================
Script Purpose:
    This script creates a new database named 'Warehouse' after checking if it already exists. 
    If the database exists, it is dropped and recreated. Additionally, the script sets up three schemas 
    within the database: 'bronze', 'silver', and 'gold'.
	
WARNING:
    Running this script will drop the entire 'Warehouse' database if it exists. 
    All data in the database will be permanently deleted. Proceed with caution 
    and ensure you have proper backups before running this script.
*/

USE mysql;

-- Drop and recreate the 'Warehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'warehouse')
BEGIN
    ALTER DATABASE Warehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Warehouse;
END;


-- Create the 'DataWarehouse' database
CREATE DATABASE Warehouse;

USE Warehouse;

-- Create Schemas
CREATE SCHEMA bronze;


CREATE SCHEMA silver;


CREATE SCHEMA gold;

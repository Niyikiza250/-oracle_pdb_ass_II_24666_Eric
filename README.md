# Oracle_pdb_ass_II_24666_Eric
This project documents a comprehensive hands-on workshop for Oracle Database 19c Pluggable Database (PDB) Administration. The workshop demonstrates fundamental and intermediate-level PDB management skills in a multitenant architecture environment.
## Table of Contents
Creating a PDB-----------------------------------------

Managing PDB State--------------------------------------

Working Within a PDB------------------------------------

User Management------------------------------------------

Monitoring and Queries----------------------------------

Creating and Dropping Temporary PDBs----------------------
## Creating a PDB
CREATE PLUGGABLE DATABASE ER_PDB_24666
ADMIN USER Eric_Admin IDENTIFIED BY Programming@2026
FILE_NAME_CONVERT = ('D:\ORACLE_19C\ORADATA\ORCL\PDBSEED\',
                     'D:\ORACLE_19C\ORADATA\ORCL\ER_PDB_24666\');

  ### What this does:
  Creates a new PDB named ER_PDB_24666

Creates an admin user Eric_Admin with DBA privileges within the PDB

Copies data files from seed location to your new PDB directory

The admin user can create other users, tablespaces, and manage the PDB

## Managing PDB State
### Open a PDB
ALTER PLUGGABLE DATABASE ER_PDB_24666 OPEN;

### Save State (Auto-open on CDB restart)
*ALTER PLUGGABLE DATABASE ER_PDB_24666 SAVE STATE;*
##  Working Within a PDB
### Switch to a PDB Container
-- Switch from CDB$ROOT to your PDB
ALTER SESSION SET CONTAINER = ER_PDB_24666;

-- Verify you're in the right container
SHOW CON_NAME;
-- or
SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM DUAL;
### Show Current PDB (when in container)
SHOW PDBS;
## User Management
### Create a Local User in PDB
-- First, ensure you're connected to the target PDB
ALTER SESSION SET CONTAINER = ER_PDB_24666;

CREATE USER eric_plsqlauca_24666 IDENTIFIED BY strong_password
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA 100M ON users;
### Parameter Explanation:
DEFAULT TABLESPACE users: Where user's objects (tables, indexes) are stored

TEMPORARY TABLESPACE temp: Where sorting operations use space

QUOTA 100M ON users: Limits user to 100MB in the users tablespace

## View All Users
-- Simple view
SELECT username, account_status, default_tablespace, created 
FROM dba_users 
ORDER BY created DESC;

-- Detailed view with privileges
SELECT u.username,
       u.account_status,
       u.created,
       COUNT(DISTINCT sp.privilege) as system_privileges,
       COUNT(DISTINCT tp.privilege) as object_privileges
FROM dba_users u
LEFT JOIN dba_sys_privs sp ON u.username = sp.grantee
LEFT JOIN dba_tab_privs tp ON u.username = tp.grantee
WHERE u.username NOT IN ('SYS','SYSTEM','DBSNMP','XDB')
GROUP BY u.username, u.account_status, u.created
ORDER BY u.created DESC;
### Check Specific User
SELECT username, account_status FROM dba_users WHERE username = 'ERIC_USER';
## Monitoring and Queries
### List All PDBs in CDB
-- From CDB$ROOT
SELECT name, open_mode, restricted, creation_time 
FROM v$pdbs
ORDER BY creation_time DESC;

-- Or simpler
SHOW PDBS;
### Check PDB Status from Data Dictionary
SELECT pdb_id, pdb_name, status 
FROM dba_pdbs;
### Find PDB by Name Pattern
SELECT name FROM v$pdbs WHERE name LIKE '%24666%';
### View Data Files for a Specific PDB
SELECT file_name, bytes/1024/1024 AS size_mb 
FROM cdb_data_files 
WHERE con_id = (SELECT con_id FROM v$pdbs WHERE name = 'ER_TO_DELETE_PDB_24666');
### Monitor Tablespace Usage in PDB
-- From CDB$ROOT, monitoring a specific PDB
SELECT 
    v.name as pdb_name,
    t.tablespace_name,
    ROUND(t.used_space * 8192 / 1024 / 1024, 2) as used_mb,
    ROUND(t.tablespace_size * 8192 / 1024 / 1024, 2) as total_mb,
    ROUND((t.used_space * 100) / t.tablespace_size, 2) as pct_used
FROM cdb_tablespace_usage_metrics t
JOIN v$pdbs v ON t.con_id = v.con_id
WHERE v.name = 'ER_PDB_24666'
ORDER BY t.tablespace_name;
## Creating and Dropping Temporary PDBs
### Create a Temporary/Test PDB
-- From CDB$ROOT
CREATE PLUGGABLE DATABASE er_to_delete_pdb_24666
ADMIN USER pdb_admin IDENTIFIED BY "YourPassword123"
FILE_NAME_CONVERT = ('D:\ORACLE_19C\ORADATA\ORCL\PDBSEED\', 
                      'D:\ORACLE_19C\ORADATA\ORCL\temp_test_pdb\');

  ### Open the New PDB
  ALTER PLUGGABLE DATABASE er_to_delete_pdb_24666 OPEN;
  ### Verify Creation
  SELECT NAME, OPEN_MODE FROM V$PDBS;
  ### Properly Drop a PDB (Complete Workflow)
  -- Step 1: Ensure you're in CDB$ROOT
ALTER SESSION SET CONTAINER = CDB$ROOT;

-- Step 2: If PDB is closed/mounted, open it first
ALTER PLUGGABLE DATABASE er_to_delete_pdb_24666 OPEN;

-- Step 3: Close it (required before drop)
ALTER PLUGGABLE DATABASE er_to_delete_pdb_24666 CLOSE IMMEDIATE;

-- Step 4: Drop it including data files
DROP PLUGGABLE DATABASE er_to_delete_pdb_24666 INCLUDING DATAFILES;

-- Step 5: Verify it's gone
SELECT name FROM v$pdbs WHERE name = 'ER_TO_DELETE_PDB_24666';

Repository (https://github.com/Niyikiza250/-oracle_pdb_ass_II_24666_Eric)
PDB Name Created	ER_PDB_24666
Issues Encountered	Yes
Database Version	Oracle 19c
Environment	Windows (D:\ORACLE_19C)

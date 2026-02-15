CREATE PLUGGABLE DATABASE ER_PDB_24666
ADMIN USER Eric_Admin IDENTIFIED BY strong_password
FILE_NAME_CONVERT = ('D:\ORACLE_19C\ORADATA\ORCL\PDBSEED\',
                     'D:\ORACLE_19C\ORADATA\ORCL\ER_PDB_24666\');
                     
                     show pdbs;
                     
ALTER PLUGGABLE DATABASE ER_PDB_24666 OPEN;

ALTER PLUGGABLE DATABASE ER_PDB_24666 SAVE STATE;




ALTER SESSION SET CONTAINER = ER_PDB_24666;
show pdbs;

CREATE USER eric_plsqlauca_24666 IDENTIFIED BY strong_password
DEFAULT TABLESPACE users
TEMPORARY TABLESPACE temp
QUOTA 100M ON users;

SELECT username, account_status FROM dba_users WHERE username = 'ERIC_USER';

SELECT pdb_id, pdb_name, status 
FROM dba_pdbs;


SELECT username, default_tablespace, created 
FROM dba_users 
ORDER BY created DESC;

ALTER SESSION SET CONTAINER = CDB$ROOT;

SELECT SYS_CONTEXT('USERENV', 'CON_NAME') FROM DUAL;

CREATE PLUGGABLE DATABASE er_to_delete_pdb_24666
ADMIN USER pdb_admin IDENTIFIED BY "YourPassword123"
FILE_NAME_CONVERT = ('D:\ORACLE_19C\ORADATA\ORCL\PDBSEED\', 
                      'D:\ORACLE_19C\ORADATA\ORCL\temp_test_pdb\');
                      
                      ALTER PLUGGABLE DATABASE er_to_delete_pdb_24666 OPEN;
                      
                      SELECT NAME, OPEN_MODE FROM V$PDBS;
                      
                      SELECT NAME FROM V$PDBS WHERE NAME LIKE '%24666%';
                      
                      
                      ALTER SESSION SET CONTAINER = er_to_delete_pdb_24666;
SHOW CON_NAME;

SHOW PDBS;

SELECT name, open_mode, restricted, creation_time 
FROM v$pdbs
ORDER BY creation_time DESC;

SELECT file_name, bytes/1024/1024 AS size_mb 
FROM cdb_data_files 
WHERE con_id = (SELECT con_id FROM v$pdbs WHERE name = 'ER_TO_DELETE_PDB_24666');

ALTER SESSION SET CONTAINER = CDB$ROOT;

ALTER PLUGGABLE DATABASE er_to_delete_pdb_24666 OPEN;

ALTER PLUGGABLE DATABASE er_to_delete_pdb_24666 CLOSE IMMEDIATE;

DROP PLUGGABLE DATABASE er_to_delete_pdb_24666 INCLUDING DATAFILES;

SELECT name FROM v$pdbs WHERE name = 'ER_TO_DELETE_PDB_24666';


ALTER SESSION SET CONTAINER = ER_PDB_24666;

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



-- Show users and their system privileges
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



SELECT username, tablespace_name, max_bytes/1024/1024 as max_mb
FROM dba_ts_quotas
ORDER BY username;
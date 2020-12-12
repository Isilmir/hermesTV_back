CREATE LOGIN admin   
    WITH PASSWORD = '12345';  
USE HermesTV;  
CREATE USER admin FOR LOGIN admin   

exec sp_addrolemember 'db_owner', 'admin'

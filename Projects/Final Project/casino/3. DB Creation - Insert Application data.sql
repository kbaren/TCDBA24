/********* INSERT/CHANGE application deffinition and files path *********/

INSERT INTO reference.utbl_Country (COUNTRY)
VALUES ('England');
INSERT INTO reference.utbl_Country (COUNTRY)
VALUES ( 'France');
INSERT INTO reference.utbl_Country (COUNTRY)
VALUES ( 'Israel');
INSERT INTO reference.utbl_Country (COUNTRY)
VALUES ( 'USA');
INSERT INTO reference.utbl_Country (COUNTRY)
VALUES ( 'Ireland')

INSERT INTO [Reference].[utbl_Gender] ([Gender])
VALUES ('F');
INSERT INTO [Reference].[utbl_Gender] ([Gender])
VALUES ('M');
GO

exec usp_SymbolTableFiller

DBCC CHECKIDENT ('Security.utbl_CasinoManagers', RESEED, 0)
delete from [Security].[utbl_CasinoManagers]
INSERT INTO [Security].[utbl_CasinoManagers] (ManagerName, GameName)
VALUES ('Anne','slotMachine');
INSERT INTO [Security].[utbl_CasinoManagers] (ManagerName, GameName)
VALUES ( 'Avi','blackJack');
INSERT INTO [Security].[utbl_CasinoManagers] (ManagerName, GameName)
VALUES ('Karina','slotMachine');
INSERT INTO [Security].[utbl_CasinoManagers] (ManagerName, GameName)
VALUES ( 'Kari','blackJack');

exec usp_CompanyDefinitions 'insert', 'welcomeBonus', '10'
exec usp_CompanyDefinitions 'insert', 'logonTimes', '5'
exec usp_CompanyDefinitions 'insert', 'betBonus', '50'
exec usp_CompanyDefinitions 'insert', 'MinimumAge', '18'
exec usp_CompanyDefinitions 'insert', 'maxDepositAmnt', '1000'
exec usp_CompanyDefinitions 'insert', 'minBetAmntForBonus', '1000'
exec usp_CompanyDefinitions 'insert', 'creditCardDigitAmnt', '16'
exec usp_CompanyDefinitions 'insert', 'adminMailAddress', 'bentovim.avigail@gmail.com'
exec usp_CompanyDefinitions 'insert', 'numConnectionsAlert', '100'
exec usp_CompanyDefinitions 'insert', 'numMinsNoLoginsAlert', '10'
exec usp_CompanyDefinitions 'insert', 'fullBackupDest', 'D:\CourseMaterials\casino\BackupFiles\Full.bak'
exec usp_CompanyDefinitions 'insert', 'fullBackupName', 'New Full backup Casino'
exec usp_CompanyDefinitions 'insert', 'fullBackupDescrb', 'New Daily Full backup for Casino DB'

exec usp_CompanyDefinitions 'insert', 'diffBackupDest', 'D:\CourseMaterials\casino\BackupFiles\Diff.bak'
exec usp_CompanyDefinitions 'insert', 'diffBackupName', 'New Diff backup Casino'
exec usp_CompanyDefinitions 'insert', 'diffBackupDescrb', 'New Diff backup for Casino DB'

exec usp_CompanyDefinitions 'insert', 'logBackupDest', 'D:\CourseMaterials\casino\BackupFiles\Log.bak'
exec usp_CompanyDefinitions 'insert', 'logBackupName', 'New Log backup Casino'
exec usp_CompanyDefinitions 'insert', 'logBackupDescrb', 'New Log backup for Casino DB'
exec usp_CompanyDefinitions 'insert', 'adminActivePlayer', '5'

exec usp_CompanyDefinitions 'insert', 'strongPassLength', '5'

--exec usp_CompanyDefinitions 'update', 'fullBackupDest', 'D:\CourseMaterials\casino\BackupFiles\Full.bak'
--exec usp_CompanyDefinitions 'update', 'diffBackupDest', 'D:\CourseMaterials\casino\BackupFiles\Diff.bak'
--exec usp_CompanyDefinitions 'update', 'logBackupDest', 'D:\CourseMaterials\casino\BackupFiles\Log.bak'

--for testing
--exec usp_CompanyDefinitions 'update', 'numConnectionsAlert', '1'
--exec usp_CompanyDefinitions 'update', 'numMinsNoLoginsAlert', '10'
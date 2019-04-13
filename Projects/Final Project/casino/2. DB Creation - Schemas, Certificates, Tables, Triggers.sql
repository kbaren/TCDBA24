/****** Object:  Database [Casino]    Script Date: 19-Mar-19 12:36:39 PM ******/

------ Schemas Creation

USE [Casino]
GO

IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'Reference')
   BEGIN
      PRINT 'Dropping the DB schema'
      DROP SCHEMA [Reference]
END
GO
PRINT '    Creating the Reference schema'
GO
CREATE SCHEMA [Reference] AUTHORIZATION [dbo]
GO

IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'Games')
   BEGIN
      PRINT 'Dropping the Games schema'
      DROP SCHEMA [Games]
END
GO
PRINT '    Creating the Games schema'
GO
CREATE SCHEMA [Games] AUTHORIZATION [dbo]
GO

IF EXISTS (SELECT name FROM sys.schemas WHERE name = N'Admin')
   BEGIN
      PRINT 'Dropping the Admin schema'
      DROP SCHEMA [Admin]
END
GO
PRINT '    Creating the Admin schema'
GO
CREATE SCHEMA [Admin] AUTHORIZATION [dbo]
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'Security' ) 
    EXEC('CREATE SCHEMA [Security] AUTHORIZATION [dbo]');
GO
select user_name()
go

------ Keys and Certificates

USE Casino;  
GO  
-- Create Master key for certificates
drop MASTER KEY
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'CasinoProject_TCDBA24'   
GO  
-- Create certificate CreditCard
drop CERTIFICATE CreditCards_certificate
CREATE CERTIFICATE CreditCards_certificate
   WITH SUBJECT = 'Players Credit Cards numbers';  

GO

-- Create encryption key CreditCard
CREATE SYMMETRIC KEY CreditCard_key  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE CreditCards_certificate;  

GO

-- Create certificate Password
CREATE CERTIFICATE Password_certificate
   WITH SUBJECT = 'Players Passwords';  

GO

-- Create encryption key Password
CREATE SYMMETRIC KEY Password_key  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE Password_certificate;  

------ Tables creation

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

-- Reference Tables

DROP TABLE IF EXISTS [Reference].[utbl_SymbolTable]
CREATE TABLE [Reference].[utbl_SymbolTable](
	[Id]		INT IDENTITY(1,1) NOT NULL,
	[Symbol]	[char] NOT NULL
) ON [PRIMARY]

GO

DROP TABLE IF EXISTS [Reference].[utbl_Country]
CREATE TABLE [Reference].[utbl_Country](
	ID			INT IDENTITY(1,1) NOT NULL,
	[Country]	[nvarchar](50) NOT NULL
) ON [PRIMARY]

GO

DROP TABLE IF EXISTS [Reference].[utbl_Gender]
CREATE TABLE [Reference].[utbl_Gender](
	ID			INT IDENTITY(1,1) NOT NULL,
	[Gender]	[nchar](1) NOT NULL
) ON [PRIMARY]

GO

DROP TABLE IF EXISTS [Reference].[utbl_GitPasswords]
CREATE TABLE [Reference].[utbl_GitPasswords](
	ExtPassword	NVARCHAR(100) NOT NULL
) ON [PRIMARY]

GO

DROP TABLE IF EXISTS [Reference].[Temp_utbl_GitPasswords]
CREATE TABLE [Reference].[utbl_GitPasswords](
	ExtPassword	NVARCHAR(100) NOT NULL
) ON [PRIMARY]

GO

-- Games Tables

DROP TABLE IF EXISTS [Games].[utbl_CardTable]
CREATE TABLE [Games].[utbl_CardTable](
	[Id]		[int] IDENTITY(1,1) NOT NULL,
	[CardNum]	[int] NOT NULL
) ON [PRIMARY]

GO

DROP SECURITY POLICY IF EXISTS GamesPolicyFilter
drop function IF EXISTS Security.udf_securitypredicate
GO
DROP TABLE IF EXISTS [Games].[utbl_Games]
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [Games].[utbl_Games](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[gameName] [nvarchar](50) NOT NULL,
	[userName] usernameDt,
	[win] [tinyint] NULL,
	[roundNum] [int] NOT NULL,
	[gameDate] [datetime] NULL,
	[transactionId] [int] NOT NULL) ON [PRIMARY]
GO

-- Admin Tables

DROP TABLE IF EXISTS [Admin].[utbl_CompanyDefinitions]
CREATE TABLE [Admin].[utbl_CompanyDefinitions](
	[CompanyKey] [nvarchar](20) NOT NULL,
	[CompanyValue] [nvarchar] (100) NOT NULL,

 CONSTRAINT [PK_utbl_CompanyDefinitions] PRIMARY KEY CLUSTERED 
([CompanyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO

ALTER TABLE [admin].[utbl_Players] SET ( SYSTEM_VERSIONING = OFF )
GO
DROP TABLE IF EXISTS [admin].[utbl_Players]
DROP TABLE IF EXISTS [admin].[utbl_PlayersHistory]
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[utbl_Players](
	[UserName] usernameDt,
	[PlayerPassword] playerPasswordDt,
	[FirstName] firstNameDt,
	[LastName] lastNameDt,
	[PlayerAddress] addressDt,
	[Country] countryDt,
	[EmailAddress] emailAddressDt,
	[Gender] genderDt,
	[BirthDate] birthDateDt,
	[NumFails] [int] NULL,
	[IsBlocked] [nchar](1) NULL,
	[LoginTime] [datetime] NULL,
	[IsConnected] [nchar](1) NULL,
  CONSTRAINT PLR_PK PRIMARY KEY (UserName),
    ValidFrom datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
  PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)) 
  WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Admin.utbl_PlayersHistory, 
  DATA_CONSISTENCY_CHECK = ON));

GO

DROP TABLE IF EXISTS [Admin].[utbl_CreditCard]
CREATE TABLE [Admin].utbl_CreditCard 
	(
	ID					INT NOT NULL IDENTITY,
	UserName			usernameDt,
	CreditCardNumber	VARBINARY(128) NOT NULL,
	ExpiryDate			NVARCHAR(10) NOT NULL
	CONSTRAINT [PK_utbl_CreditCard] PRIMARY KEY CLUSTERED 
		(ID ASC
		)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
	) ON [PRIMARY]

GO

DROP TABLE IF EXISTS [Admin].[utbl_ApplicationLog]
CREATE TABLE [Admin].[utbl_ApplicationLog](
	[id] [int] IDENTITY(1,1) NOT NULL,
	[objectName] [nvarchar](50) NOT NULL,
	[variables] [nvarchar](500) NULL,
	[comments] [nvarchar](500) NOT NULL,
	[execTime] [datetime]
) ON [PRIMARY] 

GO

DROP TABLE IF EXISTS [Admin].[utbl_transactions]
CREATE TABLE [Admin].[utbl_transactions](
	[transactionId] [int] IDENTITY(1,1) NOT NULL,
	[transactionType] transactionTypeDt NOT NULL,
	[transactionAmount] transactionAmountDt NOT NULL,
	[username] usernameDt FOREIGN KEY REFERENCES [admin].[utbl_Players](UserName),
	[transDate] [datetime] NULL
) ON [PRIMARY]
GO

-- Security Tables

DROP TABLE IF EXISTS [Security].[utbl_CasinoManagers]
CREATE TABLE [Security].[utbl_CasinoManagers](
	[CasinoManagerID] [int] IDENTITY(1,1) NOT NULL,
	[ManagerName] [nvarchar](50) NOT NULL,
	[GameName] [nvarchar](20) NOT NULL
) ON [PRIMARY] 

----TEST
--CREATE USER Archer WITHOUT LOGIN
----GRANT SELECT ON Sales.Orders TO Archer		
--EXECUTE AS USER = 'Archer'								-- Run as Airi
--select user_name()
--select * from utbl_games
--select * from security.utbl_casinoManagers
--REVERT


GO  

------ Triggers creation

DROP TABLE IF EXISTS [Security].[utbl_Transactions_audit]
CREATE TABLE [Security].[utbl_Transactions_audit](
    transactionID		INT PRIMARY KEY NOT NULL,
    username			usernameDt,
    transactionAmount	transactionAmountDt,
    transactionType		transactionTypeDt,
    transDate			datetime NOT NULL,
    operation			nvarchar(10) NOT NULL,
    CHECK(operation = 'Inserted' or operation='Deleted'),
	currentUser			usernameDt,
	currentLogin		usernameDt
);
USE Casino
GO
CREATE OR ALTER TRIGGER ADMIN.trg_transaction_audit
ON [Admin].[utbl_Transactions]
AFTER INSERT, DELETE, UPDATE
NOT FOR REPLICATION
AS
BEGIN
	DECLARE @CurrentUser	usernameDt,
			@CurrentLogin	usernameDt

	SELECT	@CurrentUser = CURRENT_USER,
			@CurrentLogin = ORIGINAL_LOGIN( ) 

    SET NOCOUNT ON;
    INSERT INTO [Security].[utbl_Transactions_audit](
    transactionID		,
    username			,
    transactionAmount	,
    transactionType				,
    transDate	,
	operation,
	currentUser,
	currentLogin
    )
    SELECT
        i.transactionID,
        i.username,
        i.transactionAmount,
        i.transactionType,
        i.transDate,
        'Inserted',
		i.currentUser,
		i.currentLogin
    FROM
        inserted i
    UNION ALL
    SELECT
        d.transactionID,
        d.username,
        d.transactionAmount,
        d.transactionType,
        d.transDate,
        'Deleted',
		d.currentUser,
		d.currentLogin
    FROM
        deleted d;
END

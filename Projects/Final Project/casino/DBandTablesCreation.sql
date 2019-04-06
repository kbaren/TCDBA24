USE [master]
GO

/****** Object:  Database [Casino]    Script Date: 19-Mar-19 12:36:39 PM ******/
--CREATE DATABASE [Casino]
-- CONTAINMENT = NONE
-- ON  PRIMARY 
--( NAME = N'fgMaster', FILENAME = N'D:\CourseMaterials\eDate\eDate_new_Master.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 7168KB )
-- LOG ON 
--( NAME = N'Fg_log_Log', FILENAME = N'D:\CourseMaterials\eDate\eDate_new_Log.ldf' , SIZE = 5120KB , MAXSIZE = 2048GB , FILEGROWTH = 3072KB )
--GO

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
/****** Object:  Table [dbo].[utbl_CardTable]    Script Date: 21-Mar-19 5:12:00 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Games].[utbl_CardTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[CardNum] [int] NOT NULL
) ON [PRIMARY]
GO

USE [Casino]
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Reference].[utbl_SymbolTable](
	[Id] [int] IDENTITY(1,1) NOT NULL,
	[Symbol] [char] NOT NULL
) ON [PRIMARY]
GO
/****** Object:  Table [dbo].[utbl_CompanyDefinitions]    Script Date: 21-Mar-19 5:12:14 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Admin].[utbl_CompanyDefinitions](
	[CompanyKey] [nvarchar](20) NOT NULL,
	[CompanyValue] [int] NOT NULL,
 CONSTRAINT [PK_utbl_CompanyDefinitions] PRIMARY KEY CLUSTERED 
(
	[CompanyKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [Casino]
GO

/****** Object:  Table [dbo].[utbl_Country]    Script Date: 21-Mar-19 5:12:23 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Reference].[utbl_Country](
	[Country] [nvarchar](50) NOT NULL
) ON [PRIMARY]
GO

USE [Casino]
GO

/****** Object:  Table [dbo].[utbl_CreditCard]    Script Date: 21-Mar-19 5:12:33 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Admin].[utbl_CreditCard](
	[CreditCardNumber] [int] NOT NULL,
	[ExpiryDate] [datetime] NOT NULL,
 CONSTRAINT [PK_utbl_CreditCard] PRIMARY KEY CLUSTERED 
(
	[CreditCardNumber] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [Casino]
GO

/****** Object:  Table [dbo].[utbl_Games]    Script Date: 21-Mar-19 5:12:45 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Games].[utbl_Games](
	[ID] [int] IDENTITY(1,1) NOT NULL,
	[GameName] [nvarchar](50) NOT NULL,
	[UserName] [nvarchar](20) NOT NULL,
	[NumWins] [int] NULL,
	[NumLosses] [int] NULL,
	[GameDate] [datetime] NULL,
 CONSTRAINT [PK_utbl_Games] PRIMARY KEY CLUSTERED 
(
	[ID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [Casino]
GO

/****** Object:  Table [dbo].[utbl_Gender]    Script Date: 21-Mar-19 5:12:58 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Reference].[utbl_Gender](
	[Gender] [nchar](1) NOT NULL
) ON [PRIMARY]
GO

USE [Casino]
GO

--/****** Object:  Table [dbo].[utbl_PlayerBankroll]    Script Date: 21-Mar-19 5:13:20 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Admin].[utbl_PlayerBankroll](
	[TransactionID] [int] IDENTITY(1,1) NOT NULL,
	[UserName] [nvarchar](20) NOT NULL,
	[CurrentBankRoll] [int] NOT NULL,
	[DepositAmt] [int] NULL,
	[WithdrawalAmt] [int] NULL,
	[WinAmt] [int] NULL,
	[LossAmt] [int] NULL,
	[TransDate] [datetime] NULL,
 CONSTRAINT [PK_utbl_PlayerBankroll] PRIMARY KEY CLUSTERED 
(
	[TransactionID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

USE [Casino]
GO

--/****** Object:  Table [Security].[utbl_CasinoManagers]    Script Date: 21-Mar-19 5:13:30 PM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [Security].[utbl_CasinoManagers](
	[CasinoManagerID] [int] IDENTITY(1,1) NOT NULL,
	[ManagerName] [nvarchar](50) NOT NULL,
	[GameName] [nvarchar](20) NOT NULL
) ON [PRIMARY] 

USE [Casino]
GO

/****** Object:  Table [dbo].[utbl_Players]    Script Date: 21-Mar-19 5:13:38 PM ******/
SET ANSI_NULLS ON
GO
ALTER TABLE [admin].[utbl_Players] SET ( SYSTEM_VERSIONING = OFF )
GO
drop TABLE [admin].[utbl_Players]
drop TABLE admin.[utbl_PlayersHistory]
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [admin].[utbl_Players](
	[UserName] [nvarchar](50) NOT NULL,
	[PlayerPassword] [nvarchar](50) NOT NULL,
	[FirstName] [nvarchar](20) NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[PlayerAddress] [nvarchar](60) NOT NULL,
	[Country] [nvarchar](15) NULL,
	[EmailAddress] [nvarchar](50) NOT NULL,
	[Gender] [nchar](1) NULL,
	[BirthDate] [datetime] NOT NULL,
	[NumFails] [int] NULL,
	[IsBlocked] [nchar](1) NULL,
	[LoginTime] [datetime] NULL,
	[IsConnected] [nchar](1) NULL,
  CONSTRAINT EMP_PK PRIMARY KEY (UserName),
    ValidFrom datetime2 GENERATED ALWAYS AS ROW START NOT NULL,
    ValidTo datetime2 GENERATED ALWAYS AS ROW END NOT NULL,
  PERIOD FOR SYSTEM_TIME (ValidFrom, ValidTo)) 
  WITH (SYSTEM_VERSIONING = ON (HISTORY_TABLE = Admin.utbl_PlayersHistory, 
  DATA_CONSISTENCY_CHECK = ON));
GO

IF NOT EXISTS ( SELECT  *
                FROM    sys.schemas
                WHERE   name = N'Security' ) 
    EXEC('CREATE SCHEMA [Security] AUTHORIZATION [dbo]');
GO
select user_name()
go





----TEST
--CREATE USER Archer WITHOUT LOGIN
----GRANT SELECT ON Sales.Orders TO Archer		
--EXECUTE AS USER = 'Archer'								-- Run as Airi
--select user_name()
--select * from utbl_games
--select * from security.utbl_casinoManagers
--REVERT	
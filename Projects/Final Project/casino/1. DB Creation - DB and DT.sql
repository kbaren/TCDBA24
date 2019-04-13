
------ DB Creation

USE master

IF EXISTS(select * from sys.databases where name='Casino')
DROP DATABASE [Casino]
declare @dataPath nvarchar(max)
declare @logPath nvarchar(max)
declare @sql nvarchar(max)

set @dataPath = 'D:\CourseMaterials\eDate\eDate_new_Master.mdf'
set @logPath = 'D:\CourseMaterials\eDate\eDate_new_Log.ldf'

set @sql = 'CREATE DATABASE [Casino]
			CONTAINMENT = NONE
			ON  PRIMARY 
			(NAME = ''fgMaster'', 
			FILENAME = '''+ @dataPath+''' , SIZE = 8192KB , 
			MAXSIZE = UNLIMITED, FILEGROWTH = 7168KB) 
			LOG ON 
			(NAME = ''Fg_log_Log'', FILENAME = '''+@logPath+''' , SIZE = 5120KB , 
			MAXSIZE = 2048GB , FILEGROWTH = 3072KB)'
print @sql
exec (@sql)

------ DataTypes creation
USE [Casino]
GO

--datatype for password 
/****** Object:  UserDefinedDataType [playerPassword]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [playerPasswordDt] FROM VARBINARY(128) NOT NULL
GO



--datatype for username
/****** Object:  UserDefinedDataType [username]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [usernameDt] FROM [nvarchar](10) NOT NULL
GO



--datatype for  firstName
/****** Object:  UserDefinedDataType [firstName]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [firstNameDt] FROM [nvarchar](20) NOT NULL MASKED WITH (FUNCTION = 'default()')
GO



--datatype for lastName
/****** Object:  UserDefinedDataType [lastName]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [lastNameDt] FROM [nvarchar](20) NOT NULL MASKED WITH (FUNCTION = 'default()')
GO


--datatype for Address
/****** Object:  UserDefinedDataType [address]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [addressDt] FROM [nvarchar](100) NULL
GO


--datatype for country
/****** Object:  UserDefinedDataType [country]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [countryDt] FROM [nvarchar](15) NOT NULL
GO


--datatype for emailAddress
/****** Object:  UserDefinedDataType [emailAddress]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [emailAddressDt] FROM [nvarchar](100) NOT NULL MASKED WITH (FUNCTION = 'email()')
GO



--datatype for gender
/****** Object:  UserDefinedDataType [gender]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [genderDt] FROM [nchar](1) NULL
GO

--datatype for birthDate
/****** Object:  UserDefinedDataType [birthDate]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [birthDateDt] FROM datetime NOT NULL
GO

--datatype for transactionType
/****** Object:  UserDefinedDataType [transactionType]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [transactionTypeDt] FROM [nvarchar](10) NOT NULL
GO

--datatype for transactionAmount
/****** Object:  UserDefinedDataType [transactionAmount]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [transactionAmountDt] FROM [float] NOT NULL
GO

--datatype for gameName
/****** Object:  UserDefinedDataType [gameName]    Script Date: 03-Apr-19 12:27:27 PM ******/
CREATE TYPE [gameNameDt] FROM [nvarchar](15) NOT NULL
GO

SELECT * FROM sys.Types WHERE is_user_defined = 1



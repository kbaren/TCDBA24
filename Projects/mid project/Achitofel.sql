

create database Achitofel
go
use Achitofel;
go

CREATE TABLE [dbo].[CustAddress](
    [OfficeID] [int] Primary key,
	[CustomerID] [int] NOT NULL,
	[City] [nchar](5) NULL,
	[Address] [nvarchar](60) NULL,
	[Country] [nvarchar](15) NULL,
	[TravelPrice] [money] NULL

)

CREATE TABLE [dbo].[Customers](
	[CustomerID] [int] NOT NULL Primary key,
	[CustomerName] [nvarchar](20) NULL,
	[IsBlackList] [bit] NULL,
	[IsIsraeliCompany] [bit] NULL,
	[GroupID] [int],  foreign key ([GroupID]) references [Groups](GroupID)
)


CREATE TABLE [dbo].[CustomerAccount](
	[CustomerID] [int] NOT NULL, foreign key ([CustomerID]) references [Customers]([CustomerID]),
	[Date] [datetime] not null,
	[FullAmount] [money] NULL,
	[NetAmount] [money] NULL,
	[Taxes] [money] NULL,
	[IsPaid] [bit]
)

ALTER TABLE [CustomerAccount]
    ADD  PRIMARY KEY ([CustomerID], [Date])
GO

CREATE TABLE [dbo].[CustomerBlacklist](
	[CustomerID] [int] NOT NULL Primary key,
	[NoProjects] [int] Not Null
)

Create table [dbo].[Project](
	[CustomerID] [int] NOT NULL, FOREIGN key ([CustomerID]) REFERENCES [Customers]([CustomerID]),
	[ProjectID] [int] not null Primary key,
	[PAdminID] [int] NOT NULL, FOREIGN key ([PAdminID]) REFERENCES [ProjectAdmin]([PAdminID]),
    [IsBlackList] [bit] NULL
)

CREATE TABLE [dbo].[ProjectAdmin](
	[PAdminID] [int] not null Primary key,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[BirthDate] [datetime] NULL,
	[Address] [nvarchar](60) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[PostalCode] [nvarchar](10) NULL,
	[Country] [nvarchar](15) NULL,
	[CakeID] [int] not null,
	[IsPAManager] [bit] NULL,
	[CustomerID] [int] NOT NULL 
)

CREATE TABLE [dbo].[ProjectManager](
	[PAdminID] [int] not null Primary key,
	[BirthDateSpouse] [datetime] NULL,
	[SpouseCakeID] [int] not null,
	[NumberOfChildren] [int] NOT NULL 
)

CREATE TABLE [dbo].[ProjectWH](
	[OfficeID] [int] not null,
	[AdvisorID] [int] not null,
	[ProjectID] [int] not null,
	[CustomerID] [int] NOT NULL,
	[Date] [datetime] NULL,
	[StartWH] [datetime] NULL,
	[EndWH] [datetime] NULL,
	[WeekendHours] [int] not null,
	[HolidayHours] [int] not null,
	[WeekendHolidayHours] [int] not null,	
	[OverTimeHours] [int] not null,	
	[AdvisorPricePerHour] [int] not null
)

ALTER TABLE [ProjectWH]
    ADD  PRIMARY KEY ([OfficeID], [AdvisorID], [ProjectID])
GO

CREATE TABLE [dbo].[PAManagerChildren](
	[PAdminID] [int] not null,
	[BirthDate] [datetime] NULL,
	[ChildID] [int] not null Primary key,
	[CakeId] [int] not null
)


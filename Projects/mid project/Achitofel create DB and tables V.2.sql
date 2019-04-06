create database Achitofel
 on primary 
 (name = Achitofel , 
 filename = 'D:\SQL server\MSSQL14.MSSQLSERVER\MSSQL\DATA\Achitofel\Achitofel.mdf',
 size = 50MB)
 log on
 (name = Achitofel_Log , 
 filename = 'D:\SQL server\MSSQL14.MSSQLSERVER\MSSQL\Log\Achitofel\Achitofel_log.ldf',
 size = 50MB)

go

use Achitofel;
go
ALTER AUTHORIZATION ON DATABASE::Achitofel TO [sa]
go

Drop table If exists MonthlyWH
go
create table MonthlyWH
(	 [month] int NOT NULL,
	 [year] int NOT NULL,
	 [workdays] int NOT NULL,
	 [workhours] int NOT NULL
 )

ALTER TABLE [MonthlyWH]
    ADD  PRIMARY KEY ([month], [year])
GO

Drop table If exists ExchangeRate
go
create table ExchangeRate
(	 [currency] nvarchar(100) NOT NULL,
	 [date] datetime NOT NULL,
	 [rate] float NOT NULL
	 constraint pk_Exchange_Rate Primary key ([currency], [date])
 )

Drop table If exists Cakes
go
create table Cakes
(	 [cakeID] int NOT NULL Primary key,
	 [cakeType] nvarchar(50) NOT NULL
 )

 Drop table If exists Groups
go
 create table Groups
(	 [GroupID] int primary key NOT NULL,
	 [ResponsabilityField] nvarchar(100) NOT NULL
 )
 
 Drop table If exists Advisors
go
create table Advisors
(	 [AdvisorID] int Primary key NOT NULL,
	 [FirstName] nvarchar(50) NOT NULL,
	 [LastName] nvarchar(50) NOT NULL,
	 [MailingAdress] nvarchar(200) NOT NULL,
	 [HomeAdress] nvarchar(200) NOT NULL,
	 [GroupID] int NOT NULL Foreign key REFERENCES Groups([GroupID]) ,
	 [IsManager] bit,
	 [NumOfWarnings] tinyint NULL constraint warnings_less_equal_2_ck check ([NumOfWarnings]<=2),
	 [HireDate] datetime NOT NULL,
	 [EndDate] datetime NULL
 )
  
Drop table If exists Advisors_Children
go
create table Advisors_Children
(	 [childrenID] int Primary key NOT NULL,
	 [AdvisorID] int Foreign key REFERENCES Advisors(AdvisorID) NOT NULL,
	 [FirstName] nvarchar(50) NOT NULL,
	 [LastName] nvarchar(50) NOT NULL,
	 [BirthDate] datetime NOT NULL,
	 [IsUnder18] bit NOT NULL constraint Child_Younger_Than_18_ck check (datediff(yy,[BDate],getdate())<18),
	 [HomeAddress] nvarchar(200) NULL
 )
 
 Drop table If exists Advisor_Spouse
go
 create table Advisor_Spouse
(	 [SpouseID] int primary key Not null,
	 [AdvisorID] int Foreign key REFERENCES Advisors([AdvisorID]) NOT NULL,
	 [FirstName] nvarchar(50) NOT NULL,
	 [LastName] nvarchar(50) NOT NULL,
	 [HomeAddress] nvarchar(200) NULL
 )
  
 Drop table If exists Advisor_Salary
go
create table Advisor_Salary
(	 [AdvisorID] int Foreign key REFERENCES Advisors([AdvisorID]) not null,
	 [YearOfWork] int not null,
	 [BaseSalary] money Not null,
	 [SocialAddition] float not null,
	 [NumOfChildrenUnder18] int NULL, --gets from counting Advisors_Children where [IsUnder18]
	 [Gender] nvarchar(20) NULL,
	 [MaritalStatus] nvarchar(20) NULL,
	 [TaxPoints] float not null,
	 [ChildrenTaxPoints] float not null,
	 [ManagerAddition] float null,
	 constraint pk_Advisor_Salary Primary key ([AdvisorID], [YearOfWork])
 )

 Drop table If exists Advisor_Monthly_WH
go
create table Advisor_Monthly_WH
(	 [AdvisorID] int Foreign key REFERENCES Advisors(AdvisorID) not null,
	 [OverTime_WH] float null,
	 [Regular_WH] float null,
	 [VacationDays] float null,
	 [Month] datetime not null,
	 [Year] datetime not null,
	 [SalaryToPay] money,
	 constraint pk_Advisor_Monthly_WH Primary key ([AdvisorID], [Month], [Year])
 )

Drop table If exists [Customers]
go
CREATE TABLE [dbo].[Customers](
	[CustomerID] int NOT NULL Primary key,
	[CustomerName] nvarchar(50) NULL,
	[IsBlackList] bit NULL,
	[IsIsraeliCompany] bit NULL,
	[GroupID] int,  foreign key ([GroupID]) references [Groups](GroupID)
)

 Drop table If exists [CustAddress]
go
CREATE TABLE [dbo].[CustAddress](
    [OfficeID] int NOT NULL Primary key,
	[CustomerID] int Foreign key REFERENCES [Customers]([CustomerID]) NOT NULL,
	[City] nchar(15) NULL,
	[Address] nvarchar(100) NULL,
	[Country] nvarchar(15) NULL,
	[TravelPrice] money NULL,
)

Drop table If exists [CustomerAccount]
go
CREATE TABLE [dbo].[CustomerAccount](
	[CustomerID] int foreign key references [Customers]([CustomerID]) NOT NULL, 
	[Month] datetime not null,
	[Year] datetime not null,
	[FullAmount] money NULL,
	[NetAmount] money NULL,
	[Taxes] money NULL,
	[IsPaid] bit
	constraint pk_Customer_Account Primary key ([CustomerID], [Month], [Year])
)

--***
/*Drop table If exists [CustomerBlacklist]
go
CREATE TABLE [dbo].[CustomerBlacklist](
	[CustomerID] [int] NOT NULL Primary key,
	[NoProjects] [int] Not Null
	constraint FK_CustomerBlacklist foreign key ([CustomerID]) references [Customers]([CustomerID])
)*/

Drop table If exists [PAManager]
go
CREATE TABLE [dbo].[PAManager](
	[PAManagerID] int not null Primary key,
	[BirthDateSpouse] datetime NULL,
	[SpouseCakeID] int foreign key references [Cakes]([CakeID]) not null,
	[BirthDate] datetime NULL,
	[CakeID] int foreign key references [Cakes]([CakeID]) not null,
	[NumberOfChildren] int NOT NULL 
)

Drop table If exists [ProjectAdmin]
go
CREATE TABLE [dbo].[ProjectAdmin](
	[PAdminID] int not null Primary key,
	[LastName] nvarchar(50) NOT NULL,
	[FirstName] nvarchar(50) NOT NULL,
	[BirthDate] datetime NULL,
	[Address] nvarchar(100) NULL,
	[City] nchar(15) NULL,
	[Region] nvarchar(15) NULL,
	[PostalCode] nvarchar(10) NULL,
	[Country] nvarchar(15) NULL,
	[CakeID] int foreign key references [Cakes]([CakeID]) not null,
	[ReportsTo] int foreign key references [PAManager]([PAManagerID]) not NULL ,
	[CustomerID] int NOT NULL foreign key ([CustomerID]) references [Customers]([CustomerID])
)

Drop table If exists [Project]
go
Create table [dbo].[Project](
	[CustomerID] int NOT NULL, FOREIGN key ([CustomerID]) REFERENCES [Customers]([CustomerID]),
	[ProjectID] int not null Primary key,
	[PAdminID] int NOT NULL, FOREIGN key ([PAdminID]) REFERENCES [ProjectAdmin]([PAdminID]),
    [IsBlackList] bit NULL
)

Drop table If exists [ProjectWH]
go
CREATE TABLE [dbo].[ProjectWH](
	[OfficeID] int FOREIGN key REFERENCES CustAddress([officeID]) not null,
	[AdvisorID] int FOREIGN key REFERENCES Advisors([AdvisorID]) not null,
	[ProjectID] int FOREIGN key REFERENCES Project([ProjectID]) not null,
	[CustomerID] int NOT NULL,FOREIGN key ([CustomerID]) REFERENCES [Customers]([CustomerID]),
	[year] datetime not NULL,
	[month] datetime not NULL,
	[StartWH] datetime NULL,
	[EndWH] datetime NULL,
	[WeekendHours] int not null,
	[HolidayHours] int not null,
	[WeekendHolidayHours] int not null,	
	[OverTimeHours] int not null,	
	[AdvisorPricePerHour] int not null,
	Constraint pk_Project_WH  PRIMARY KEY ([OfficeID], [AdvisorID], [ProjectID], [year], [month])
)
    
GO
Drop table If exists [PManagerChildren]
go
CREATE TABLE [dbo].[PAManagerChildren](
	[PAManagerID] int foreign key references [PAManager]([PAManagerID]) not null,
	[BirthDate] datetime NULL,
	[ChildID] int not null Primary key,
	[CakeId] int foreign key references [Cakes]([CakeID]) not null
)
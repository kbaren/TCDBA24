------------ Part 8 All about tables ----------------

--- 1 ---
create type lists.ListValueName from nvarchar(50) NOT NULL

--- 2 ---
CREATE TYPE lists.list AS TABLE   
( ID tinyint not null 
, Name lists.ListValueName );  
GO  


create table lists.Countries2 
(Id tinyint,
 Name lists.ListValueName) 
go
create table lists.Genders2
(Id tinyint,
 Name lists.ListValueName)
go
create table lists.MaritalStatuses2
(Id tinyint,
 Name lists.ListValueName)
go
create table lists.SessionsEndReasons2
(Id tinyint,
 Name lists.ListValueName)
go
create table lists.InvitationStatuses2
(Id tinyint,
 Name lists.ListValueName) 
go

--- 3 ---
alter procedure lists.InsertIntoListTable
@tableList lists.list readonly
, @tablename nvarchar(100)
AS
Begin

Declare @SQL nvarchar(Max)
  Drop table if exists lists.temptable
  
  select *
  into  lists.temptable
  from @tableList

  set @SQL = concat ('insert into ', @tablename, ' select * from lists.temptable')
  print @SQL
  Exec (@SQL)
End

go

declare @tableList lists.list
insert into @tableList values (1, 'Israel')
execute lists.InsertIntoListTable @tableList, 'lists.Countries2'
go
declare @tableList lists.list
insert into @tableList values (1, 'Male')
execute lists.InsertIntoListTable @tableList, 'lists.Genders2'
go
declare @tableList lists.list
insert into @tableList values (1, 'Sent')
execute lists.InsertIntoListTable @tableList, 'lists.InvitationStatuses2'
go
declare @tableList lists.list
insert into @tableList values (1, 'Married')
execute lists.InsertIntoListTable @tableList, 'lists.MaritalStatuses2'
go
declare @tableList lists.list
insert into @tableList values (1, 'Abandoned')
execute lists.InsertIntoListTable @tableList, 'lists.SessionsEndReasons2'

---4---
CREATE TABLE
	Operation.Members2
(
	Id						INT				NOT NULL	IDENTITY (1,1) ,
	Username				NVARCHAR(10)	NOT NULL ,
	Password				NVARCHAR(10)	NOT NULL ,
	FirstName				NVARCHAR(20)	NOT NULL ,
	LastName				NVARCHAR(20)	NOT NULL ,
	StreetAddress			NVARCHAR(100)	NULL ,
	CountryId				TINYINT			NOT NULL ,
	PhoneNumber				NVARCHAR(20)	NULL ,
	EmailAddress			NVARCHAR(100)	NOT NULL ,
	GenderId				TINYINT			NOT NULL ,
	BirthDate				DATE			NOT NULL ,
	SexualPreferenceId		TINYINT			NULL ,
	MaritalStatusId			TINYINT			NULL ,
	Picture					VARBINARY(MAX)	NULL ,
	RegistrationDateTime	DATETIME2(0)	NOT NULL 
)

---5---
CREATE TABLE
	Operation.MemberSessions2
(
	Id				INT				NOT NULL	IDENTITY (1,1) ,
	MemberId		INT				NOT NULL ,
	LoginDateTime	DATETIME2(0)	NOT NULL ,
	EndDateTime		DATETIME2(0)	NULL ,
	EndReasonId		TINYINT			NULL
)

---6---
select s.name as schemaName, t.name as TableName, c.name as ColumnName, ty.name as DataType, c.is_nullable as IsNullable, is_identity as IsIdentity
from sys.tables t
join sys.schemas s on t.schema_id = s.schema_id
join sys.columns c on t.object_id=c.object_id
join sys.types ty on c.user_type_id = ty.user_type_id                          
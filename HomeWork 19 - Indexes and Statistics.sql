----------- 19 Indexes and Statistics -----------
--- 1 ---
CREATE clustered INDEX  IX_MemberSessions_clustered ON operation.MemberSessions
(MemberId, LoginDateTime)   
WITH (FILLFACTOR = 80)
ON [PRIMARY];   
GO  

--- 2 ---
select *
from operation.MemberSessions WITH(INDEX(IX_MemberSessions_clustered))
where MemberId = 1234
and YEAR(logindatetime) = 2010

--- 3 ---
select *
from Operation.MemberSessions s WITH(INDEX(IX_MemberSessions_clustered))
join Operation.Members m 
on s.MemberId = m.Id
where GenderId = 2
and MaritalStatusId = 1
and DATEDIFF(yy, m.birthdate, getdate()) = 25
order by s.MemberId, s.LoginDateTime

--- 4 ---
CREATE unique NONCLUSTERED INDEX [ix_Members_nclust_Username#Password] ON [Operation].[Members]
(	[Username] ASC,
	[Password] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
GO

--- 5 ---
select *
from Operation.Members
where Username = 'XXXX'
and Password = '12345'

--- 6 ---
insert into [Operation].[Members] ([Username], [Password], RegistrationDateTime, FirstName, LastName, CountryId, EmailAddress, GenderId, BirthDate)
values
('XXXX', 12345, getdate(), 'FirstName', 'LastName', 1, 'EmailAddress', 2,'1989-12-29')

--- 7 ---
select *
from [operation].[members]
where countryID >0
OPTION(RECOMPILE);
GO
DBCC SHOW_STATISTICS ([operation.members], countryID)

--- 8 ---
create nonclustered index IX_Members_ID_Included
on [operation].[Members] 
(ID ASC)
include (firstname, lastname)

create nonclustered index IX_MemberSessions_ID
on [operation].MemberSessions 
(ID ASC) 

create nonclustered index IX_Invitations_requestingSessionID
on [operation].Invitations 
(ID ASC)


select distinct i.*
from Operation.Invitations i
join Operation.MemberSessions s on i.requestingSessionID = s.id
join [operation].[Members] m on s.MemberId = m.Id 
where FirstName = 'Paul' and LastName = 'Simon'

--- 9 ---

select *
from Operation.Members WITH(INDEX(IX_Members_ID_Included))
where Id not in (5,6,7,8)

--- 10 ---
select FirstName, LastName
from Operation.Members with (index (IX_Members_Lastname_Included_firstname))
where lastname like 'B%'
order by LastName 

--- Seek is not used since all the indexes that exists on the table not include the Lastname column as index
--- No order by clause will help as it is the last operation in the SQL query and can't affect the execution plan

--- 11 ---
--- to improve performance for the previous query we need to add the following index to the table
create nonclustered index IX_Members_Lastname_Included_firstname
on Operation.Members
(lastname asc)
include (firstname, EmailAddress)

--- 12 ---
select *
from Operation.Members 
where EmailAddress not like '%gmail.com%'

--- I've added the emailadress column as included colum in the prefix

--- 13 ---
select *
from Operation.Members
where datediff(yy, birthdate, getdate())>50
and StreetAddress is null
order by BirthDate 

--- 14 ---
create clustered index IX_clustered_ID
on operation.members
(id asc)
WITH (FILLFACTOR = 100)
ON [PRIMARY]; 

--- 15 ---
create nonclustered index IX_nonclust__enddatetime#endreasonid_incl_memberID
on operation.membersessions
(enddatetime ASC,
 endreasonid ASC
 )
INCLUDE (memberID)
With (fillfactor = 80)
on [primary]

--- 16 ---
select
memberid = members.Id,
memberfistname = members.FirstName,
memberlastname = members.LastName,
logindatetime = MemberSessions.LoginDateTime,
sessionenddate = MemberSessions.EndDateTime
from Operation.Members as members
inner join
Operation.MemberSessions as MemberSessions
on
members.Id = MemberSessions.MemberId
where
members.CountryId = 4
and
year(membersessions.logindatetime) = 2010
and
month(membersessions.logindatetime) = 6
order by
memberid asc, LoginDateTime asc

--- 17 ---
create nonclustered index ix_Members_ID#CountryId
on Operation.Members (CountryId)
include (Id, FirstName, LastName)
With (fillfactor = 80)
On [primary]

create nonclustered index ix_MemberSessions_ID#logindatetime
on Operation.MemberSessions (logindatetime)
include (Id, EndDateTime)
With (fillfactor = 80)
On [primary]


select
memberid = members.Id,
memberfistname = members.FirstName,
memberlastname = members.LastName,
logindatetime = MemberSessions.LoginDateTime,
sessionenddate = MemberSessions.EndDateTime
from (select Id, FirstName, LastName, CountryId 
	  from Operation.Members 
	  where CountryId = 4
	 ) as members
inner join
	 (select MemberId, LoginDateTime, EndDateTime
	  from Operation.MemberSessions 
	  where year(membersessions.logindatetime) = 2010
		and month(membersessions.logindatetime) = 6
	 )  as MemberSessions
on
members.Id = MemberSessions.MemberId
order by
memberid asc, LoginDateTime asc

--- 18 ---
select s.name as schema_name, t.name as table_name, i.name as index_name, i.type as index_type, i.is_unique, i.fill_factor
from sys.indexes i
join sys.tables t on i.object_id = t.object_id
join sys.schemas s on t.schema_id=s.schema_id

--- 19 ---
DBCC SHOW_STATISTICS ([operation.members], countryID)

--- 20 ---
create table checkfillfactor
( value varchar(100))

DECLARE @i AS int = 1
WHILE @i <= 1000
BEGIN
INSERT INTO checkfillfactor
VALUES (@i)
SET @i = @i + 1
END

create nonclustered index ix_checkfillfactor_value_FF80
on dbo.checkfillfactor (value) 
with (FILLFACTOR = 80)
ON [PRIMARY]

create nonclustered index idx_checkfillfactor_value_FF10 
on dbo.checkfillfactor (value) 
with (FILLFACTOR = 10)
ON [PRIMARY]

select i.name, i.fill_factor, OBJECT_NAME(s.object_id) as tableName,s.reserved_page_count, s.used_page_count, s.row_count
from sys.dm_db_partition_stats s
join sys.indexes i
on s.object_id = i.object_id and s.index_id = i.index_id
where s.index_id>0
and OBJECT_NAME(s.object_id) = 'checkfillfactor'

--- 21 ---
select avg_fragmentation_in_percent as frag_percent
	  ,avg_fragment_size_in_pages as frag_size
	  ,page_count as index_size
from sys.dm_db_index_physical_stats(db_id('edate'),object_id('checkfillfactor'),null,null,null)

--- 22 ---
select  SCHEMA_NAME(t.schema_id) as schema_name
	   ,OBJECT_NAME(t.object_id) as table_name
	   ,i.name as index_name
	   ,i.type as index_type
	   ,is_unique = case when i.is_unique = 1 then 'unique' else 'non-unique' end
	   ,i.fill_factor
from sys.indexes i
join sys.tables t
on i.object_id = t.object_id

--- 23 ---
-- non persisted
GO
create table tablesize
( A char(10))

DECLARE @i AS int = 1
WHILE @i <= 700
BEGIN
INSERT INTO tablesize
VALUES (@i)
SET @i = @i + 1
END

alter table tablesize
add value AS A+A

select * from tablesize

sp_spaceused 'tablesize'

-- persisted
select A
into tablesize_2
from tablesize

alter table tablesize_2
add value AS A+A Persisted

select * from tablesize_2

sp_spaceused 'tablesize_2'

-- the reserved and used space is bigger in the tablesize_2 table with persisted computed column

--- 24 ---
--a. yes you can birthdate not null in filtered index
--b. no like is not allowed in filtered index

--- 25 ---
SELECT count(*) as [Indexes], 
(select count(*) from sys.indexes where has_filter = 1) as [Filtered], 
(select count(*) FROM sys.indexes where type_desc = 'CLUSTERED') as [Clustered], 
(select count(*) FROM sys.indexes where type_desc = 'NONCLUSTERED')  as [NonClustered], 
(select count(*) FROM sys.indexes where is_unique=1) as [Unique],
(select count(*) FROM sys.indexes where is_unique=0) as [NotUnique],
(select count(*) FROM sys.indexes where is_primary_key=1) as [PK],
(select count(*) FROM sys.indexes where is_primary_key=0) as [NotPK]
FROM sys.indexes
where type_desc <> 'heap'


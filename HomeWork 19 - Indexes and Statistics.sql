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





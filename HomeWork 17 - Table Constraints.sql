----------- 17 Table Constraints -----------
--- 1 ---
select *
from sys.tables
where schema_id = 5

ALTER TABLE [Lists].[Countries] ADD  CONSTRAINT [pk_Countries_c_Id] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[Genders] ADD  CONSTRAINT [pk_Genders_c_Id] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[InvitationStatuses] ADD  CONSTRAINT [pk_InvitationStatuses_c_Id] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[MaritalStatuses] ADD  CONSTRAINT [pk_MaritalStatuses_c_Id] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[SessionEndReasons] ADD  CONSTRAINT [pk_SessionEndReasons_c_Id] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

--- 2 ---
ALTER TABLE [Lists].[Countries] ADD  CONSTRAINT [uni_Countries_nc_name] UNIQUE NONCLUSTERED 
([Name] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[Genders] ADD  CONSTRAINT [uni_Genders_nc_name] UNIQUE NONCLUSTERED 
(name ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[InvitationStatuses] ADD  CONSTRAINT [uni_InvitationStatuses_nc_name] UNIQUE NONCLUSTERED 
([Name] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[MaritalStatuses] ADD  CONSTRAINT [uni_MaritalStatuses_nc_name] UNIQUE NONCLUSTERED 
([Name] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

ALTER TABLE [Lists].[SessionEndReasons] ADD  CONSTRAINT [uni_SessionEndReasons_nc_name] UNIQUE NONCLUSTERED 
([Name] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

--- 3 ---
ALTER TABLE [Operation].[MemberSessions]
ADD CONSTRAINT fk_MemberSessions_EndReasonId_SessionEndReasons_id FOREIGN KEY ([EndReasonId] )  
REFERENCES [Lists].[SessionEndReasons] ([ID])
ON DELETE NO ACTION
ON UPDATE NO ACTION


ALTER TABLE [Operation].[Members]
ADD CONSTRAINT fk_Members_MaritalStatusId_MaritalStatuses_id FOREIGN KEY (MaritalStatusId )  
REFERENCES [Lists].MaritalStatuses ([ID])
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE [Operation].[Members]  
ADD  CONSTRAINT [fk_Members_SexualPreferenceId_Genders_Id] FOREIGN KEY([SexualPreferenceId])
REFERENCES [Lists].[Genders] ([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE [Operation].[Members]  
ADD  CONSTRAINT [fk_Members_GenderId_Genders_Id] FOREIGN KEY([GenderId])
REFERENCES [Lists].[Genders] ([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION

ALTER TABLE [Operation].[Members]  
ADD  CONSTRAINT [fk_Members_CountryId_Countries_Id] FOREIGN KEY([CountryId])
REFERENCES [Lists].[Countries] ([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION


ALTER TABLE [Operation].[Invitations]  
ADD  CONSTRAINT [fk_Invitations_StatusId_InvitationStatuses_Id] FOREIGN KEY([StatusId])
REFERENCES [Lists].[InvitationStatuses] ([Id])
ON DELETE NO ACTION
ON UPDATE NO ACTION

--- 4 --- 
ALTER TABLE operation.MemberSessions 
ADD  CONSTRAINT [pk_MemberSessions_nc_Id] PRIMARY KEY NONCLUSTERED 
([Id] ASC)
WITH (fillfactor = 80) 
ON [PRIMARY]

--- 5 ---
create table operation.MemberSearches
(ID INT NOT NULL IDENTITY(1,1),
 Sessionid INT NOT NULL,
 DateAndTime DATETIME2(0) NOT NULL DEFAULT SYSDATETIME(),
 SearchCriteria XML NOT NULL,
 SearchResultCount INT NOT NULL,
 CONSTRAINT PK_MemberSearches_c_id PRIMARY KEY CLUSTERED (ID) WITH (fillfactor = 100) on [PRIMARY],
 CONSTRAINT fk_MemberSearches_Sessionid_MemberSessions_id Foreign key (Sessionid) REFERENCES operation.MemberSessions ([Id]),
 CONSTRAINT CHK_MemberSearches_SearchResultCount CHECK (SearchResultCount>=0)
 )

 --- 6 --
 Alter table [Operation].[Members] 
 ADD CONSTRAINT CHK_Members_Age CHECK (datediff(dd, birthdate, getdate())>=6574)

 --- 7 ---
 declare @i int = 1
 while @i <=100
 begin
 insert into operation.members
 values
 ('XXXXXX',	cast (RAND()*111222333 as int), 'L', 'M'	,NULL	,2	,NULL	,'xxxxxxxxxx@gmail.com'	,2	, DATEADD(day, (ABS(CHECKSUM(NEWID())) % (datediff(dd, 0,getdate()))), '2001-01-05')	,NULL	,1	,NULL	,getdate())
 Set @i = @i+1
 end
 -- we are receiving the error as the chack constraint prevents us to insert incorrect values

ALTER TABLE operation.members
NOCHECK CONSTRAINT CHK_Members_Age;   
GO  

 declare @i int = 1
 while @i <=100
 begin
 insert into operation.members
 values
 ('XXXXXX',	cast (RAND()*111222333 as int), 'L', 'M'	,NULL	,2	,NULL	,'xxxxxxxxxx@gmail.com'	,2	, DATEADD(day, (ABS(CHECKSUM(NEWID())) % (datediff(dd, 0,getdate()))), '2001-01-05')	,NULL	,1	,NULL	,getdate())
 Set @i = @i+1
 end

-- now we can insert the rows as a check constraint is disabled

ALTER TABLE operation.members
CHECK CONSTRAINT CHK_Members_Age;

--- 8 ---
ALTER TABLE [Operation].[Members] DROP CONSTRAINT IF Exists [pk_Members_c_Id]

alter table operation.members
ADD  CONSTRAINT [pk_Member_n_Id] PRIMARY KEY CLUSTERED 
([Id] ASC)
WITH (fillfactor = 100) 
ON [PRIMARY]

--- 9 ---
ALTER TABLE operation.MemberSessions 
ADD CONSTRAINT fk_membersession_memberid_members_id Foreign key (memberid) REFERENCES operation.Members ([Id])

--- 10 ---

 Alter table [Operation].[Members] 
 WITH NOCHECK ADD CONSTRAINT CHK_Members_Email CHECK (EmailAddress like '%@%' ) 

--- 11 ---
select s.name schema_name, t.name table_name, c.name constraint_name, c.definition, c.is_not_trusted 
from sys.check_constraints c
join sys.schemas s on c.schema_id=s.schema_id
join sys.tables t on c.parent_object_id = t.object_id

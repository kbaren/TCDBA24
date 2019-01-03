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



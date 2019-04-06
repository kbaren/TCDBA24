exec usp_createEmailAccountProfile 'yanivavigail3996','bentovim.avigail@gmail.com', 'bentovim.avigail@gmail.com','bentovim.avigail@gmail.com'

drop proc usp_createEmailAccountProfile
--create profile for sending e-mails
--****PART OF INSTALLATION NOT TO BE RUN TWICE
create proc usp_createEmailAccountProfile (	@emailPassword nvarchar(100), @emailusername nvarchar(100),
											@emailToAddress nvarchar(100), @emailFromAddress nvarchar(100) )
as
begin
-- Create a Database Mail account  
	EXECUTE msdb.dbo.sysmail_add_account_sp  
		@account_name = 'Casino Support Team Public Account',      
		@email_address = @emailToAddress,  
		@display_name = 'Casino Support Team Automated Mailer',
		@replyto_address = @emailFromAddress, 
		@description = 'Mail account for use by all database users.',  
		@mailserver_name = 'smtp.gmail.com',
		@port = 587,
		@enable_ssl = 1,
		@username = @emailusername,
		@password = @emailPassword; 
     
	-- Create a Database Mail profile  
	EXECUTE msdb.dbo.sysmail_add_profile_sp  
		@profile_name = 'Casino Support Team',  
		@description = 'Profile used for support mail.' ;  

	-- Add the account to the profile  
	EXECUTE msdb.dbo.sysmail_add_profileaccount_sp  
		@profile_name = 'Casino Support Team',   
		@account_name = 'Casino Support Team Public Account',  
		@sequence_number =1 ;  
  
	-- Grant access to the profile to all users in the msdb database  
	EXECUTE msdb.dbo.sysmail_add_principalprofile_sp  
		@profile_name = 'Casino Support Team',  
		@principal_name = 'public',  
		@is_default = 1 ;  
end


create function Security.udf_securitypredicate(@CasinoManagerID as int)
    returns table
with schemabinding
as
    return select 1 as result 
    where @CasinoManagerID in (select CasinoManagerID  
								   from Security.utbl_CasinoManagers cm 
								   inner join 
								   Games.utbl_Games g
								   on cm.GameName = g.GameName
								   where cm.managername
								   = user_name() or user_name() = 'dbo')

GO

-- Create and enable a security policy adding the function fn_securitypredicate 
-- as a filter predicate and switching it on
CREATE SECURITY POLICY GamesPolicyFilter
	ADD FILTER PREDICATE Security.fn_securitypredicate(CasinoManagerID) 
	ON Security.utbl_CasinoManagers
	WITH (STATE = ON);
go

drop proc usp_create_NewPeopleUser 

exec create_NewPeopleUser
--login cursor that loops through the whole Security.utbl_CasinoManagers table 
--and creates a user for each manager
create proc usp_create_NewPeopleUser 
as
begin
		Declare @ManagerName varchar(20), @CasinoManagerID int, @stmtS nvarchar(4000),
				@stmtS1 nvarchar(4000), @stmtS2 nvarchar(4000)
		Declare Mycursor cursor
		for SELECT CasinoManagerID, ManagerName
		  FROM [Security].utbl_CasinoManagers
		open Mycursor
		Fetch next from Mycursor into @CasinoManagerID, @ManagerName
		while @@FETCH_STATUS=0
		begin 
		--creates a global variable 'FullName' to hold selected username
		--EXEC sp_set_session_context @key = N'FullName', @value = @fullName
			--CREATE LOGIN @newUsername WITH PASSWORD = @password; 
			set @stmtS = 'CREATE LOGIN ' + quotename(@ManagerName,']') +
						' with password = ''''
						, CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF ' 
			print @stmtS
			exec (@stmtS)

		--creates user from next employee in table
			select @stmtS1 = 'CREATE USER '
			select @stmtS1 = @stmtS1 +  quotename(@ManagerName,']')
			--select @stmtS1 = @stmtS1 + ' WITHOUT LOGIN'
			select @stmtS1 = @stmtS1 + ' FOR LOGIN '
			select @stmtS1 = @stmtS1 + quotename(@ManagerName,']')
			print @stmtS1
			exec (@stmtS1)

		--CREATE USER @fullName WITH LOGIN
			select @stmtS2 = 'GRANT SELECT ON Sales.Orders TO '
			select @stmtS2 = @stmtS2 +  quotename(@ManagerName,']')
			print @stmtS2
			exec (@stmtS2)
	
		--EXECUTE AS USER = @fullName	
			select @stmtS2 = 'EXECUTE AS USER =  '
			select @stmtS2 = @stmtS2 +  quotename(@ManagerName,']')
			print @stmtS2
			exec (@stmtS2)
		Fetch next from Mycursor into @CasinoManagerID, @ManagerName
		end 
		close Mycursor
		Deallocate Mycursor
end

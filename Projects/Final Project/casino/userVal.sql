use Casino
go

drop proc usp_welcome

exec usp_welcome  
go
--login or register
create proc usp_welcome
           @username nvarchar(50), @Password Nvarchar(50), 
		   @Email  Nvarchar(50), @birthdate datetime,
		   @FirstName nvarchar(20), @LastName nvarchar(20), 
		   @PlayerAddress nvarchar(60), @Country nvarchar(15),
		   @Gender nchar(1), @choice nvarchar(100)
as
begin
	--check if to register or login and send to appropriate handling
	if (@choice = 'register')
		begin
			print 'Registration GUI Screen - Welcome new player. Please enter your details to register'
			exec usp_validate_playerDetails @username , @Password, @Email, @birthdate,
											@FirstName, @LastName, @PlayerAddress, @Country,
											 @Gender, @choice
			return;
		end
	if (@choice = 'login')
		begin
			print 'Login GUI Screen - Welcome back. Please provide your username and password to login'
			exec usp_Login @username, @Password 
		end
end 

go

exec usp_welcome  'KARINA', 'a9gyfd9xFpd', 'barjonya@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'KARA', 'a9gyd9xFpd', 'baronya@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'Karina2', 'a9gyfdD9xpd', 'bar@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'Avigail', '11223rD', 'bentovim.avigail@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'Avigail5', 'a9gyfd9xFpd', 'bentovim.avi@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'Avigail', 'rt45Dy', 'bentovim.avigail@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','login'
exec usp_welcome  'Avi', '15g1223rD', 'bent.avigail@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'Avi', '15g1223rD', 'bent.avigail@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','login'
exec usp_welcome  'Aviv', '15g223rD', 'ben.avigail@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'KAR', 'a9gyd9bPpd', 'barnya@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','register'
exec usp_welcome  'KAR', 'a9gyd9bPpd', 'barnya@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','login'
exec usp_welcome  'Avigail5', 'Ail56', 'bentovim.avi@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'ben', 'Oranit', 'Israel', 'F','login'


drop proc usp_validate_playerDetails
--unique username
--password:
--		5 chars
--		small, big chars, digit
--		not equal to existing password in password table
--		not 'password' in any combination
--email address: unique, legal format with @
--birthdate over 18 years
create proc usp_validate_playerDetails 
           @username nvarchar(50), @PlayerPassword Nvarchar(50), 
		   @Email  Nvarchar(50), @birthdate datetime,
		   @FirstName nvarchar(20), @LastName nvarchar(20), 
		   @PlayerAddress nvarchar(60), @Country nvarchar(15),
		   @Gender nchar(1), @choice nvarchar(100)
as
begin
    declare @userNameValid	nchar,
	@passwordValid	nchar,
	@emailValid	nchar,
	@birthdateValid nchar,
	@NumFails smallint = 0, 
	@IsBlocked nchar = 'N', 
	@LoginTime datetime = getdate(), 
	@IsConnected nchar = 'N',
	@DepositAmt int,
	@randomNumber int,
	@NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10),
	@Counter int = 0, @Total int = 1

--check if new user or personal details change
if (@choice <> 'personalDetailsChange')
BEGIN
	--check if username exists - also case sensitive
		if ((select count(UserName)
			from Admin.utbl_players
			--where UserName = @username COLLATE SQL_Latin1_General_CP1_CS_AS)=0)
			where UserName = @username collate database_default )=0)
			begin
				set @userNameValid = 'Y'
			end
		else
			--add random number to username to make unique
			--use loop to check if exists before asking user
			begin
				WHILE @Counter < @Total 
				BEGIN
					set @randomNumber = (select cast(abs(rand()*120)as int))
					set @username = @username+cast(@randomNumber as varchar)
					if ((select count(UserName)
						from Admin.utbl_players
						where UserName = @username collate database_default)=0)
						--or UserName = lower(@username) COLLATE SQL_Latin1_General_CP1_CS_AS)=0)
						BREAK
					else
						set @Counter = @Counter+1 
						set @Total = @Total +1
						continue
				END
				print 'The username you requested is already in use. '+@NewLineChar+
						'Please choose another or use: '+@username

				--send back to welcome page
				--exec usp_welcome 'Y' , 'N',@username, @Password, @Email, @birthdate, @FirstName, 
				--				@LastName, @PlayerAddress, @Country, @Gender
				set @userNameValid = 'N'
				return
			end
	--check if password is legal
	if ((select dbo.udf_PasswordSyntaxValid(@PlayerPassword, @username)) = 'Y')
		begin
			--check if password exists in git password table
			if ((select count(gitPassword) from utbl_GitPasswords 
					where gitPassword = @PlayerPassword COLLATE SQL_Latin1_General_CP1_CS_AS)=0)
				set @passwordValid= 'Y'
			else
				begin
					set @passwordValid = 'N'
					print 'The password chosen is a frequent password. Please choose another'
					return
				end
		end
	else
		begin
			set @passwordValid = 'N';
			print 'Password provided is not strong, is frequently used or is the same as the username. '+@NewLineChar+
					'Please enter a new password with: '+@NewLineChar+
					'at least 5 characters long, '+@NewLineChar+
					'with a combination of at least 1 small letter, '+@NewLineChar+
					'1 capital letter, 1 digit'+@NewLineChar+
					'not like the word password and not like the username.'
			return
		end
END
	--check if player over 18
	if (iif(datediff(dd, datediff(dd,getdate(), DATEADD (dd, -1, (DATEADD(yy, (DATEDIFF(yy, 0, GETDATE()) +1), 0)))),
           datediff(dd,@birthdate, DATEADD (dd, -1, (DATEADD(yy, (DATEDIFF(yy, 0, @birthdate ) +1), 0))))) < 0,
		   datediff(yy,@birthdate,getdate())-1, datediff(yy,@birthdate,getdate())) >= 18)
		set @birthdateValid = 'Y'
	else
		begin
			set @birthdateValid = 'N'
			print 'Players can only be over 18. Goodbye'
			--exec usp_welcome 'N' , 'N', @username, @Password, @Email, @birthdate, @FirstName, 
			--				@LastName, @PlayerAddress, @Country, @Gender
			return
		end

	--check if email is legal and doesn't already exist
	if ((@Email <> '' AND @Email LIKE '_%@__%.__%')
		and (select count(EmailAddress) from Admin.utbl_players
			where EmailAddress = @Email)=0)
		set @emailValid = 'Y'
	else
		begin
			set @emailValid = 'N'
			print 'Your email is invalid or already exists with another player. Please enter another'
			--exec usp_welcome 'Y' , 'N', @username, @Password, @Email, @birthdate, @FirstName, 
			--				@LastName, @PlayerAddress, @Country, @Gender
			return
		end

	--if all inputs are valid, insert new user to Admin.utbl_players table
	if (@birthdateValid = 'Y' and @emailValid = 'Y' and @passwordValid= 'Y' 
					and @userNameValid = 'Y' and @choice <> 'personalDetailsChange')
	begin
		set @DepositAmt = (select CompanyValue from Admin.utbl_CompanyDefinitions where CompanyKey='welcomeBonus')
		insert into Admin.utbl_PlayerBankroll ([UserName], [CurrentBankRoll], [DepositAmt], [WithdrawalAmt],
										 [WinAmt], [LossAmt])
								 values (@username, 0, @DepositAmt, 0, 0, 0);
		insert into Admin.utbl_players (UserName, PlayerPassword, FirstName, LastName, PlayerAddress, Country,
								  EmailAddress, Gender, BirthDate, NumFails, IsBlocked, LoginTime, IsConnected)
						values (@username, @PlayerPassword, @FirstName, @LastName, @PlayerAddress, @Country,
								@Email, @Gender, @birthdate, @NumFails, @IsBlocked, @LoginTime, @IsConnected)
	--	exec usp_Login @username, @PlayerPassword
	end
	--if personal details change
	if (@birthdateValid = 'Y' and @emailValid = 'Y'
					and @choice = 'personalDetailsChange')
	begin
		update Admin.utbl_players 
		set FirstName =@FirstName, LastName = @LastName, PlayerAddress =@PlayerAddress, 
			Country =@Country, EmailAddress = @Email, Gender = @Gender
		where username = @username
		--exec usp_Login @username, @PlayerPassword
	end
end
go

drop proc usp_Login
exec usp_Login 
--login existing user
create proc usp_Login
           @username nvarchar(50), @PlayerPassword nvarchar(50)
as
begin
    declare @numTries int, @AdminNumTries int, @LoginTime dateTime, @NumFails int
	set @NumFails = (select NumFails from Admin.utbl_players where UserName = @username)
	set @AdminNumTries = (select CompanyValue from Admin.utbl_CompanyDefinitions where CompanyKey = 'logonTimes')


	--validate username. if exists, see if blocked. if not, validate password
	if ((select count(*) from Admin.utbl_players where UserName = @username) >0)
	begin
		--check if user blocked
		if ((select IsBlocked from Admin.utbl_players where UserName=@username)='Y')
		begin
			print 'You are currently blocked please contact support'
			return;
		end

		--password validation - see if right password for user
		if ((select count(UserName) from Admin.utbl_players where PlayerPassword= @PlayerPassword 
			and username =@username) =0)
		begin
			set @NumFails = @NumFails+1
			--if exceeded number of allowed tries for password, send to support
			if (@NumFails = @AdminNumTries)
			begin
				update Admin.utbl_players 
				set IsBlocked = 'Y',
				IsConnected = 'N',
				NumFails = @AdminNumTries
				where UserName=@username
				print 'You have entered the wrong password too many times and are now blocked. 
						Please contact support'
				return
			end  
			else
			begin
				update Admin.utbl_players  set NumFails = @NumFails
				where username =@username
				print 'The password entered is invalid. Please try again'
				--send back to Login GUI Screen 
				return;
			end
		end
		else
		begin
		--if login successful, change NumFails = 0 and connect player
			update Admin.utbl_players
			set LoginTime = getdate(), 
			IsConnected = 'Y', NumFails = 0
			where UserName=@username
			--send to lobby
			print 'What would you like to do now: Games, Admin or Cashier?'
--**********for testing begin
			--exec usp_lobby @username, 'games'
--**********for testing end
		end
	end
END
go




drop proc usp_autoPasswordChange
exec usp_autoPasswordChange 'Avigail5'
--password reset and send email to player with new password
--accessed from the Support GUI Screen
create proc usp_autoPasswordChange (@username nvarchar(50))
as
declare
	@randomNumber int, @randomUpperCase nvarchar(20),
	@randomLowerCase nvarchar(20), @newPassword nvarchar(50),
	@emailToAddress nvarchar(50), @PlayerSubject nvarchar(100), @PlayerBody nvarchar(500),
	@Count int = 0, @Total int=1
begin
	--create random password that conforms to validation rules
	--while loop to check again if random password already exists
	WHILE (@Count < @Total)
		BEGIN
			set @randomNumber = cast((select cast(abs(rand()*120)as int))as varchar)
			set @randomUpperCase = (select substring('ABCDEFGHIJKLMNOPQRSTUVWXYZ', (abs(checksum(newid())) % 26)+1, 2))
			set @randomLowerCase = (SELECT substring('abcdefghijklmnopqrstuvwxyz', (abs(checksum(newid())) % 26)+1, 2))
			set @newPassword = CONCAT(@randomNumber, @randomUpperCase, @randomLowerCase)
			--check if player already used the passsword in the past or in frequent passwords
			if (((select dbo.udf_IsPasswordInPast(@username, @newPassword)) = 'Y') or
				((select dbo.udf_PasswordSyntaxValid(@username, @newPassword)) = 'N'))
				begin
					set @Count = @Count+1
					set @Total = @Total+1
				end
			else
				begin
					print @newPassword
					--update player with new password
					update Admin.utbl_players set PlayerPassword = @newPassword,
							IsBlocked = 'N',
							NumFails = 0
							where UserName=@username
					--send mail to player with new password
					--create account and profile for player
					set @emailToAddress = (select EmailAddress from Admin.utbl_players where username = @username)
					
					--exec usp_createEmailAccountProfile @emailPassword, @emailusername, @emailToAddress, @emailFromAddress

					--send mail notification of password change
					set @PlayerSubject = 'Password reset for Casino player: '+@username
					set @PlayerBody = 'Your new password is '+@newPassword
					exec msdb.dbo.sp_send_dbmail 
										@profile_name = 'Casino Support Team',
										@recipients=@emailToAddress,
										@subject=@PlayerSubject,
										@body=@PlayerBody
				break
				end
		END
end 
go

drop function udf_IsPasswordInPast

select dbo.udf_IsPasswordInPast('avigail','11223rD')
select dbo.udf_IsPasswordInPast('avigail','10XYlm')
create function udf_IsPasswordInPast ( @username nvarchar(50), @newPassword nvarchar(50)) returns char
as
begin
		if (((select count(p.PlayerPassword) from Admin.utbl_playersHistory ph 
												inner join Admin.utbl_players p 
												on p.UserName = ph.UserName
				where p.PlayerPassword = @newPassword COLLATE SQL_Latin1_General_CP1_CS_AS 
				or ph.PlayerPassword = @newPassword COLLATE SQL_Latin1_General_CP1_CS_AS 
				and p.username = @username)>0) OR
			((select count(GitPassword) from utbl_GitPasswords 
				where GitPassword = @newPassword COLLATE SQL_Latin1_General_CP1_CS_AS)>0))
			return ('Y')
	return ('N')
end

drop function udf_PasswordSyntaxValid

select dbo.udf_PasswordSyntaxValid ('Avigailassword9')

create function udf_PasswordSyntaxValid (@PlayerPassword nvarchar(50),  @username nvarchar(50)) returns char
WITH EXECUTE AS CALLER
as
begin
		if (len(@PlayerPassword) >= 5 
			and (PATINDEX(N'%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%' , 
									@PlayerPassword collate SQL_Latin1_General_CP1_CS_AS)> 0)
			and (PATINDEX(N'%[abcdefghijklmnopqrstuvwxyz]%' , 
										@PlayerPassword COLLATE SQL_Latin1_General_CP1_CS_AS)> 0)
			and (@PlayerPassword like '%[0-9]%' )
			and (@PlayerPassword not like N'%password%')
			and (@PlayerPassword not like N'%p%assword%')
			and (@PlayerPassword not like N'%pa%ssword%')
			and (@PlayerPassword not like N'%pas%sword%')
			and (@PlayerPassword not like N'%pass%word%')
			and (@PlayerPassword not like N'%passw%ord%')
			and (@PlayerPassword not like N'%passwo%rd%')
			and (@PlayerPassword not like N'%passwor%d%')
			and (@PlayerPassword not like @username))

			return ('Y');
	return ('N');
end;

go

drop proc usp_lobby

exec usp_lobby 'avigail7', 'game ground' 
--in the Lobby GUI Screen.
--send player to games/cashier/admin
create proc usp_lobby @username nvarchar(50), @action nvarchar(100)
as
DECLARE @CurrentBankRoll int
begin
	--current bankroll
	set @CurrentBankRoll= (select CurrentBankRoll from Admin.utbl_PlayerBankroll where UserName = @username)
	print 'Your current bankroll is: '+@CurrentBankRoll

	if (@action='game ground') 
		begin
			print 'show game ground GUI screen'
--**********for testing begin
			exec usp_gameRequest @username, 50, 'BlackJack'
--**********for testing end
		end
	else if (@action='cashier') 
		begin
			print 'show Cashier GUI screen'
--**********for testing begin
			exec usp_cashier @username
--**********for testing end
		end
	else if (@action='administration office') 
		begin
			print 'show Administration Office GUI Screen'
--**********for testing begin
			exec usp_admin 'Avigail', 'passwordChange', '', '', '', '', '', '', '','avi9B'
--**********for testing end
		end
	else return
end
go

drop proc usp_admin

exec usp_admin 'Avigail', 'PersonalDetailsChange', 'barja@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'bent', 'Oranit', 'Israel', 'F',''
exec usp_admin 'Avigail', 'PersonalDetailsChange', 'avi@gmail.com', '2000-03-27 12:20:07.420', 'avigail', 'bent', 'Oranit', 'Israel', 'M',''
exec usp_admin 'Avigail', 'passwordChange', '', '', '', '', '', '', '','avi9B'

--Administration Office GUI Screen send output if PersonalDetailsChange or passwordChange
--if PersonalDetailsChange gets input from Personal Details Change GUI Screen 
--if passwordChange gets input from Password Change GUI Screen 
create proc usp_admin @username nvarchar(50), @choice nvarchar(100), @Email  Nvarchar(50), @birthdate datetime,
	@FirstName nvarchar(20), @LastName nvarchar(20), @PlayerAddress nvarchar(60), 
	@Country nvarchar(15),  @Gender nchar(1), @newPassword Nvarchar(50)
as
declare
	@NewEmail  Nvarchar(50), @Newbirthdate datetime,  @Password Nvarchar(50),
	@NewFirstName nvarchar(20), @NewLastName nvarchar(20), @NewPlayerAddress nvarchar(60), 
	@NewCountry nvarchar(15),  @NewGender nchar(1),
	@NewLineChar AS CHAR(2) = CHAR(13) + CHAR(10)
begin
	set @Password = (select PlayerPassword from Admin.utbl_players where UserName = @username)

	if (@choice = 'PersonalDetailsChange') 
		begin
			--update only what was changed
			if (@Email <> (select EmailAddress from Admin.utbl_players where UserName = @username)) set @NewEmail = @Email
			if (@birthdate <> (select birthdate from Admin.utbl_players where UserName = @username)) set @Newbirthdate = @birthdate 
			if (@FirstName <> (select FirstName from Admin.utbl_players where UserName = @username)) set @NewFirstName = @FirstName
			if (@LastName <> (select LastName from Admin.utbl_players where UserName = @username)) set @NewLastName = @LastName 
			if (@PlayerAddress <> (select PlayerAddress from Admin.utbl_players where UserName = @username)) set @NewPlayerAddress = @PlayerAddress 
			if (@Country <> (select Country from Admin.utbl_players where UserName = @username)) set @NewCountry = @Country
			if (@Gender <> (select Gender from Admin.utbl_players where UserName = @username)) set @NewGender = @Gender

			exec usp_validate_playerDetails
			   @username, @Password, @Email, @birthdate, @FirstName, @LastName, 
				   @PlayerAddress, @Country, @Gender, @choice

		end
	if (@choice = 'passwordChange')
		begin
			--check validation of password
			if (((select dbo.udf_IsPasswordInPast(@username,@newPassword)) = 'N') and 
				((select dbo.udf_PasswordSyntaxValid (@newPassword,  @username)) = 'Y'))
			begin
				--update player with new password
				update Admin.utbl_players set PlayerPassword = @newPassword where username = @username
			end
			else
				print 'The password you requested is not strong, has been used by you in the past or is frequently used. '+@NewLineChar+
					'Please enter a new password with: '+@NewLineChar+
					'at least 5 characters long, '+@NewLineChar+
					'with a combination of at least 1 small letter, '+@NewLineChar+
					'1 capital letter, 1 digit'+@NewLineChar+
					'and not like the word password.'
		end
	else return
end
go

drop proc usp_gameRequest
--called from the Game Ground GUI Screen 
create proc usp_gameRequest
           @username nvarchar(50), @GameRequest nvarchar(20)
as
begin

			--check what game to Play and send to game
			if(@GameRequest='BlackJack')
				--update bankroll
					exec usp_Blackjack @username
			else if (@GameRequest='SlotMachine')
				begin	
					exec usp_SlotMachine  @username
				end
			else print 'Game not valid, please choose BlackJack or SlotMachine';
end
go

--Game Forum GUI Screen 
--receives bet amount and check against bankroll
--if bet amount valid, sends to game according to inputted game request
create proc usp_gameForum
           @username nvarchar(50), @GameRequest nvarchar(20), @BetAmount int
as
begin
	--bet amount validation against players bankroll (<= banckroll) 
--*****************************************************************************TO DO when bankroll ready
end

--create proc usp_gameRequest
--           @username nvarchar(50), @GameRequest nvarchar(20)
--as
--begin
--	--declare @CurrentBankRoll as int = 0, @TransDate as datetime, @TransactionID as int
--	----get last CurrentBankroll for user 
--	--set @CurrentBankRoll= isnull((select LAG(CurrentBankroll, 1, 0) 
--	--								OVER (PARTITION BY CurrentBankroll ORDER BY CurrentBankroll)
--	--							from Admin.utbl_PlayerBankRoll
--	--							where username = @username),0)
--	--set @TransDate = getdate();
--	----check if BetAmount <= totalCurrentBankroll
--	--if (@CurrentBankRoll>=@BetAmount)
--	--	begin
--			--check what game to Play and send to game
--			if(@GameRequest='BlackJack')
--				--update bankroll
--				begin
--					set @CurrentBankRoll= @CurrentBankRoll-@BetAmount
--					insert into Admin.utbl_PlayerBankRoll (UserName, CurrentBankRoll, DepositAmt, WithdrawalAmt,
--													 WinAmt, LossAmt, TransDate)
--										values      (@username, @CurrentBankRoll, 0, @BetAmount,
--													 0,0, @TransDate)
--					set @TransactionID = (select transactionID from Admin.utbl_PlayerBankRoll 
--										where userName = @username and TransDate = @TransDate)
--					exec usp_Blackjack @username, @NumCards, @BetAmount, @TransactionID
--				end
--			else if (@GameRequest='SlotMachine')
--				begin	
--					set @CurrentBankRoll= @CurrentBankRoll-@BetAmount  
--					insert into Admin.utbl_PlayerBankRoll (UserName, CurrentBankRoll, DepositAmt, WithdrawalAmt,
--													 WinAmt, LossAmt, TransDate)
--										values      (@username, @CurrentBankRoll, 0, @BetAmount,
--													 0,0, @TransDate)
--					exec usp_SlotMachine;
--				end
--			else print 'Game not valid, please choose BlackJack or SlotMachine';
--	--	end
--	--else print 'Bet amount larger than balance, please choose another bet amount';

--end
--go

	--********TODO check if bet amount <= bankroll
		--@CurrentBankRoll as int = 0, @TransDate as datetime, @TransactionID as int
		----get last CurrentBankroll for user 
		--set @CurrentBankRoll= isnull((select LAG(CurrentBankroll, 1, 0) 
		--								OVER (PARTITION BY CurrentBankroll ORDER BY CurrentBankroll)
		--							from Admin.utbl_PlayerBankRoll
		--							where username = @username),0)
		--set @TransDate = getdate();
		----check if BetAmount <= totalCurrentBankroll
		--if (@CurrentBankRoll>=@BetAmount)
		--	begin
exec usp_blackjack 'Avigail', 4
exec usp_blackjack 'Avigail', 2
drop proc usp_blackjack
--blackjack game
--BlackJack GUI Screen called from the Game Forum GUI Screen 
--after checking bet amount validation and starts game according to inputted game request 
create proc usp_blackjack
           @username nvarchar(50), @NumCards int
as
begin
    declare 
	@BetAmountValid	char,
	@Counter int=0,
	@DealerCardTotal int = 0,
	@DealerCurrentCard int =0,
	@DealerCurrentCardID int = 0,
	@PlayerCardTotal int = 0,
	@PlayerCurrentCard int =0,
	@PlayerCurrentCardID int =0,
	@IsWin char

		--populate card table
		exec usp_CardTableFiller

		--get player cards
		WHILE @Counter < @NumCards 
		BEGIN
			SET @Counter += 1

			-- Get next card id as random
			set @PlayerCurrentCardID = (SELECT TOP 1 id FROM Games.utbl_cardtable ORDER BY newid())

			--select from Games.utbl_CardTable the CardNum where id = random number between 1 and 53
			set @PlayerCurrentCard = (select cardnum
									  from Games.utbl_cardtable	
									  where id = @PlayerCurrentCardID)

			--remove card from table so can't be used again
			delete from Games.utbl_cardtable
			where id = @PlayerCurrentCardID

			-- get total sum of cards
			set @PlayerCardTotal = @PlayerCardTotal+@PlayerCurrentCard 
		END
	
		--if sum of player cards>21, player looses, end of game
		if (@PlayerCardTotal > 21) 
			begin
				set @IsWin = 'N'
				--exec udf_UpdateBankroll @username, @NumCards, @BetAmount, @TransactionID, @IsWin
				--exit game
				print 'Player cards exceed 21, player looses'  
				return; 
			end

		WHILE (@DealerCardTotal<@PlayerCardTotal and @DealerCardTotal<21 )
		begin
			if (@DealerCardTotal=@PlayerCardTotal)
				begin
					set @IsWin = 'N'
					--exec udf_UpdateBankroll @username, @NumCards, @BetAmount, @TransactionID, @IsWin
					--exec usp_gamesTableUpdate
					--exit game
					print 'Dealer has more than Player. Player looses'
					return; 
				end
			--get dealer cards
			set @DealerCurrentCardID = (SELECT TOP 1 id FROM Games.utbl_cardtable ORDER BY newid())--cast(abs(rand()*(@MaxBound-1)+1)as int)

			--select the CardNum from Games.utbl_CardTable where id = random
			set @DealerCurrentCard = (select cardnum
										from Games.utbl_cardtable	
										where id = @DealerCurrentCardID)
			--remove card from table so can't be used again
			delete from Games.utbl_cardtable
			where id = @DealerCurrentCardID

			-- get total sum of cards
			set @DealerCardTotal = @DealerCardTotal+@DealerCurrentCard 

			--if sumdealer cards>21 and @PlayerCardTotal<=21, player wins, end of game 
			if (@DealerCardTotal>21) 
			begin
				set @IsWin = 'Y'
				--exec udf_UpdateBankroll @username, @NumCards, @BetAmount, @TransactionID, @IsWin
				--exec usp_gamesTableUpdate
				--exit game
				print 'Player wins'
				return; 
			end

			--if sumplayer cards<sumdealer player looses, end of game 
			if (@DealerCardTotal>@PlayerCardTotal) 
			begin
				set @IsWin = 'N'
				--exec udf_UpdateBankroll @username, @NumCards, @BetAmount, @TransactionID, @IsWin
				--exec usp_gamesTableUpdate
				--exit game
				print 'Dealer has more than Player. Player looses'
				return; 
			end
		END 
end

go

--create proc usp_gamesTableUpdate
--           @username nvarchar(50), @BetAmount int
--as
--begin
--    declare 
--end
drop proc usp_slotMachine

exec usp_slotMachine 'Avigail', 10

--slot machine game
--Slot Machine GUI Screen called from the Game Forum GUI Screen 
--after checking bet amount validation and starts game according to inputted game request 

create proc usp_slotMachine
           @username nvarchar(50)
as
begin
    declare 
	@BetAmountValid	nvarchar(1),
	@IsWin nvarchar(1),
	@Wheel1Symbol nvarchar(1),
	@Wheel2Symbol nvarchar(20),
	@Wheel3Symbol nvarchar(20),
	@PlayAgain char = 'N', @i int = 0, @Total int = 1

	--While (@i < @Total)
	--BEGIN
	--	set @i = @i+1

	--********TODO check if bet amount <= bankroll
		--	declare @CurrentBankRoll as int = 0, @TransDate as datetime, @TransactionID as int
		----get last CurrentBankroll for user 
		--set @CurrentBankRoll= isnull((select LAG(CurrentBankroll, 1, 0) 
		--								OVER (PARTITION BY CurrentBankroll ORDER BY CurrentBankroll)
		--							from Games.utbl_PlayerBankRoll
		--							where username = @username),0)
		--set @TransDate = getdate();
		----check if BetAmount <= totalCurrentBankroll
		--if (@CurrentBankRoll<@BetAmount)
		--return
		--get symbols
		set @Wheel1Symbol = (SELECT TOP 1 Symbol FROM Reference.utbl_symboltable ORDER BY newid())
		set @Wheel2Symbol = (SELECT TOP 1 Symbol FROM Reference.utbl_symboltable ORDER BY newid())
		set @Wheel3Symbol = (SELECT TOP 1 Symbol FROM Reference.utbl_symboltable ORDER BY newid())

		--check if symbols are equal
		if (@Wheel1Symbol = @Wheel2Symbol and @Wheel1Symbol = @Wheel3Symbol) 
			begin
				set @IsWin = 'Y'
			end
		else 
			begin
				set @IsWin = 'N'
			end
		--exec udf_UpdateBankroll @username, @BetAmount, @IsWin
		--exec usp_gamesTableUpdate
		print @Wheel1Symbol+', '+@Wheel2Symbol+', '+@Wheel3Symbol+'->  '+@IsWin
		--print 'For another round of the slotMachine please press enter. To return to the lobby please press back' 
		--@PlayAgain gets updated to 'Y' if user wants an additional round
		--if (@PlayAgain = 'Y')
		--	begin
		--		set @Total = @Total+1
		--	end
		--else
		--	--exit game
		--	return; 
	--END
end

go
----function to update utbl_PlayerBankRoll table on specific transation for win/loose
--create function udf_UpdateBankroll 
--		@username nvarchar(50), @NumCards int, @BetAmount int, @TransactionID int, @IsWin char
--as
--begin
--    declare @NewBankRoll int, @gameDate datetime
--	set @gameDate = getdate()
--	if (@IsWin = 'Y')
--	begin
--		--if wins, player gets bet amount*2 added on CurrentBankRoll from last transaction and WinAmt
--		set @NewBankRoll = ((select CurrentBankRoll from utbl_PlayerBankRoll 
--							where username = @username
--							and TransactionID = @TransactionID)+@BetAmount+@BetAmount)
--		update utbl_PlayerBankRoll
--		set CurrentBankRoll = @NewBankRoll,
--			WinAmt = @BetAmount 
--			where username = @username
--		and TransactionID = @TransactionID
--		insert into utbl_Games (GameName, UserName, NumWins, NumLosses, GameDate)
--				values ('BlackJack', @username, 1, 0, @gameDate)

--	end
--	else if (@IsWin = 'N')
--	begin
--		--if looses, player updates loss amount. CurrentBankRoll already updated before game
--		set @NewBankRoll = ((select CurrentBankRoll from utbl_PlayerBankRoll 
--							where username = @username
--							and TransactionID = @TransactionID)-@BetAmount)
--		update utbl_PlayerBankRoll
--		set CurrentBankRoll = @NewBankRoll,
--			LossAmt = @BetAmount 
--			where username = @username
--		and TransactionID = @TransactionID
--		insert into utbl_Games (GameName, UserName, NumWins, NumLosses, GameDate)
--		values ('BlackJack', @username, 0, 1, @gameDate)
--	end
--end

go 
drop proc usp_CardTableFiller

exec usp_CardTableFiller
--fill card table with 4 sets of 13 consecutive numbers
create proc usp_CardTableFiller
as
begin
declare @Counter as int = 0, @NumCards as int =4, @CardNum as int, @InnerCounter as int = 0, @InnerNumCards as int =13
--remove old cards from table
DBCC CHECKIDENT ('Games.utbl_CardTable', RESEED, 0)  
delete from Games.utbl_cardtable

--populate table with 4 sets of 13 consecutive numbers 
	WHILE @Counter < @NumCards BEGIN
		SET @Counter += 1
		WHILE @InnerCounter < @InnerNumCards BEGIN
			set @InnerCounter +=1
			-- insert card 
			set @CardNum = @InnerCounter
			insert into Games.utbl_CardTable (CardNum) values (@CardNum)
		end
		set @InnerCounter = 0
	end

end

go

drop proc usp_SymbolTableFiller
exec usp_SymbolTableFiller
--fill symbol table with 3 sets of 6 unique symbols
create proc usp_SymbolTableFiller
as
begin
declare @Counter as int = 0, @Symbol as char(1), @InnerCounter as int = 0, @NumSymbols as int =6
--remove old symbols from table
DBCC CHECKIDENT ('Reference.utbl_SymbolTable', RESEED, 0)  
delete from Reference.utbl_SymbolTable
--populate table with  6 unique symbols 
		WHILE @Counter <  @NumSymbols BEGIN
			set @InnerCounter +=1
			-- insert card 
			set @Symbol = (select substring('#@%&*!', @Counter, 1))

			insert into Reference.utbl_SymbolTable (Symbol) values (@Symbol)
		end
		set @Counter = 0
end

delete from Reference.utbl_SymbolTable
--create function udf_PasswordValidation
--           (@username nvarchar(50), @password nvarchar(50))
--returns char(1)
--as
--begin
--declare @passwordValid char(1)
--	--check if password is legal
--	if (len(@password) >= 5 
--		and (PATINDEX(N'%[ABCDEFGHIJKLMNOPQRSTUVWXYZ]%' , 
--									@password collate SQL_Latin1_General_CP1_CS_AS)> 0)
--		and (PATINDEX(N'%[abcdefghijklmnopqrstuvwxyz]%' , 
--									@password COLLATE SQL_Latin1_General_CP1_CS_AS)> 0)
--		and (@password like '%[0-9]%' )
--		and (@password COLLATE SQL_Latin1_General_CP1_CS_AS not like N'%WORD%')
--		and (@password COLLATE SQL_Latin1_General_CP1_CS_AS not like N'%PASS%')
--		and (@password COLLATE SQL_Latin1_General_CP1_CS_AS not like N'%pass%')
--		and (@password COLLATE SQL_Latin1_General_CP1_CS_AS not like N'%word%'))
--			--check if player already used the passsword in the past
--			if ((select count(PlayerPassword) from Admin.utbl_playersHistory 
--					where PlayerPassword = @password COLLATE SQL_Latin1_General_CP1_CS_AS 
--					and username = @username)=0)
--				begin
--					set @passwordValid= 'Y'
--					return (@passwordValid)
--				end
--			else
--				begin
--					set @passwordValid = 'N'
--					return (@passwordValid)
--				end
--	else
--		begin
--			set @passwordValid = 'N';
--			return (@passwordValid)
--		end
--	return (@passwordValid)
--end

--populate Admin.utbl_CompanyDefinitions table
insert into Admin.utbl_CompanyDefinitions (CompanyKey, companyvalue)
values ('welcomeBonus', 10);
insert into Admin.utbl_CompanyDefinitions (CompanyKey, companyvalue)
values ('logonTimes', 5);
insert into Admin.utbl_CompanyDefinitions (CompanyKey, companyvalue)
values ('betBonus', 50);

drop proc usp_CompanyDefinitions

exec usp_CompanyDefinitions 'insert', 'welcomeBonus', 10
exec usp_CompanyDefinitions 'insert', 'logonTimes', 5
exec usp_CompanyDefinitions 'insert', 'betBonus', 50

create proc usp_CompanyDefinitions @action nvarchar(20), @CompanyKey nvarchar(20), @CompanyValue int
as
begin
	if (@action = 'insert')
		begin
			insert into Admin.utbl_CompanyDefinitions (CompanyKey, CompanyValue)
			values (@CompanyKey, @CompanyValue);
		end
	if (@action = 'update')
		begin
			update Admin.utbl_CompanyDefinitions
			set Companyvalue = @CompanyValue
			where CompanyKey = @CompanyKey
		end
	if (@action = 'delete')
		begin
			delete from Admin.utbl_CompanyDefinitions
			where CompanyKey = @CompanyKey
		end
end
go

--SELECT *
--  FROM msdb..syspolicy_management_facets
--  WHERE execution_mode % 2 = 1;

--select * from msdb.dbo.syspolicy_policy_execution_history_details_internal





use Casino
go
--unique username
--password:
--		5 chars
--		small, big chars, digit
--		not equal to existing password in password table
--		not 'password' in any combination
--email address: unique, legal format with @
--birthdate over 18 years
create proc usp_validate_registration
           @username nvarchar(20), @Password Nvarchar(50), 
		   @Email  Nvarchar(50), @birthdate datetime,
		   @FirstName nvarchar(20), @LastName nvarchar(20), 
		   @PlayerAddress nvarchar(60), @Country nvarchar(15),
		   @Gender nchar(1)
as
begin
    declare @userNameValid	nchar,
	@passwordValid	nchar,
	@emailValid	nchar,
	@birthdateValid nchar,
	@NumFails smallint = 0, 
	@IsBlocked nchar = 'N', 
	@LoginTime datetime = getdate(), 
	@IsConnected nchar = 'Y',
	@DepositAmt int
	
	--check if username exists
	if ((select count(player_username)
		from utbl_players
		where username = @username)=0)
		set @userNameValid = 'Y';
	else
		set @userNameValid = 'N';

	--check if password is legal
	if (len(@password) = 5 and charindex('[a-z]',@password)>0
		and charindex('[A-Z]',@password)>0 and 
		charindex('[0-9]',@password)>0 
		and charindex('P[ASS,SS,WORD,WRD,WD]',@password)=0
		and charindex('p[ass,ss,word,wrd,wd]',@password)=0
		and (select ExtPassword from utbl_Passwords where ExtPassword = @password)>0)
		set @passwordValid= 'Y';
	else
		set @passwordValid = 'N';
	--check if email is legalband doesn't already exist
	if ((@Email <> '' AND @Email NOT LIKE '_%@__%.__%')
		and (select count(EmailAddress) from utbl_players
			where EmailAddress = @Email)=0)
		set @emailValid = 'Y'
	else
		set @emailValid = 'N'
	--check if user over 18
	if (iif(datediff(dd, datediff(dd,getdate(), DATEADD (dd, -1, (DATEADD(yy, (DATEDIFF(yy, 0, GETDATE()) +1), 0)))),
           datediff(dd,@birthdate, DATEADD (dd, -1, (DATEADD(yy, (DATEDIFF(yy, 0, @birthdate ) +1), 0))))) < 0,
		   datediff(yy,@birthdate,getdate())-1, datediff(yy,@birthdate,getdate())) >= 18)
		set @birthdateValid = 'Y'
	else
		set @birthdateValid = 'N'

	--if all inputs are valid, insert new user to utbl_players table
	--and add new password to utbl_passwords table
	if (@birthdateValid = 'Y' and @emailValid = 'Y' and @passwordValid= 'Y' and @userNameValid = 'Y')
	begin
		set @DepositAmt = (select value from utbl_CompanyDefinitions where CompanyKey='welcomeBonus')
		insert into utbl_PlayerBankroll ([UserName], [CurrentBankRoll], [DepositAmt], [WithdrawalAmt],
										 [WinAmt], [LossAmt])
								 values (@username, 0, @DepositAmt, 0, 0, 0);
		insert into utbl_players (UserName, PlayerPassword, FirstName, LastName, PlayerAddress, Country,
								  EmailAddress, Gender, BirthDate, NumFails, IsBlocked, LoginTime, IsConnected)
						values (@username, @password, @FirstName, @LastName, @PlayerAddress, @Country,
								@Email, @Gender, @birthdate, @NumFails, @IsBlocked, @LoginTime, @IsConnected)
	end
--exec create_NewDBUser @username sysname, @Password Nvarchar(200), 
--		   @Email  Nvarchar(200), @birthdate datetime


--insert git passwords to utbl_passwords table from
--https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10-million-password-list-top-100.txt


--BULK
--INSERT utbl_Passwords
--FROM 'https://github.com/danielmiessler/SecLists/blob/master/Passwords/Common-Credentials/10-million-password-list-top-100.txt'
--WITH
--(
--FIELDTERMINATOR = '|',
--ROWTERMINATOR = '\n'
--)
--GO
end

create proc usp_Login
           @username nvarchar(20), @PlayerPassword nvarchar(50)
as
begin
    declare @numTries int = 1, @AdminNumTries int 
	set @AdminNumTries = (select CompanyValue from utbl_CompanyDefinitions where CompanyKey = 'logonTimes')

	WHILE @numTries < @AdminNumTries BEGIN
		--password validation
		if (select count(UserName) from utbl_Players where PlayerPassword= @PlayerPassword 
			and username =@username) =0
		begin
			set @numTries = @numTries+1
			continue;
		end

		--if blocked
		if (select IsBlocked from utbl_PlayerLogin where UserName=@username)='Y'
		begin
			print 'You are currently blocked please contact administration'
			return;
		end
		else
		begin
			update utbl_PlayerLogin
			set LoginTime = getdate(), 
			IsConnected = 'Y', IsConnected = 'N'
			where UserName=@username
			break;
		end
		--loop to try again   
    end   
	if (@numTries < @AdminNumTries)
	begin
		update utbl_PlayerLogin 
		set IsBlocked = 'Y',
		IsConnected = 'N'
		where UserName=@username
		print 'You have entered the wrong password too many times and are now blocked. Please contact the administration'
		return
    end                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
END


create proc usp_blackjack
           @username nvarchar(20), @NumCards int, @BetAmount int, @TransactionID int
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
	@MaxBound int = 53,
	@IsWin char
	
	--populate card table
	exec usp_CardTableFiller

	--get player cards
	WHILE @Counter < @NumCards BEGIN
		SET @Counter += 1
		-- Get next card id as random(53-1)+1
		--set @PlayerCurrentCardID = cast(abs(rand()*(@MaxBound-1)+1)as int)
		--each time remove random max boundry (53) because less cards
		set @PlayerCurrentCardID = (SELECT TOP 1 id FROM utbl_cardtable ORDER BY newid())

		set @MaxBound = @MaxBound -1 
		--select from utbl_CardTable the CardNum where id = random number between 1 and 53
		set @PlayerCurrentCard = (select cardnum
								  from utbl_cardtable	
								  where id = @PlayerCurrentCardID)
		--remove card from table so can't be used again
		delete from utbl_cardtable
		where id = @PlayerCurrentCardID

		-- get total sum of cards
		set @PlayerCardTotal = @PlayerCardTotal+@PlayerCurrentCard 
	END
	
	--if sum of player cards>21, player looses, end of game
	if (@PlayerCardTotal>21) 
		begin
			@IsWin = 'N'
			exec udf_UpdateBankroll @username, @NumCards, @BetAmount, @TransactionID, @IsWin
		end
	--exit game
	print 'Player cards exceed 21, player looses'
	return; 

	WHILE (@DealerCardTotal<@PlayerCardTotal and @DealerCardTotal<21 )
		--get dealer cards
		set @DealerCurrentCardID = cast(abs(rand()*(@MaxBound-1)+1)as int)
		--each time remove random max boundry because less cards
		set @MaxBound = @MaxBound -1
		--select the CardNum from utbl_CardTable where id = random(1-53) everytime 53-1
		set @DealerCurrentCard = (select cardnum
									from utbl_cardtable	
									where id = @DealerCurrentCardID)
		--remove card from table so can't be used again
		delete from utbl_cardtable
		where id = @DealerCurrentCardID

		-- get total sum of cards
		set @DealerCardTotal = @DealerCardTotal+@DealerCurrentCard 

		--if sumdealer cards>21 and @PlayerCardTotal<=21, player wins, end of game 
		if (@DealerCardTotal>21) 
		begin
			@IsWin = 'Y'
			exec udf_UpdateBankroll @username, @NumCards, @BetAmount, @TransactionID, @IsWin
			--exit game
			print 'Player wins'
			return; 
		end

		--if sumplayer cards<sumdealer player looses, end of game 
		if (@DealerCardTotal>@PlayerCardTotal) 
		begin
			@IsWin = 'N'
			exec udf_UpdateBankroll @username, @NumCards, @BetAmount, @TransactionID, @IsWin
			--exit game
			print 'Dealer has more than Player. Player looses'
			return; 
		end
	END
end
go


--function to update utbl_PlayerBankRoll table on specific transation for win/loose
create procedure udf_UpdateBankroll 
		@username nvarchar(20), @NumCards int, @BetAmount int, @TransactionID int, @IsWin char
as
begin
    declare @NewBankRoll int, @gameDate datetime
	set @gameDate = getdate()
	if (@IsWin = 'Y')
	begin
		--if wins, player gets bet amount*2 added on CurrentBankRoll from last transaction and WinAmt
		set @NewBankRoll = ((select CurrentBankRoll from utbl_PlayerBankRoll 
							where username = @username
							and TransactionID = @TransactionID)+@BetAmount+@BetAmount)
		update utbl_PlayerBankRoll
		set CurrentBankRoll = @NewBankRoll,
			WinAmt = @BetAmount 
			where username = @username
		and TransactionID = @TransactionID
		insert into utbl_Games (GameName, UserName, NumWins, NumLosses, GameDate)
				values ('BlackJack', @username, 1, 0, @gameDate)

	end
	else if (@IsWin = 'N')
	begin
		--if looses, player updates loss amount. CurrentBankRoll already updated before game
		set @NewBankRoll = ((select CurrentBankRoll from utbl_PlayerBankRoll 
							where username = @username
							and TransactionID = @TransactionID)-@BetAmount)
		update utbl_PlayerBankRoll
		set CurrentBankRoll = @NewBankRoll,
			LossAmt = @BetAmount 
			where username = @username
		and TransactionID = @TransactionID
		insert into utbl_Games (GameName, UserName, NumWins, NumLosses, GameDate)
		values ('BlackJack', @username, 0, 1, @gameDate)
	end
end


--fill card table with 4 sets of 13 consecutive numbers
alter proc usp_CardTableFiller
as
begin
declare @Counter as int = 0, @NumCards as int =4, @CardNum as int, @InnerCounter as int = 0, @InnerNumCards as int =13
--remove old cards from table
DBCC CHECKIDENT ('utbl_CardTable', RESEED, 0)  
delete from utbl_cardtable

--populate table with 4 sets of 13 consecutive numbers 
	WHILE @Counter < @NumCards BEGIN
		SET @Counter += 1
		WHILE @InnerCounter < @InnerNumCards BEGIN
			set @InnerCounter +=1
			-- insert card 
			set @CardNum = @InnerCounter
			insert into utbl_CardTable (CardNum) values (@CardNum)
		end
		set @InnerCounter = 0
	end

end


create proc usp_gameRequest
           @username nvarchar(20), @BetAmount int, @GameRequest nvarchar(20)
as
begin
	declare @CurrentBankRoll as int = 0, @TransDate as datetime, @TransactionID as int
	--get last CurrentBankroll for user 
	set @CurrentBankRoll= isnull((select LAG(CurrentBankroll, 1, 0) 
									OVER (PARTITION BY CurrentBankroll ORDER BY CurrentBankroll)
								from utbl_PlayerBankRoll
								where username = @username),0)
	set @TransDate = getdate();
	--check if BetAmount <= totalCurrentBankroll
	if (@CurrentBankRoll>=@BetAmount)
		begin
			--check what game to Play and send to game
			if(@GameRequest='BlackJack')
				--update bankroll
				begin
					set @CurrentBankRoll= @CurrentBankRoll-@BetAmount
					insert into utbl_PlayerBankRoll (UserName, CurrentBankRoll, DepositAmt, WithdrawalAmt,
													 WinAmt, LossAmt, TransDate)
										values      (@username, @CurrentBankRoll, 0, @BetAmount,
													 0,0, @TransDate)
					set @TransactionID = (select transactionID from utbl_PlayerBankRoll 
										where userName = @username and TransDate = @TransDate)
					exec usp_Blackjack @username, @NumCards, @BetAmount, @TransactionID
				end
			else if (@GameRequest='SlotMachine')
				begin	
					set @CurrentBankRoll= @CurrentBankRoll-@BetAmount  
					insert into utbl_PlayerBankRoll (UserName, CurrentBankRoll, DepositAmt, WithdrawalAmt,
													 WinAmt, LossAmt, TransDate)
										values      (@username, @CurrentBankRoll, 0, @BetAmount,
													 0,0, @TransDate)
					exec usp_SlotMachine;
				end
			else print 'Game not valid, please choose BlackJack or SlotMachine';
		end
	else print 'Bet amount larger than balance, please choose another bet amount';

end
go

--create proc usp_InsertBankroll
--           @username nvarchar(20), @BetAmount int, @GameRequest nvarchar(20)
--as
--begin
--	declare @CurrentBankRoll as int = 0, 



--populate utbl_CompanyDefinitions table
insert into utbl_CompanyDefinitions (CompanyKey, companyvalue)
values ('welcomeBonus', 10);
insert into utbl_CompanyDefinitions (CompanyKey, companyvalue)
values ('logonTimes', 5);
insert into utbl_CompanyDefinitions (CompanyKey, companyvalue)
values ('betBonus', 50;
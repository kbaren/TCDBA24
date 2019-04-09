-- ================================================
-- Template generated from Template Explorer using:
-- Create Scalar Function (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the function.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		
-- Create date: 
-- Description:	
-- =============================================

CREATE OR ALTER FUNCTION [udf_Bankroll]
(
	-- Add the parameters for the function here
	@UserName NVARCHAR(50)
)
RETURNS FLOAT
AS
BEGIN
	-- Declare the return variable here
	DECLARE @Bankroll	FLOAT = 0,
			@Deposit	FLOAT = 0,
			@Withdrawal FLOAT = 0,
			@Bet		FLOAT = 0,
			@Win		FLOAT = 0,
			@Bonus		FLOAT = 0

	-- Add the T-SQL statements to compute the return value here
	SELECT @Deposit = ISNULL(SUM([Ammount]),0) from [Admin].[utbl_Transactions] where [Type] = 'Deposit' and username = @UserName
	SELECT @Withdrawal = ISNULL(SUM([Ammount]),0) from [Admin].[utbl_Transactions] where [Type] = 'Withdrawal' and username = @UserName
	SELECT @Bet = ISNULL(SUM([Ammount]),0) from [Admin].[utbl_Transactions] where [Type] = 'Bet' and username = @UserName
	SELECT @Win = ISNULL(SUM([Ammount]),0) from [Admin].[utbl_Transactions] where [Type] = 'Win' and username = @UserName
	SELECT @Bonus = ISNULL(SUM([Ammount]),0) from [Admin].[utbl_Transactions] where [Type] = 'Bonus' and username = @UserName

	select @Bankroll = @Deposit - @Withdrawal - @Bet + @Win + @Bonus

	-- Return the result of the function
	
	RETURN (@Bankroll)

END
GO


-- ================================================
-- Template generated from Template Explorer using:
-- Create Procedure (New Menu).SQL
--
-- Use the Specify Values for Template Parameters 
-- command (Ctrl-Shift-M) to fill in the parameter 
-- values below.
--
-- This block of comments will not be included in
-- the definition of the procedure.
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
DROP PROCEDURE IF EXISTS usp_MoneyWithdrawal
GO
CREATE PROCEDURE usp_MoneyWithdrawal
	-- Add the parameters for the stored procedure here
	@userName				NVARCHAR(50)	, 
	@withdrawalAmmount		FLOAT			,
	@shippingAdress			NVARCHAR(500)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Check that procedure received all parameters and they are correct
	IF @userName is NULL or @withdrawalAmmount is NULL or @shippingAdress is NULL
		BEGIN 
			PRINT 'Please insert correct parameters'
			RETURN
		END
	ELSE
	-- Check that the deposit ammount is smaller than 1000
		BEGIN
			IF @withdrawalAmmount> dbo.[udf_Bankroll](@userName)
				BEGIN
					PRINT  'Your current balance ' + CONVERT(nvarchar, dbo.[udf_Bankroll](@userName)) + '  is too small. Try smaller ammount'
					RETURN
				END
			ELSE
	-- If all the parameters are correct isert data to Transactions table and show the user current balance
				BEGIN
					INSERT INTO [Admin].[utbl_Transactions]
					VALUES
						(@userName, @withdrawalAmmount, 'Withdrawal', GETDATE())
					PRINT  'Thank you! Your current balance is ' + CONVERT(nvarchar, dbo.[udf_Bankroll](@userName))
					PRINT  'The check will be sent to ' + @shippingAdress + '. Please inform our Support Team at support@casino.com if you didn''t receive the check in 5 post days'  
				END
		END
END
GO

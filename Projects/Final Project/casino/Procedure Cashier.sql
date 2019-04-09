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
CREATE OR ALTER PROCEDURE usp_Cashier 
	-- Add the parameters for the stored procedure here
	@userName	NVARCHAR(50)	, 
	@action		NVARCHAR(10)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF  @action = 'Deposit'
		BEGIN
			PRINT 'Please insert credit card number, expiry date and deposit ammount'
			DECLARE
				@creditCardNumber	nvarchar(20)	,
				@ExpiryDate			nvarchar(10)	,
				@depositAmmount		float		
			EXEC usp_MoneyDeposit @userName = @userName, @creditCardNumber = @creditCardNumber, @ExpiryDate = @ExpiryDate, @depositAmmount = @depositAmmount
		END
	ELSE
		BEGIN
			IF  @action = 'Withdrawal'
				BEGIN
					PRINT 'Please insert credit card number, expiry date and deposit ammount'
					DECLARE
						@withdrawalAmmount		FLOAT			,
						@shippingAdress			NVARCHAR(500)
					EXEC usp_MoneyWithdrawal @userName = @userName, @withdrawalAmmount = @withdrawalAmmount, @shippingAdress = @shippingAdress
				END

			
		END
END
GO

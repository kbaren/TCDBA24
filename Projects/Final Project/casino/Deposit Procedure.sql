-- ================================================
-- Procedure to insert deposit transaction
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
DROP PROCEDURE IF EXISTS usp_MoneyDeposit
GO
CREATE PROCEDURE usp_MoneyDeposit 
	-- Add the parameters for the stored procedure here
	@userName			nvarchar(50)	, 
	@creditCardNumber	nvarchar(20)	,
	@ExpiryDate			nvarchar(10)	,
	@depositAmmount		float			
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	-- Check parameters and ammount

    -- Validate Expiry Date
	DECLARE @Month	INT,
			@Year	INT
	select @Month = CONVERT(INT,LEFT(@ExpiryDate,2))
	select @Year  = CONVERT(INT,RIGHT(@ExpiryDate,4))
	PRINT @Month
	PRINT @Year
	IF @Month not between 1 and 12 or @Year not between 1900 and 9999
		BEGIN 
			PRINT 'Invalid expiry date. Please check.'
			RETURN
		END
	ELSE
		BEGIN
			IF (@Month< MONTH(GETDATE()) and  @Year <= YEAR(GETDATE()))
				BEGIN
					PRINT 'Your credit card is expired. Please use another card.'
					RETURN
				END
			-- Insert deposit into Cretit Card and Transactions tables
			ELSE
				BEGIN
					OPEN SYMMETRIC KEY CreditCard_key  
						DECRYPTION BY CERTIFICATE CreditCards_certificate

					INSERT INTO [Admin].utbl_CreditCard
					VALUES
						(@userName, EncryptByKey(Key_GUID('CreditCard_key'), @creditCardNumber), @ExpiryDate)
					
					CLOSE SYMMETRIC KEY CreditCard_key 

					INSERT INTO [Admin].[utbl_Transactions]
					VALUES
						(@userName, @depositAmmount, 'Deposit', GETDATE())

					PRINT  'Your current balance ' + CONVERT(nvarchar, dbo.[udf_Bankroll](@userName))
				END
			END

END

GO

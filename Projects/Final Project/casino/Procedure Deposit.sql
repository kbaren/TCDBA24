-- ================================================
-- Procedure to insert deposit transaction
-- ================================================
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON

GO
CREATE OR ALTER PROCEDURE usp_MoneyDeposit 
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

	-- Declare Sub parameters for validation
	DECLARE @Month	NVARCHAR(2),
			@Year	NVARCHAR(4)
	select @Month = LEFT(@ExpiryDate,2)
	select @Year  = RIGHT(@ExpiryDate,4)

	-- Check that procedure received all parameters and they are correct
	IF @userName is NULL or @creditCardNumber is NULL or @ExpiryDate is NULL or @depositAmmount is NULL or ISNUMERIC(@Month) = 0 or ISNUMERIC(@Year) = 0 or ISNUMERIC(@creditCardNumber) = 0
		BEGIN 
			PRINT 'Please insert correct parameters.'
			RETURN
		END
	ELSE
	-- Check that the deposit ammount is smaller than 1000
		BEGIN
			IF @depositAmmount>'1000'
				BEGIN
					PRINT 'Please insert deposit ammount smaller than 1000.'
					RETURN
				END
			ELSE
    -- Validate that exiry date is correct date
				BEGIN
					IF CONVERT(int,@Month) not between 1 and 12 or CONVERT(int,@Year) not between 1900 and 9999
						BEGIN 
							PRINT 'Invalid expiry date. Please check.'
							RETURN
						END
					ELSE
	-- Check that the card isn't expired
						BEGIN
							IF (@Month< MONTH(GETDATE()) and  @Year <= YEAR(GETDATE()))
								BEGIN
									PRINT 'Your credit card is expired. Please use another card.'
									RETURN
								END
							ELSE

	-- Insert deposit into Cretit Card and Transactions tables
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
		END
END

GO
USE Casino;  
GO  
-- Create Master key for sertificate
CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'CasinoProject_TCDBA24'   
GO  
-- Create certificate
CREATE CERTIFICATE CreditCards_certificate
   WITH SUBJECT = 'Players Credit Cards numbers';  

GO

-- Create encryption key
CREATE SYMMETRIC KEY CreditCard_key  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE CreditCards_certificate;  
GO  

USE Casino;  
GO  

-- Create a column in which to store the encrypted data.  
DROP TABLE IF EXISTS  [Admin].utbl_CreditCard
GO
CREATE TABLE [Admin].utbl_CreditCard 
	(
	UserName			NVARCHAR(50) NOT NULL,
	CreditCardNumber	VARBINARY(128) NOT NULL,
	ExpiryDate			NVARCHAR(10) NOT NULL
	)

GO  
truncate table [Admin].utbl_Transactions
exec usp_MoneyDeposit 'TestAvigail', '123456789' , '11/2020', '100.456'

select * 
from [Admin].utbl_CreditCard

Select *
from [Admin].utbl_Transactions

select dbo.[udf_Bankroll]('TestKarina')


exec usp_MoneyWithdrawal 'TestKarina', '12' , 'Bla Bla Test'
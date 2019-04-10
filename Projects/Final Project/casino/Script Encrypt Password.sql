select *
from admin.utbl_Players

alter table admin.utbl_Players
add playerPassword	VARBINARY(128) NOT NULL 

-- Create certificate
CREATE CERTIFICATE Password_certificate
   WITH SUBJECT = 'Players Passwords';  

GO

-- Create encryption key
CREATE SYMMETRIC KEY Password_key  
    WITH ALGORITHM = AES_256  
    ENCRYPTION BY CERTIFICATE Password_certificate;  
GO  

OPEN SYMMETRIC KEY Password_key  
	DECRYPTION BY CERTIFICATE Password_certificate; 

insert into Admin.utbl_Players (UserName, FirstName, LastName, PlayerAddress, EmailAddress, BirthDate, PlayerPassword)
values
('TestKarina', 'Karina', 'Barenbaum', 'BlaBla 30', 'Barjonya@gmail.com', '1989-08-25', EncryptByKey(Key_GUID('Password_key'), 'dhaskfhdakhfkajdj'))

CLOSE SYMMETRIC KEY Password_key

select *
from Admin.utbl_Players

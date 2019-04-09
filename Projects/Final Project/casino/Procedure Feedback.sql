
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

CREATE OR ALTER PROCEDURE usp_Feedback 
	-- Add the parameters for the stored procedure here
	@userName	nvarchar(50)  = '', 
	@feedback	nvarchar(max) = '',
	@subject	nvarchar(20)
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE 
		@email	nvarchar(100)
	-- Set players email
	SELECT @email = EmailAddress
	FROM admin.utbl_Players
	where UserName = @userName
	-- Send email
	EXEC msdb.dbo.sp_send_dbmail
    @profile_name = 'Public Profile', 
	@from_address= @email,
	@recipients = 'barjonya@gmail.com', 
    @subject = @subject,
    @body = @feedback,
    @body_format = 'HTML',
    @query_no_truncate = 1,
    @attach_query_result_as_file = 0;
END
GO

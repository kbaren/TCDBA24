CREATE OR ALTER PROCEDURE [dbo].[AddIterationstoIterationsDictionary]
WITH EXECUTE AS CALLER
AS
BEGIN
IF (SELECT  max([START_DATE])  FROM [dbo].[IterationsDictionary])<=getdate()
BEGIN
	DECLARE @IterationNumber INT,
			@IterationName NVARCHAR(100),
			@StartDate DATE,
			@EndDate DATE,
			@GroupID INT = 0,
			@IterationLength INT,
			@Add INT = 100 --How many iterations to add..


	SELECT @IterationNumber = MAX(ITERATION_NUMBER)
	FROM IterationsDictionary

	SELECT @IterationLength = DATEDIFF(DD,[START_DATE], END_DATE)
	FROM IterationsDictionary
	WHERE ITERATION_NUMBER = 1

	SELECT @StartDate = DATEADD(DD, @IterationLength + 1, [START_DATE]), @EndDate = DATEADD(DD, @IterationLength + 1, END_DATE)
	FROM IterationsDictionary
	WHERE ITERATION_NUMBER = @IterationNumber

	SELECT @IterationName = REPLACE(@EndDate, '-', '_')

	IF (SELECT MAX(ITERATION_NUMBER) FROM IterationsDictionary WHERE DISCOUNT_FACTOR > 0) = (SELECT MAX(ITERATION_NUMBER) FROM IterationsDictionary)
		AND (SELECT GETDATE())>=@StartDate
	BEGIN
		PRINT ('One full iteration')
		INSERT INTO IterationsDictionary 
		SELECT GROUP_ID, ITERATION_NUMBER + 1, REPLACE(@EndDate, '-', '_'), MIGRATION_PERIODS, LTV_PERIODS, DISCOUNT_FACTOR, STEP, DEVIATION, RATIO, @StartDate, @EndDate
		FROM IterationsDictionary b
		WHERE b.ITERATION_NUMBER=(SELECT MAX(ITERATION_NUMBER) FROM IterationsDictionary WHERE DISCOUNT_FACTOR > 0 )

		SELECT @IterationNumber = MAX(ITERATION_NUMBER)
		FROM IterationsDictionary
	END

	WHILE (@Add > 0)
	BEGIN
		PRINT('Only Empty iterations')
		SELECT @StartDate = DATEADD(DD, @IterationLength + 1, [START_DATE]), @EndDate = DATEADD(DD, @IterationLength + 1, END_DATE)
		FROM IterationsDictionary
		WHERE ITERATION_NUMBER = @IterationNumber
	
		SELECT @IterationName = REPLACE(@EndDate, '-', '_')
	
		SET @IterationNumber = @IterationNumber + 1
	
		INSERT INTO IterationsDictionary VALUES
		(@GroupID, @IterationNumber, @IterationName, 0, 0, 0, 1, 1000, 0, @StartDate, @EndDate)	
	
		SET	@Add = @Add - 1
	
	END

	RAISERROR('? - Completed',0,1) WITH NOWAIT;
END
ELSE
	RAISERROR('? - No iterations to add',0,1) WITH NOWAIT;
END
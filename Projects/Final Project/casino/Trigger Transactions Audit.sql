DROP TABLE IF EXISTS [Security].[utbl_Transactions_audit]
CREATE TABLE [Security].[utbl_Transactions_audit](
    TransactionID		INT PRIMARY KEY NOT NULL,
    Username			nvarchar(50) NOT NULL,
    Ammount				Float NOT NULL,
    Type				nvarchar(50) NOT NULL,
    Transaction_Date	datetime NOT NULL,
    operation			nvarchar(10) NOT NULL,
    CHECK(operation = 'Inserted' or operation='Deleted')
);
USE Casino
GO
CREATE OR ALTER TRIGGER ADMIN.trg_transaction_audit
ON [Admin].[utbl_Transactions]
AFTER INSERT, DELETE
NOT FOR REPLICATION
AS
BEGIN
    SET NOCOUNT ON;
    INSERT INTO [Security].[utbl_Transactions_audit](
    TransactionID		,
    Username			,
    Ammount				,
    Type				,
    Transaction_Date	,
	operation
    )
    SELECT
        i.TransactionID,
        i.Username,
        i.Ammount,
        i.Type,
        i.Transaction_Date,
        'Inserted'
    FROM
        inserted i
    UNION ALL
    SELECT
        d.TransactionID,
        d.Username,
        d.Ammount,
        d.Type,
        d.Transaction_Date,
        'Deleted'
    FROM
        deleted d;
END


--exec usp_MoneyDeposit 'TestKarina', '4978745' , '02/2020', '1500'


--select *
--from [Admin].[utbl_Transactions]

--select *
--from [Security].[utbl_Transactions_audit]
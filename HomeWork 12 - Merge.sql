--- 1 ---
drop table if exists #ActionTable
CREATE TABLE #ActionTable  
    (ActionTaken nvarchar(50),
	 ExistingEmployeeID nvarchar(50), 
	 NewEmployeeID nvarchar(50),   
     ExistingFirstName nvarchar(50), 
	 ExistingLastName nvarchar(50), 
     NewFirstName nvarchar(50),  
     NewLastName nvarchar(50)  
    )
SET IDENTITY_INSERT Northwind..Employees ON
MERGE Northwind..Employees AS target 
USING (select BusinessEntityID, ISNULL(LastName,''), ISNULL(FirstName + ' ' + MiddleName, ''), Title
from Person.Person )  as source (EmployeeID, LastName, FirstName, Title)
ON (target.EmployeeID = source.EmployeeID)
WHEN MATCHED 
THEN 
update set LastName = source.lastname, firstname = source.firstname, title = source.title
WHEN NOT MATCHED BY TARGET
THEN 
    INSERT (EmployeeID, LastName, FirstName, Title)
    VALUES (source.EmployeeID, source.LastName, source.FirstName, source.title)  
OUTPUT $action, deleted.EmployeeID, inserted.EmployeeID, deleted.firstname, deleted.lastname, inserted.firstname, inserted.lastname INTO #ActionTable;  
SET IDENTITY_INSERT Northwind..Employees OFF


select *
from #ActionTable
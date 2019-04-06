--1--
use master
go

Declare @str varchar(20)
Declare Mycursor cursor
for select name from sys.databases where LEN(name) = 6
open Mycursor
Fetch next from Mycursor into @str
while @@FETCH_STATUS=0
begin 
Print 'BACKUP DATABASE ['+@str+'] TO DISK=''C:\Backup\eDate'+cast(getdate() as varchar)+'.bak'''
Fetch next from Mycursor into @str
end 
close Mycursor
Deallocate Mycursor

go

--2--
use northwind
go

Declare @name varchar(20), @price int
Declare Mycursor cursor
for select ProductName, UnitPrice from Products order by UnitPrice desc
open Mycursor
Fetch next from Mycursor into @name, @price
while @@FETCH_STATUS=0
begin 
Print 'Product Name:'+@name+', Price:'+cast(@price as char(10))
Fetch next from Mycursor into @name, @price
end 
close Mycursor
Deallocate Mycursor

go

--3--

use northwind
go

Declare @name varchar(20), @First varchar(20), @Family varchar(20)
Declare Mycursor cursor
for select contactname from customers
open Mycursor
Fetch next from Mycursor into @name
while @@FETCH_STATUS=0
begin 
set @First = substring(@name, 1, charindex(' ',@name))
set @Family = right(@name, charindex(' ',@name))
Print 'Contact Name:'+@name+' ****First: '+@First+' ****Family: '+@Family
Fetch next from Mycursor into @name
end 
close Mycursor
Deallocate Mycursor

go


--4--

use northwind
go

DECLARE @EmpID INT,
        @EmpFName VARCHAR(50),
        @EmpLName VARCHAR(50),
		@BirthDate datetime
Declare Mycursor cursor
for select EmployeeID, FirstName, LastName, BirthDate from Employees
open Mycursor
Fetch next from Mycursor INTO @EmpID, @EmpFName, @EmpLName, @BirthDate

while @@FETCH_STATUS=0
begin 
Print 'Employees Details: '+cast(@EmpID as varchar)+', '+ @EmpFName+', '+ @EmpLName+', '+ cast(@BirthDate as varchar)
waitfor delay '00:00:02'
Fetch next from Mycursor INTO @EmpID, @EmpFName, @EmpLName, @BirthDate

end 
close Mycursor
Deallocate Mycursor

go

--all the changes made in the Dynamic cursor will reflect the Original data
--************************dosn't work*************************************
DECLARE @EmpID INT,
        @EmpFName VARCHAR(50),
        @EmpLName VARCHAR(50),
		@BirthDate datetime

-- SQL Dynamic Cursor Declaration
DECLARE dynamic_employee_cursor CURSOR 
DYNAMIC FOR 
	SELECT EmployeeID, FirstName, LastName, BirthDate
	FROM Employees
OPEN dynamic_employee_cursor
--insert just for first row
IF @@CURSOR_ROWS >0
BEGIN 
      FETCH NEXT FROM dynamic_employee_cursor
            INTO @EmpID, @EmpFName, @EmpLName, @BirthDate
      WHILE @@FETCH_STATUS = 0
      BEGIN
		  Print 'Employees Details: '+cast(@EmpID as varchar)+', '+ @EmpFName+', '+ @EmpLName+', '+ cast(@BirthDate as varchar)
			insert into employees (FirstName, lastname)
			values ('mark', 'harrr')
	           
			FETCH NEXT FROM dynamic_employee_cursor 
				 INTO @EmpID, @EmpFName, @EmpLName, @BirthDate
      END
END
CLOSE dynamic_employee_cursor
DEALLOCATE dynamic_employee_cursor
SET NOCOUNT OFF 
GO

select *
from employees
where FirstName='mark'
--***********************************************************************

--5--

select tbl.name as 'Table', c.name as 'Column Name', t.name as 'Type'
from sys.columns as c
inner join sys.tables as tbl
on tbl.object_id = c.object_id
inner join sys.types as t
on c.system_type_id = t.system_type_id
where t.name in ('datetime', 'date')
order by tbl.name

use northwind
go

DECLARE @TableName VARCHAR(50),
        @ColName VARCHAR(50),
		@Type VARCHAR(50)
Declare Mycursor cursor
for select tbl.name as 'Table', c.name as 'Column Name', t.name as 'Type'
	from sys.columns as c
	inner join sys.tables as tbl
	on tbl.object_id = c.object_id
	inner join sys.types as t
	on c.system_type_id = t.system_type_id
	where t.name in ('datetime', 'date')
	order by tbl.name
open Mycursor
Fetch next from Mycursor INTO @TableName, @ColName, @Type

while @@FETCH_STATUS=0
begin 
Print 'Table Name: '+@TableName+', Column Name: '+ @ColName+', Data Type: '+ @Type
waitfor delay '00:00:02'
Fetch next from Mycursor INTO @TableName, @ColName, @Type

end 
close Mycursor
Deallocate Mycursor

go

--6--

alter procedure table_maker (@tableString varchar(1000))
as
begin
declare @id varchar(5), @idType varchar(10), @name varchar(10), 
@nameType varchar(15), @address varchar(20), @addressType varchar(30), @tableString2 varchar(1000)

set @id = left(@tableString, charindex(',', @tableString)-1)
set @tableString = stuff(@tableString,1, (len(@id)+1),'')
set @idType = left(@tableString, charindex(',', @tableString)-1)
set @tableString = stuff(@tableString,1, (len(@idType)+1),'')
set @name = left(@tableString, charindex(',', @tableString)-1)
set @tableString = stuff(@tableString,1, (len(@name)+1),'')
set @nameType = left(@tableString, charindex(',', @tableString)-1)
set @tableString2 = stuff(@tableString,1, (len(@nameType)+1),'')
set @address = left(@tableString2, charindex(',', @tableString2)-1)
set @tableString2 = stuff(@tableString2,1, (len(@address)+1),'')
set @addressType = @tableString2
set @tableString = ''
set @tableString2 = ''
set @tableString = '
CREATE TABLE [dbo].[NewTable2]
('+
	@id+' '+ @idType+', '+
	@name+' '+ @nameType+', '
set @tableString2 =''+
	@address+' '+ @addressType +
')'
set @tableString = @tableString+@tableString2
print @tableString
exec (@tableString)
end

exec table_maker 'id,int,name,varchar(50),address,varchar(100)'

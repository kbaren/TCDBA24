--------------- 11 DML ---------------

--- 2 ---
SET IDENTITY_INSERT  [dbo].[Employees]  ON  

delete
from Employees
where EmployeeID = 10

insert into Employees(EmployeeID
,LastName
,FirstName
,Title
,TitleOfCourtesy
,BirthDate
,HireDate
,Address
,City
,Region
,PostalCode
,Country
,HomePhone
,Extension
,Photo
,Notes
,ReportsTo
,PhotoPath)
values (13,	'Barenbaum',	'Karina',	'Sales Representative',	'Ms.',	'1989-08-25 00:00:00.000',	'2018-12-07 00:00:00.000',	'Haroe', 	'Ramat Gan',	NULL,	57293,	'Israel',	0000000,	050,	NULL,	NULL,	5,	NULL)


SET IDENTITY_INSERT  [dbo].[Employees]  OFF 


--- 3 ---
DECLARE
@CustomerName nvarchar(50) = 'Island Trading',
@RecDate datetime = '2018-12-31',
@productname nvarchar(100) = 'Chai',
@Quantity int = 100,
@Discount Float = 0

insert into Orders
values ((select [CustomerID] from Customers where CompanyName = @CustomerName), 
		13, 
		getdate(), 
		@RecDate, 
		NULL, 
		NULL, 
		NULL, 
		@CustomerName, 
		(select [Address] from Customers where CompanyName = @CustomerName), 
		(select [City] from Customers where CompanyName = @CustomerName),
		(select [Region] from Customers where CompanyName = @CustomerName), 
		(select [PostalCode] from Customers where CompanyName = @CustomerName), 
		(select [Country] from Customers where CompanyName = @CustomerName)
	   )

insert into [Order Details]
values ((select Max(orderID) from Orders where CustomerID = (select [CustomerID] from Customers where CompanyName = @CustomerName)),
		(select productID from Products where ProductName = @productname),
		(select UnitPrice from Products where ProductName = @productname),
		@Quantity,
		@Discount
	   )


--- 4 ---
GO
DECLARE
@CustomerName nvarchar(50) = 'Simons bistro',
@RecDate datetime = '2018-12-31',
@productname nvarchar(100) = 'Chai',
@Quantity int = 50,
@Discount Float = 0,
@productname2 nvarchar(100) = 'Tofu',
@Quantity2 int = 50,
@Discount2 Float = 0

insert into Orders
values ((select [CustomerID] from Customers where CompanyName = @CustomerName), 
		13, 
		getdate(), 
		@RecDate, 
		NULL, 
		NULL, 
		NULL, 
		@CustomerName, 
		(select [Address] from Customers where CompanyName = @CustomerName), 
		(select [City] from Customers where CompanyName = @CustomerName),
		(select [Region] from Customers where CompanyName = @CustomerName), 
		(select [PostalCode] from Customers where CompanyName = @CustomerName), 
		(select [Country] from Customers where CompanyName = @CustomerName)
	   )

insert into [Order Details]
values ((select Max(orderID) from Orders where CustomerID = (select [CustomerID] from Customers where CompanyName = @CustomerName)),
		(select productID from Products where ProductName = @productname),
		(select UnitPrice from Products where ProductName = @productname),
		@Quantity,
		@Discount
	   )

insert into [Order Details]
values ((select Max(orderID) from Orders where CustomerID = (select [CustomerID] from Customers where CompanyName = @CustomerName)),
		(select productID from Products where ProductName = @productname2),
		(select UnitPrice from Products where ProductName = @productname2),
		@Quantity2,
		@Discount2
	   )


--- 5 ---
insert into Customers
values ('ANGJO', 'Angelina Jolie', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL)

GO
DECLARE
@CustomerName nvarchar(50) = 'Angelina Jolie',
@RecDate datetime = '2019-01-31',
@productname nvarchar(100) = 'Chai',
@Quantity int = 10,
@Discount Float = 0,
@productname2 nvarchar(100) = 'Tofu',
@Quantity2 int = 5,
@Discount2 Float = 0

insert into Orders
values ((select [CustomerID] from Customers where CompanyName = @CustomerName), 
		13, 
		getdate(), 
		@RecDate, 
		NULL, 
		NULL, 
		NULL, 
		@CustomerName, 
		(select [Address] from Customers where CompanyName = @CustomerName), 
		(select [City] from Customers where CompanyName = @CustomerName),
		(select [Region] from Customers where CompanyName = @CustomerName), 
		(select [PostalCode] from Customers where CompanyName = @CustomerName), 
		(select [Country] from Customers where CompanyName = @CustomerName)
	   )

insert into [Order Details]
values ((select Max(orderID) from Orders where CustomerID = (select [CustomerID] from Customers where CompanyName = @CustomerName)),
		(select productID from Products where ProductName = @productname),
		(select UnitPrice from Products where ProductName = @productname),
		@Quantity,
		@Discount
	   )

insert into [Order Details]
values ((select Max(orderID) from Orders where CustomerID = (select [CustomerID] from Customers where CompanyName = @CustomerName)),
		(select productID from Products where ProductName = @productname2),
		(select UnitPrice from Products where ProductName = @productname2),
		@Quantity2,
		@Discount2
	   )


--- 6 ---
GO
CREATE procedure sp_DeleteCustomer
@CustomerName nvarchar(50)
AS
BEGIN
DECLARE
@CustomerID nvarchar(50)

select @CustomerID = CustomerID
from Customers
where CompanyName = @CustomerName

DELETE
from [Order Details]
where orderID in (select OrderID from Orders where CustomerID = @CustomerID)

DELETE
from Orders where CustomerID = @CustomerID

DELETE
from Customers
where CustomerID = @CustomerID

END

---------------------------------------
EXEC sp_DeleteCustomer 'Angelina Jolie'


--- 7 ---
update p
set p.UnitPrice = p.UnitPrice*1.1
from Products p join Suppliers s
on p.SupplierID = s.SupplierID
where s.CompanyName = 'Exotic Liquids'


--- 8 ---
update p
set p.UnitsInStock = 0, Discontinued = 1
from Products p join Suppliers s
on p.SupplierID = s.SupplierID
where s.CompanyName = 'Exotic Liquids'


--- 10 ---
sp_help employees


--------------- DDL-DML ---------------

--- 1 ---
create table employees_k
( ID int identity(1,1) not null,
  Name nvarchar(200) Not null,
  Title nvarchar(100) null, 
  DeptID int not null,
  Salary int null
)


--- 2 ---
insert into employees_k
values
('Aviv Cohen', 'Clerk', 10, 4000)


--- 3 ---
insert into employees_k (Name
,Title
,DeptID
,Salary)
values
('Miriam Levi', 'Sales manager', 20, 3750)


--- 4 ---
insert into employees_k
values
('Alon Romni', 'Operation Manager', 30, NULL)


--- 5 ---
insert into employees_k (name,
DeptID)
values
('Baruch Nave', 30)
/* salary is NULL too */


--- 6 --- 
INSERT employees_k
    OUTPUT INSERTED.* 
VALUES ('Danny Salomon', 'Sales representative', 10, 7000);  


--- 7 ---
update employees_k
set Salary = 4500
output inserted.*, deleted.Salary AS Salary_Old
where id = 2


--- 8 ---
update employees_k
set Name = 'Ariel', DeptID = 20
output inserted.Name AS New_name, deleted.Name AS old_name,
	   inserted.DeptID AS new_DeptID, deleted.DeptID AS old_DeptID
where id = 4


--- 9 ---
update employees_k
set DeptID = 10
where DeptID = 30


--- 10 ---
create table Myemployees
( ID int identity(1,1) not null,
  Name nvarchar(200) Not null,
  Title nvarchar(100) null, 
  DeptID int null,
  Salary int null default 3750
)
insert into Myemployees (Name
,Title
,DeptID
)
output inserted.*
select Name
,Title
,NULL
from employees_k
where ID >5


--- 12 ---
CREATE TABLE dbo.CustomersTotals
(CustomerID nvarchar(10) NOT NULL,
 LastOrderDate DATETIME NULL,
 TotalSpent DECIMAL(8,2) NULL,
 AvgSpent DECIMAL(8,2) NULL
)


--- 13 ---
--a
insert into CustomersTotals
select CustomerID, max(OrderDate), sum(UnitPrice * Quantity *(1- discount)), AVG(UnitPrice * Quantity *(1- discount))
from Orders O join [Order Details] OD
on o.OrderID = od.OrderID
group by CustomerID

--c
with cte 
as 
(select CustomerID, max(OrderDate) as LastOrderDate, sum(UnitPrice * Quantity *(1- discount)) as TotalSpent, AVG(UnitPrice * Quantity *(1- discount)) as AvgSpent
from Orders O join [Order Details] OD
on o.OrderID = od.OrderID
group by CustomerID
)
update ct
set ct.LastOrderDate = cte.LastOrderDate, ct.TotalSpent = cte.TotalSpent, ct.AvgSpent = cte.AvgSpent
from CustomersTotals ct join cte
on ct.customerID = cte.customerID

--d
select *
into CustomersTotals_backup
from CustomersTotals

--e
ALTER TABLE [Order Details]
drop CONSTRAINT [FK_Order_Details_Orders]


ALTER TABLE [Order Details]
ADD CONSTRAINT [FK_Order_Details_Orders]
FOREIGN KEY (orderID)
REFERENCES Orders (OrderID)
ON DELETE CASCADE

delete 
from Orders 
where CustomerID in (  'ALFKI'
,'ANTON'
,'BERGS')

--f
delete  ct
from Customers c left join Orders o
on c.CustomerID = o.CustomerID
left join CustomersTotals ct
on c.CustomerID = ct.CustomerID
where OrderID is NULL

delete  c
from Customers c left join Orders o
on c.CustomerID = o.CustomerID
left join CustomersTotals ct
on c.CustomerID = ct.CustomerID
where OrderID is NULL
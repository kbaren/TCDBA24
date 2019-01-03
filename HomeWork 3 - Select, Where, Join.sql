------------------------------------------PART 1. SELECT -----------------------------------------------------
USE Northwind
--1. D---
SELECT EmployeeID
FROM Employees
ORDER BY EmployeeID
OFFSET 5 ROWS
FETCH NEXT 2 ROWS ONLY

--2.	איזו שאילתה תחזיר עמודה אחת, ובה עיר הלקוח (City) , המדינה (Country) וכתובת (Address)?
 
/*B.*/   SELECT City +' '+ Country+' '+ Address from employees 

--3.	כתבו שאילתה  להצגת שם פרטי , שם משפחה , ועיר העובדים , ממוין לפי שם פרטי בסדר יורד.
SELECT FirstName, LastName, City
FROM Employees
ORDER BY 1 DESC

--4.	הציגו את פרטי העובד הכי מבוגר בחברה 
SELECT TOP 1 *
FROM Employees
ORDER BY BirthDate 

--5.	הציגו מטבלת Employees את שם המשפחה הקטן ביותר מבחינה אלפאבתית.
SELECT TOP 1 *
FROM Employees
ORDER BY LastName

--6.	הציגו את פרטי העובד הכי צעיר בחברה.
SELECT TOP 1 *
FROM Employees
ORDER BY BirthDate DESC

--7.	הציגו את כל ההזמנות מטבלת ההזמנות
SELECT *
FROM Orders

--8.	הציגו את 5 ההזמנות הראשונות בחברה
	SELECT TOP 5 *
FROM Orders
ORDER BY OrderID

--9.	הציגו את 5 ההזמנות השניות בחברה
SELECT *
FROM Orders
ORDER BY OrderID
offset 5 rows
fetch next 5 rows only

--10.	הציגו את הערים בהם גרים הלקוחות בצורה חד ערכית.
SELECT distinct City
FROM Customers

--11.	הציגו את 20 ההזמנות שאחרי ה- 10 ההזמנות הראשונות. 
SELECT *
FROM Orders
ORDER BY OrderID
offset 10 rows
fetch next 20 rows only



----------------------------------------PART 2. WHERE ------------------------------------------------------------------

use northwind
----1----
select top 1 *
from [dbo].[Orders]
where DATEPART(YY, OrderDate) = 1996
order by OrderDate 

----2----
select [CompanyName]
from Customers
where Country in ('UK','USA','France')

----3----
select productID, ProductName
from Products
where UnitsInStock<30

----4----
select *
from sys.databases
where name like 'M%T'

----5----
select *
from sys.tables
where (is_memory_optimized = 1 or temporal_type_desc = 'SYSTEM_VERSIONED_TEMPORAL_TABLE')
	or (has_replication_filter = 1 and is_replicated = 1)
	or is_merge_published <>1

----6----
select empID, Fname+' '+Lname+' ,'+'works as ' +' a ' + Jobtitle from My_employees

-----------------------------------------------------------------------------------------------------------------------

----4----
select productID, ProductName, CategoryID
from Products
where CategoryID not in (1,2,7)
order by 3

----5----
select EmployeeID, LastName+' '+FirstName AS 'FullName', BirthDate
from Employees
where city like '%London%'

----6----
select EmployeeID, LastName, HireDate
from Employees
where city in ('London', 'Tacoma')

----7----
select OrderID, OrderDate, RequiredDate
from Orders
where  DATEPART(MM,RequiredDate) >= 10
and DATEPART(MM,RequiredDate)>=1996 

----8----
select EmployeeID, LastName, ReportsTo
from Employees
where ReportsTo is not NULL
order by 1

----9----
select *
from Categories 
where CategoryName like '%o%'

----10----
select CompanyName, Country
from Customers  
where CompanyName like '%a'

----11----
select ProductName, CategoryID
from Products   
where ProductName like '%a_'

----12----
select OrderID, CustomerID, EmployeeID
from Orders     
where OrderDate between '1997-04-01' and '1997-05-31'
order by OrderDate asc, CustomerID desc

--Another possible query--
select OrderID, CustomerID, EmployeeID
from Orders     
where DATEPART(MM,OrderDate) in (4,5) and DATEPART(YY,OrderDate) = 1997
order by OrderDate asc, CustomerID desc

----13----
select CustomerID, CompanyName, Country, Phone, Region
from Customers       
where Country like '[g,f,m]%' and Region is null

----14----
select OrderID, EmployeeID, OrderDate, RequiredDate, ShippedDate
from Orders        
where EmployeeID = 7 
and ShipName in ('QUICK-Stop', 'DU mond entire', 'Eastern Connection')
and DATEDIFF(DD, OrderDate, RequiredDate)>20 or DATEDIFF(DD, OrderDate, RequiredDate)<10

----15----
select *
from Employees
where HomePhone not like '%1%'

----16----
select FirstName+ ' '+ LastName+' '+ City
from Students 

----17----
select FirstName, datename(MONTH, BirthDate) , DATEPART(YY, BirthDate)
from Employees 

----19----
select substring(firstname,1,3) + substring(lastname,3, len(lastname) )+ Left(CityID,2)+'@gmail.com'
from Students        


----------------------------------------PART 3. JOIN ------------------------------------------------------------------

----3----
select ProductName, UnitPrice, CategoryName
from Products p join Categories c on p.CategoryID = c.CategoryID
where UnitPrice<50

----4----
select ProductID, UnitPrice, SupplierID, CategoryName
from Products p join Categories c on p.CategoryID = c.CategoryID  
where SupplierID = 3

----5----
select CompanyName, OrderID
from Customers c left join Orders o on c.CustomerID = o.CustomerID

----6----
select OrderID, OrderDate, ShipAddress, c.CustomerID, CompanyName, Phone
from Customers c left join Orders o on c.CustomerID = o.CustomerID
where DATEPART(YY, OrderDate) = 1996

----7----
select P2.ProductID, p2.ProductName, p2.UnitPrice
from Products P1 join Products P2 
on P1.ProductName = 'Alice Mutton' and  P2.UnitPrice< P1.UnitPrice

----8----
select c.CompanyName
from Customers c join Employees e on c.City = e.City
where e.FirstName in ('Michael', 'Nancy')

----9----
select *
from Customers c join Orders o 
on c.CustomerID=o.CustomerID and datepart(YY, o.OrderDate) <>1998

----10----
select e.EmployeeID
from Employees e join Orders o on e.EmployeeID=o.EmployeeID
where (DATEPART( YY, OrderDate) <> 1998 and DATEPART( YY, OrderDate) <> 8)
or (DATEPART( YY, OrderDate) <> 1996 and DATEPART( YY, OrderDate) <> 6)
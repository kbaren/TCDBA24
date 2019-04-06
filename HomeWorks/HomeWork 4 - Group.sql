
------ 1 ------
select count(*),c.CategoryName
from Categories c join Products p
on c.CategoryID = p.CategoryID
group by CategoryName
having count(*)>5

------ 2 ------
------------- MAX -------------
select max(orderdate)
from  Orders 
where CustomerID = 'VICTE'

------------- LAST_VALUE -------------
select distinct LAST_VALUE(orderdate) over (partition by customerID order by orderdate RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)
from Orders
where CustomerID = 'VICTE'


------ 3 ------
select min(lastname)
from Employees


------ 4 ------
select count(*)
from Customers


------ 5 ------
select count(distinct customerID)
from Orders


------ 6 ------
select 
(select count(*)
from Employees) NumOfEmp,

(select count(*)
from Products) NumOfProducts,

(select count(*)
from Employees
where City = 'London') NumEmpinLon,

(select count(*)
from Employees
where City = 'Seattle') NumEmpinSea,

(select count(*)
from Products
where ProductID%2=0) NumOfEvenPID,

(select count(*)
from Products
where ProductID%2=1) NumofunEvenPID,

(select max(count)
from (select count(*) count
from Orders
group by EmployeeID) t1) MaxNumofOrders


------ 7 ------
/*D*/ group by productID
--there are columns in select that weren't included in group function or group clause


------ 8 ------
select avg(unitprice)
from products
group by SupplierID
having avg(unitprice)>40


------ 9 ------
select max(unitprice)
from Products
group by SupplierID
order by SupplierID desc

------ 10 ------
select *
from Employees
where FirstName not like '%[a,b]%'
and Region is not Null
and ReportsTo is not null


------ 11 ------
select distinct *
from
(select region, City, count(*) over(partition by region) NumOfCustomers
from Customers
where city like '%[m,n]%'
and Region is not null) t1
where NumOfCustomers>=2


------ 12 ------
select min(lastname), max(firstname)
from Employees


------ 13 ------
select max(unitprice), min(unitprice), avg(unitprice), CategoryID, SupplierID
from Products
group by CategoryID, SupplierID


------ 14 ------
select max(unitprice), CategoryID
from Products
where unitprice>40
group by CategoryID


------ 15 ------
select avg(unitprice), CompanyName
from products p join Suppliers s
on p.supplierid = s.supplierid
group by CompanyName
having avg(unitprice)>20


------ 16 ------
select distinct Year(orderdate)
from Orders


------ 17 ------
select distinct CompanyName
from Orders o join Customers c on o.CustomerID = c.CustomerID
join [Order Details] od on o.OrderID = od.OrderID 
where year(OrderDate) = 1996
and ProductID in (	select ProductID
					from Orders o join Customers c on o.CustomerID = c.CustomerID
					join [Order Details] od on o.OrderID = od.OrderID
					where CompanyName = 'Alfreds Futterkiste'
					and year(OrderDate) in (1997,1998))


------ 18 ------
select CONVERT(nvarchar, max(BirthDate), 113), CONVERT(nvarchar, min(BirthDate), 113)
from Employees


------ 19 ------
select p2.ProductName
from Products P1 join Products P2 
on P1.ProductID = 8 and  P2.UnitPrice< P1.UnitPrice


------ 20 ------
select p2.ProductName, p2.UnitPrice
from Products P1 join Products P2 
on P1.ProductName = 'Tofu' and  P2.UnitPrice> P1.UnitPrice


------ 21 ------
select ProductID, ProductName, UnitPrice
from Products p1, (select AVG(unitprice) AVG from Products) p2
where p1.UnitPrice> p2.AVG


------ 22 ------
select *
from Products
where CategoryID in (
select CategoryID
from Products
where ProductName ='Tofu')
and ProductName <>'Tofu'


------ 23 ------
select ProductName, UnitPrice
from Products
where UnitPrice> (select max(unitprice)
					from Products
					where CategoryID=5)


------ 24 ------
select ProductName, UnitPrice
from Products
where UnitPrice> (select min(unitprice)
					from Products
					where CategoryID=5)


------ 25 ------
select OrderID, OrderDate
from Orders o join Customers c on o.CustomerID=c.CustomerID
where Country in ('Germany', 'Sweden','France')
and YEAR(OrderDate)= 1997


------ 26 ------
select *
from Products p join Categories c on p.CategoryID = c.CategoryID
join Suppliers s on p.SupplierID = s.SupplierID
where CategoryName in ('Beverages', 'Condiments')
and Region is null


------ 27 ------
select productname, productID
from Products
where unitprice>(	select avg(unitprice)
					from Products
					where UnitsInStock>50)
--------------- Part 5---------------
---1---
select City, Country, grouping_id(City ,Country) ID
from Customers
group by  cube(City,Country)
having grouping_id(City ,Country) = 1
order by ID

---2---
select CompanyName, ROW_NUMBER() OVER (partition by city order by city)
from Customers

---3---
with EMP AS
(
select ROW_NUMBER() over(order by hiredate) ROW# , *
from Employees
)
select top 5 *
from EMP
where ROW#>3

---4a---
with prod AS
(
select ROW_NUMBER() over(order by unitprice desc) ROW# , *
from Products
)
select *
from prod
where ROW# = 18

---4b---
select *
from products
order by UnitPrice desc
offset 17 rows
fetch next 1 rows only

---5a---
select *
from Customers
where CustomerID in (select CustomerID
						from Orders
						group by CustomerID
						having count(*)>=14)

---5b---
with ord AS
(
select ROW_NUMBER() over(partition by customerid order by orderId desc) ROW# , *
from orders 
)
select distinct c.*
from ord o join Customers c
on o.CustomerID = c. CustomerID 
where ROW#>= 14

---6a---
---6b---

---7---
select *
from Orders
where year(OrderDate) = 1997
order by OrderDate
offset 10 rows
fetch next 10 rows only

-----or------
go
with ord AS
(
select ROW_NUMBER() over(order by orderdate) ROW# , *
from Orders
where year(OrderDate) = 1997
)
select top 10 *
from ord
where ROW# > 10

---8---
with cat as(
select ROW_NUMBER() over(order by CategoryName) ROW# , *
from Categories)
select p.*
from Products p join cat c
on p.CategoryID = c.CategoryID
where ROW# = 2

---9---
with ord as(
select ROW_NUMBER() over(partition by month(OrderDate) order by month(OrderDate) ) ROW# , *
from Orders
where year(OrderDate) = 1996
)
select *
from ord
where ROW# = 1


---10?-----------------------------
with ord as(
select ROW_NUMBER() over(partition by month(OrderDate) order by month(OrderDate) ) ROW# , *
from Orders
where year(OrderDate) = 1996
)
select *
from ord
where ROW# in (select max (row#)
				from ord
				group by month(orderdate))


---11a---
create TABLE #table
(myday datetime,
totalcustomers int)

declare @rows int = 1
while @rows <=10000
begin
insert into #table
values
((SELECT DATEADD(day, (ABS(CHECKSUM(NEWID())) % 1090), '2008-01-01')) , (SELECT ABS(CHECKSUM(NEWID()) % 6000)))
SET @rows= @rows+1
PRINT (@rows)
END


---11b---

---12?-------------------------------
with cte as(
select count(*) numoforders, CustomerID
from orders
group by CustomerID
having count(*)>14
)
select RANK() over (order by numoforders desc), OrderID, cte.CustomerID, c.ContactName, cte.numoforders
from cte join Orders o
on cte.CustomerID = o.CustomerID
join  Customers c
on cte.CustomerID = c.CustomerID
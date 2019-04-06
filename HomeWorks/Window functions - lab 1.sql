---------------------------------------------------------------------
--
-- Exercise 1
---------------------------------------------------------------------

USE TSQL2012;
GO

---------------------------------------------------------------------
-- Task 1
-- 
-- Write a SELECT statement to retrieve
-- the orderid, orderdate, and val columns
-- AND A calculated column named rowno from the view Sales.OrderValues.
-- Use the ROW_NUMBER() function to return rowno.
-- Order the row numbers by the orderdate column.
--
---------------------------------------------------------------------

select orderid, orderdate , val , ROW_NUMBER() over (order by orderdate) AS rowno
from Sales.OrderValues

---------------------------------------------------------------------
-- Task 2
-- 
-- Copy the previous T-SQL statement and modify it by
-- including an additional column named rankno.
-- To create rankno, use the RANK function,
-- with the rank order based on the orderdate column.
--
-- Notice the different values in the rowno and rankno columns for some of the rows.
--
-- What is the difference between the RANK and ROW_NUMBER functions?
---------------------------------------------------------------------

 select orderid, orderdate , val , ROW_NUMBER() over (order by orderdate) AS rowno, RANK() over (order by orderdate) AS rankno
 from Sales.OrderValues

 --- check---

with cte
AS
(
 select orderid, orderdate , val , ROW_NUMBER() over (order by orderdate) AS rowno, RANK() over (order by orderdate) AS rankno
 from Sales.OrderValues
)

select *
from cte
where rowno<>rankno

/* ROW_NUMBER and RANK are similar. ROW_NUMBER numbers all rows sequentially (for example 1, 2, 3, 4, 5). 
   RANK provides the same numeric value for ties (for example 1, 2, 2, 4, 5) */

---------------------------------------------------------------------
-- Task 3
-- 
-- Write a SELECT statement to retrieve the
-- orderid, orderdate,custid, and val 
-- columns as well as a calculated column named
-- orderrankno
-- FROM the Sales.OrderValues view. 
-- orderrankno:  
-- Rank PER each customer independently,
-- based on val ordering in descending order. 
--
---------------------------------------------------------------------

select orderid, orderdate,custid, val, 
rank() over(partition by custid order by val desc) AS orderrankno
from Sales.OrderValues

---------------------------------------------------------------------
-- Task 4
-- 
-- Write a SELECT statement to retrieve the custid and val
-- from the Sales.OrderValues view. Add two calculated columns: 
-- 1) orderyear as a year of the orderdate column 
--
-- 2) orderrankno as a rank number:
-- partitioned by the customer and order year,
-- and ordered by the order value in descending order. 
--
---------------------------------------------------------------------

select custid, val, YEAR(orderdate) AS orderyear,
RANK() over (partition by custid, YEAR(orderdate) order by val desc) orderrankno
from Sales.OrderValues

---------------------------------------------------------------------
-- Task 5
-- 
-- Copy the previous query and modify it to filter only orders
-- with the first two ranks based on the orderrankno column.
--
---------------------------------------------------------------------

with cte
AS
(
select custid, val, YEAR(orderdate) AS orderyear, 
RANK() over (partition by custid, YEAR(orderdate) order by val desc) orderrankno
from Sales.OrderValues
)

select top 2 with ties custid, val, orderyear, orderrankno
from cte
order by orderrankno
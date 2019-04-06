use TSQL2012
-- Task 1
-- 
-- Write a SELECT statement to retrieve
-- the orderid, orderdate, and val columns
-- AND A calculated column named rowno from the view Sales.OrderValues.
-- Use the ROW_NUMBER() function to return rowno.
-- Order the row numbers by the orderdate column.


select orderid, orderdate, val, ROW_NUMBER() OVER(ORDER BY orderdate) as rowno
from sales.ordervalues

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

select orderid, orderdate, val, ROW_NUMBER() OVER(ORDER BY orderdate) as rowno,
RANK() OVER(ORDER BY orderdate) as rankno
from sales.ordervalues

--the rank() stays the same for all rows where the date is the same. the rownum changes when the next row is different




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
select orderid, orderdate, val, 
RANK() OVER(PARTITION BY custid ORDER BY val desc) as orderrankno
from sales.ordervalues



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
select custid, val, year(orderdate) as orderyear, 
RANK() OVER(PARTITION BY custid, year(orderdate) ORDER BY val) as orderrankno
from sales.ordervalues
---------------------------------------------------------------------
-- Task 5
-- 
-- Copy the previous query and modify it to filter only orders
-- with the first two ranks based on the orderrankno column.

select top 2 t1.orderrankno, t1.orderyear, val
from (
		select val, year(orderdate) as orderyear, 
		RANK() OVER(PARTITION BY custid, year(orderdate) ORDER BY val) as [orderrankno]
		from sales.ordervalues
	 )as t1

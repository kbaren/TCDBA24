---------------------------------------------------------------------

-- Exercise 2
---------------------------------------------------------------------

USE TSQL2012;
GO

---------------------------------------------------------------------
-- Task 1
-- 
--
-- Define a CTE named OrderRows based on a query that
-- retrieves the orderid, orderdate, and val from Sales.OrderValues

-- Add a calculated column named rowno using the ROW_NUMBER function,
-- ordering by the orderdate and orderid columns. 
--
-- Write a SELECT statement against the CTE and use the LEFT JOIN
-- with the same CTE to retrieve the current row and the previous row
-- based on the rowno column. Return the orderid, orderdate,  val 
-- for the current row and the val column from the previous row as prevval.
-- Add a calculated column named diffprev
-- to show the difference between the current val and previous val.
--
---------------------------------------------------------------------

with cte_OrderRows
AS
( select orderid, orderdate, val, ROW_NUMBER() over(order by orderdate, orderid) AS rowno
  from Sales.OrderValues
)
select cte1.orderid, cte1.orderdate, cte1.val AS val, cte2.val AS prevval, (cte1.val - cte2.val) AS diffprev
from cte_OrderRows cte1 left join cte_OrderRows cte2
on cte1.rowno = cte2.rowno + 1
   
---------------------------------------------------------------------
-- Task 2
-- SELECT orderid, orderdate,val,Rowno, prevyear, diff 
-- Write a SELECT statement that uses the LAG function
-- to achieve the same results as the query in the previous task.
-- The query should not define a CTE.
--
---------------------------------------------------------------------

select orderid, orderdate,val,
lag(val,1) over(order by orderdate, orderid) AS  prevval,
(val - lag(val,1) over(order by orderdate, orderid)) AS diff 
from Sales.OrderValues

---------------------------------------------------------------------
-- Task 3
-- Prep:
-- Define a CTE named SalesMonth2007 that creates two columns:
-- monthno (the month number of the orderdate column) and val
-- (aggregated val column group by monthno.)
-- Filter the results to include only the order year 2007
-- FROM Sales.OrderValues;

with cte_SalesMonth2007
AS
( select MONTH(orderdate) AS monthno, SUM(val) AS val
from Sales.OrderValues
where YEAR(orderdate) = 2007
group by MONTH(orderdate)
)
select *
from cte_SalesMonth2007

--Advanced:
-----------
-- Write a SELECT statement that retrieves the monthno and val
-- from the CTE and adds three calculated columns:
--  avglast3months: average sales amount for last three months before the current month.
-- (Use multiple LAG functions and divide the sum by three.)
-- You can assume that there’s a row for each month in the CTE.

--  diffjanuary. This column should contain the difference between
--  the current val and the January val. (Use the FIRST_VALUE function.)
 
-- nextval. This column should contain the next month value
-- of the val column.
--
--Notice that the average amount for last three months is not correctly 
--computed because the total amount for the first two months is divided by three.
-- You will practice how to do this correctly in the next exercise.
---------------------------------------------------------------------

with cte_SalesMonth2007
AS
( select MONTH(orderdate) AS monthno, SUM(val) AS val
from Sales.OrderValues
where YEAR(orderdate) = 2007
group by MONTH(orderdate)
)
select monthno, val,
(lag(val,2) over( order by monthno)+lag(val,1) over( order by monthno) + val)/3 AS avglast3months,
(val - FIRST_VALUE(val) over( order by monthno)) AS diffjanuary,
(lead(val) over (order by monthno)) AS nextval
from cte_SalesMonth2007





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
;with OrderRows
as
(select orderid, custid, orderdate, val, ROW_NUMBER() OVER(ORDER BY orderdate, orderid) as rowno
 from Sales.OrderValues
)
select this.val as val, previous.val as prevval, abs(this.val-previous.val) as diffprev
from OrderRows this LEFT JOIN OrderRows previous
ON (previous.rowno+1 = this.rowno) --the left join gets all data from this and moves to -1 the previous by changing the rownum for this to +1

---------------------------------------------------------------------
-- Task 2
-- SELECT orderid, orderdate,val,Rowno, prevyear, diff 
-- Write a SELECT statement that uses the LAG function
-- to achieve the same results as the query in the previous task.
-- The query should not define a CTE.
--
---------------------------------------------------------------------
select orderid, custid , orderdate, val as currentVal, 
	lag(val,1,0)over(order by orderdate,orderid) as prevousVal,
	ABS(lag(val,1,0)over(order by orderdate,orderid)- val) as diffprev
from Sales.OrderValues 



---------------------------------------------------------------------
-- Task 3
-- Prep:
-- Define a CTE named SalesMonth2007 that creates two columns:
-- monthno (the month number of the orderdate column) and val
-- (aggregated val column group by monthno.)
-- Filter the results to include only the order year 2007
-- FROM Sales.OrderValues;

;with SalesMonth2007
as
(select month(orderdate) as monthno, sum(val) as val
 from Sales.OrderValues
 where year(orderdate)=2007
 group by month(orderdate) 
)

select *
from SalesMonth2007 



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

;with SalesMonth2007
as
(select month(orderdate) as monthno, sum(val) as val
 from Sales.OrderValues
 where year(orderdate)=2007
 group by month(orderdate) 
)

select monthno, val, (lag(val,3) over(order by monthno) + 
                     lag(val,2) over(order by monthno)+ 
					 lag(val,1) over( order by monthno))/3 as avgLast3months,
					 abs(FIRST_VALUE(val) over (order by monthno) - 
					 val)as diffjanuary,
					 lead(val) over (order by monthno) as nextval
from SalesMonth2007 
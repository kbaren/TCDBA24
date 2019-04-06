use Northwind
----3----
select productID, ProductName, CategoryID
from Products
where CategoryID not in (1,2,7)
order by 3

----4----
select EmployeeID, LastName+' '+FirstName AS 'FullName', BirthDate
from Employees
where city like '%London%'

----5----
select EmployeeID, LastName, HireDate
from Employees
where city in ('London', 'Tacoma')

----6----
select OrderID, OrderDate, RequiredDate
from Orders
where  DATEPART(MM,RequiredDate) = 10

----7----
select EmployeeID, LastName, ReportsTo
from Employees
where ReportsTo is not NULL
order by 1 

----8----
select *
from Categories 
where CategoryName like '%o%'

----9----
select CompanyName, Country
from Customers  
where CompanyName like '%a'

----10----
select ProductName, CategoryID
from Products   
where CategoryName like '%a_'

----11----
select OrderID, CustomerID, EmployeeID
from Orders     
where OrderDate between '1997-04-01' and '1997-05-31'
order by OrderDate asc, CustomerID desc

select OrderID, CustomerID, EmployeeID
from Orders     
where DATEPART(MM,OrderDate) in (4,5) and DATEPART(YY,OrderDate) = 1997
order by OrderDate asc, CustomerID desc

----12----
select CustomerID, CompanyName, Country, Phone, Region
from Customers       
where Country like '[g,f,m]%' and Region is null

----13----
select OrderID, EmployeeID, OrderDate, RequiredDate, ShippedDate
from Orders        
where EmployeeID = 7 
and ShipName in ('QUICK-Stop', 'DU mond entire', 'Eastern Connection')
and DATEDIFF(DD, OrderDate, RequiredDate)>20

----14----
select substring(firstname,1,3) + substring(lastname,3, len(lastname) )+ Left(CityID,2)+'@gmail.com'
from Students        

----15----
select case when 'STRING' like '%[_,%]%' then 1 else 0 end


----16----
DROP TABLE #temp

go

select case when substring(cast(12345670 as nvarchar(15)),1, 1) * 1 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),1, 1) * 1,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),1, 1) * 1 ,1) as int) else substring(cast(12345678 as nvarchar(15)),1, 1) * 1 end
	    +																		 														
	   case when substring(cast(12345678 as nvarchar(15)),2, 1) * 2 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),2, 1) * 2,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),2, 1) * 2 ,1) as int) else substring(cast(12345678 as nvarchar(15)),2, 1) * 2 end
	    +														    			 														
       case when substring(cast(12345678 as nvarchar(15)),3, 1) * 1 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),3, 1) * 1,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),3, 1) * 1 ,1) as int) else substring(cast(12345678 as nvarchar(15)),3, 1) * 1 end
	    +														    
	   case when substring(cast(12345678 as nvarchar(15)),4, 1) * 2 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),4, 1) * 2,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),4, 1) * 2 ,1) as int) else substring(cast(12345678 as nvarchar(15)),4, 1) * 2 end
	    +														    
	   case when substring(cast(12345678 as nvarchar(15)),5, 1) * 1 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),5, 1) * 1,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),5, 1) * 1 ,1) as int) else substring(cast(12345678 as nvarchar(15)),5, 1) * 1 end
	    +														   																	    
	   case when substring(cast(12345678 as nvarchar(15)),6, 1) * 2 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),6, 1) * 2,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),6, 1) * 2 ,1) as int) else substring(cast(12345678 as nvarchar(15)),6, 1) * 2 end
	    +														    															
       case when substring(cast(12345678 as nvarchar(15)),7, 1) * 1 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),7, 1) * 1,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),7, 1) * 1 ,1) as int) else substring(cast(12345678 as nvarchar(15)),7, 1) * 1 end
	    +														    																 
	   case when substring(cast(12345678 as nvarchar(15)),8, 1) * 2 >9 then cast(Left(substring(cast(12345678 as nvarchar(15)),8, 1) * 2,1)  as int)+ Cast(RIGHT (substring(cast(12345678 as nvarchar(15)),8, 1) * 2 ,1) as int) else substring(cast(12345678 as nvarchar(15)),8, 1) * 2 end
	    AS SUM
into #temp

go

select ROUND(SUM,-1) - SUM
from #temp





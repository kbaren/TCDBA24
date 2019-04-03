--- 1 ---
drop table if exists #Cost_Sorted_By_Production_Days

select DaysToManufacture, avg(StandardCost) AS AverageCost
into #Cost_Sorted_By_Production_Days
from production.product
group by DaysToManufacture

declare @days varchar(200) = ''
select @days = @days + CONCAT(',[', DaysToManufacture, '] ')
from #Cost_Sorted_By_Production_Days

set @days = (select stuff( @days ,1,1, '') )

DECLARE @SQL nvarchar(400) = ''
set @SQL = 'SELECT ''AverageCost'' AS Cost_Sorted_By_Production_Days,*
from #Cost_Sorted_By_Production_Days
PIVOT
(
AVG(AverageCost) FOR DaysToManufacture IN ( ' + @days + ')
) AS PivotTable;'

exec (@SQL)

--- 2 ---
DROP TABLE IF EXISTS #TempEmployee

select BusinessEntityID, YEAR(BirthDate) AS YearOfBirth, Gender
into #TempEmployee
from HumanResources.Employee
where YEAR(BirthDate) between 1980 and 1990

Drop table if exists #years

select distinct YearOfBirth
Into #years
from #TempEmployee
order by 1

declare @Years varchar(200) = ''
select @Years = @Years + CONCAT(',[', YearOfBirth, '] ')
from #years

print @Years

set @Years = (select stuff( @Years ,1,1, '') )

print @Years 

declare @command varchar(300)
set @command = 
'select *
	from  #TempEmployee 
 pivot 
 (count(BusinessEntityID) for YearOfBirth in (' + @Years +') ) tablePivot'
print (@command)
exec (@command)
 
--- 3 ---
GO
DROP TABLE IF EXISTS #Temp
declare @departments varchar(500) = ''
declare @SQL nvarchar(1000) = '';

SELECT hd.Name as "Dept_name",COUNT(HE.BusinessEntityID) as "Number" ,HE.Gender 
INTO #Temp
FROM HumanResources.EmployeeDepartmentHistory edh
INNER JOIN HumanResources.EMPLOYEE he  ON EDH.BusinessEntityID=HE.BusinessEntityID inner join [HumanResources].[Department] hd 
on edh.DepartmentID=hd.DepartmentID
WHERE edh.EndDate IS NULL 
GROUP BY hd.Name,Gender

select @departments = @departments + CONCAT(',[', Name, '] ')
from HumanResources.Department

set @departments = (select stuff( @departments ,1,1, '') )
print @departments

Set @SQL= 
'select * from #temp

 pivot (sum (number) for Dept_name in (' + @departments + ')) as pvt'

exec (@SQL)

--- 4 ---
DROP TABLE IF EXISTS #Temp
declare @departments varchar(500) = ''
declare @SQL nvarchar(1000) = '';

SELECT hd.Name as "Dept_name",COUNT(HE.BusinessEntityID) as "Number" ,HE.Gender 
INTO #Temp
FROM HumanResources.EmployeeDepartmentHistory edh
INNER JOIN HumanResources.EMPLOYEE he  ON EDH.BusinessEntityID=HE.BusinessEntityID inner join [HumanResources].[Department] hd 
on edh.DepartmentID=hd.DepartmentID
WHERE edh.EndDate IS NULL 
GROUP BY hd.Name,Gender

select @departments = @departments + CONCAT(',[', Name, '] ')
from HumanResources.Department

set @departments = (select stuff( @departments ,1,1, '') )
print @departments

Set @SQL= 
'select * from #temp

 pivot (sum (number) for Dept_name in (' + @departments + ')) as pvt'

exec (@SQL)
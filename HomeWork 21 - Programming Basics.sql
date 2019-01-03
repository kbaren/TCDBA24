--------------- 21 Programming Basics ---------------
---1---
go 
alter procedure SP_Random
@num1 int, @num2 int

as begin
select round(rand()*ABS((@num2 - @num1)) +@num1,0)

end

----check
exec SP_Random 10, 25


---2---
go
CREATE procedure SP_GetNumeric
@string nvarchar(200)
AS
BEGIN
DECLARE @pos INT
SET @pos = PATINDEX('%[^0-9]%', @string)
WHILE @pos > 0
	BEGIN
	SET @string = STUFF(@string, @pos, 1, '' )
	SET @pos = PATINDEX('%[^0-9]%', @string )
	END
SELECT @string
END

----check
exec SP_GetNumeric '12B1546alance1000sheet'


---3---
go
Create procedure SP_atzeret
@Num int
as
begin
declare @i int = 1,
@atzeret int = 1

while @i<=@num
	begin
	set @atzeret =@atzeret*@i
	set @i = @i+1
	End
return @atzeret
End

----check
declare @atzeret
exec @atzeret = SP_atzeret 3
select @atzeret


---4---
alter procedure sp_print
@Num int
AS
BEGIN
declare @i int = 0
,@j int = 0
,@str nvarchar(MAX) = ''
while @i<@Num
 BEGIN
	while @j< @Num
	   BEGIN
	    set @str = concat(@str,'*')
		set @j= @j+1
	   END
	print @str
	set @i = @i+1
 END
END
     
----check
exec  sp_print 29


--- 5 ---
GO
create function udf_datepart
(@DateOfBirth date, @part varchar(20))
returns int
AS
BEGIN 
declare @dateprt int = 0
select 	@dateprt =   case when @part = 'Year' then DATEDIFF(YY, @DateOfBirth, getdate())
						  when @part = 'Month' then DATEDIFF(MM, @DateOfBirth, getdate())
						  when @part = 'Day' then DATEDIFF(DD, @DateOfBirth, getdate())
					 end
return @dateprt
END
----------or
GO
create procedure udf_datepart
@DateOfBirth date, 
@part varchar(20)
AS
BEGIN
Declare @SQL varchar(Max)
SET @SQL = concat('select DATEDIFF(',@part,', ''',@DateOfBirth,''', getdate())')
print @SQL
exec (@SQL)
END

-----Check
select dbo.udf_datepart('1989-05-25', 'Year')
exec udf_datepart '1989-08-25', 'Year'


--- 6 ---
go 
create procedure sp_MostExpensive
as
Begin
select top 1 *
from Products
order by UnitPrice
end


---7---
go
alter procedure sp_MostExpensive
as
Begin
with cte as
 (select ProductID, SUM(Quantity)q
from [Order Details]
group by ProductID
 )
 select distinct p.*, q
 from [Order Details] od
 join cte on od.ProductID = cte.ProductID
 join Products p on od.ProductID = p.ProductID
 where q = (select max(q)
			from cte)
 
end

---8---
GO
CREATE PROCEDURE sp_Products_in_ProductCategory
@ProductID INT
AS
BEGIN
select *
from products
where CategoryID = (select CategoryID
						from Products
						where ProductID = @ProductID)

END

---check
exec sp_Products_in_ProductCategory 8


---9---
GO
create procedure sp_ASCIIValue
@string nvarchar(max)
AS
BEGIN
Declare @p int =1,
		@FinalPosition int = 0,
		@substring nvarchar(10),
		@ASCII int = 0

SET @FinalPosition = LEN(@string)
while @p<=@FinalPosition
    BEGIN
     SET @substring = substring(@string,@p,1)
	 SET @ASCII = @ASCII + ASCII(@substring)
	 SET @p = @p+1
	END
Select (@ASCII)
END

---check
select ASCII('H')+ ASCII('e') +ASCII('l')+ASCII('l')+ASCII('o')
exec sp_ASCIIValue 'Hello'
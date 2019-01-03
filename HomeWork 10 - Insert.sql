--------------- 10 DML ---------------

--- 1 ---
/* create new products table */
select TOP 0 *
into Products_K
from Products

/* insert into new table only productName and ProductID */
SET IDENTITY_INSERT Products_K ON
alter table Products_K
alter column Discontinued [bit]  NULL

insert into Products_K (ProductName, ProductID)
select ProductName, ProductID
from Products

SET IDENTITY_INSERT Products_K OFF

/* update unitprice by 10% */
update pk
set pk.UnitPrice = p.UnitPrice*1.1
from Products p join Products_K pk
on p.ProductID = pk.ProductID

--- 2 ---
use tempdb
go
create table dbo.learninsert
(LineID int identity (1,1) not null,
 Name nvarchar(50) not null,
 AnotherName nvarchar(50) not null
)
--- 3 ---
declare @p int = 1
while @p <=5
Begin 
insert into learninsert
values ('Products_K', 'Products')
set @p = @p+1
END

--- 4 ---
go
declare @p int = 1
while @p <=5
Begin 
insert into learninsert
select name+'_k', name
from sys.tables
set @p = @p+1
END

--- 5 ---
select *
into learninsert2
from learninsert

--- 6 ---
delete top (1)
from learninsert2

--- 7 ---
delete 
from learninsert2
where LineID = 4

--- 8 ---
delete from learninsert2

--- 9 ---
insert into learninsert2
select *
from learninsert

--- 10 ---
delete from learninsert
go
declare @p int = 1
while @p <=5
Begin 
insert into learninsert
values ('Products_K', 'Products')
set @p = @p+1
END

/* the ID column will continue from 11 as delete function don't resets the identifier */

--- 11 ---
truncate table learninsert
go
declare @p int = 1
while @p <=5
Begin 
insert into learninsert
values ('Products_K', 'Products')
set @p = @p+1
END

/* the ID column will start from 1 as truncate function resets the identifier */
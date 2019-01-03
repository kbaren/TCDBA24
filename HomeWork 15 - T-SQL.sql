--------------- 15 T-SQL ---------------

--- 1 ---
use tempdb
GO
CREATE TABLE Sales2009
( saleID int identity(1,1) NOT NULL,
  SaleDate date NOT NULL,
  Ammount decimal(8,2) NOT NULL
)

GO
CREATE TABLE Sales2010
( saleID int identity(1,1) NOT NULL,
  SaleDate date NOT NULL,
  Ammount decimal(8,2) NOT NULL
)

GO
CREATE TABLE  Sales2011
( saleID int identity(1,1) NOT NULL,
  SaleDate date NOT NULL,
  Ammount decimal(8,2) NOT NULL
)

GO
CREATE TABLE Sales2012
( saleID int identity(1,1) NOT NULL,
  SaleDate date NOT NULL,
  Ammount decimal(8,2) NOT NULL
)


--- 2 ---
declare @p int = 1
while @p <=1000
Begin 
declare @date date,
		@Ammount int = 0
--- insert into 2009
set @date = DATEADD(day, (ABS(CHECKSUM(NEWID())) % (365)), '2009-01-01')
set @Ammount = LEFT(ABS(CHECKSUM(NEWID())), 5)
insert into Sales2009
values (@date, @Ammount)
--- insert into 2010
set @date = DATEADD(day, (ABS(CHECKSUM(NEWID())) % (365)), '2010-01-01')
set @Ammount = LEFT(ABS(CHECKSUM(NEWID())), 5)
insert into Sales2010
values (@date, @Ammount)
--- insert into 2011
set @date = DATEADD(day, (ABS(CHECKSUM(NEWID())) % (365)), '2011-01-01')
set @Ammount = LEFT(ABS(CHECKSUM(NEWID())), 5)
insert into Sales2011
values (@date, @Ammount)
--- insert into 2012
set @date = DATEADD(day, (ABS(CHECKSUM(NEWID())) % (365)), '2012-01-01')
set @Ammount = LEFT(ABS(CHECKSUM(NEWID())), 5)
insert into Sales2012
values (@date, @Ammount)
set @p = @p+1
END


--- 3 ---
GO
declare @date date,
@tablename nvarchar(50),
@SQL nvarchar(MAX)
select @date = DATEADD(day, (ABS(CHECKSUM(NEWID())) % (datediff(dd, '2009-01-01', '2012-12-31'))), '2009-01-01')
select @tablename = concat('Sales', YEAR(@date))
select @SQL = concat ('select * from ', @tablename, ' where SaleDate = ''', @date, '''')

exec (@SQL)


--- 4 ---
use tempdb
GO
CREATE TABLE dbo.Books
(BookID int not null,
 AuthorFirstName nvarchar(50) not null,
 AuthorLastName nvarchar(50) not null,
 PublishYear int not null,
 BookName nvarchar(100) not null,
 BookLanguage nvarchar(50) not null
)
GO
CREATE TABLE dbo.Categories
(CategoryID int not null,
 CategoryName nvarchar(50) not null,
)
GO
CREATE TABLE dbo.BooksCategories
(BookID int not null,
 CategoryID nvarchar(50) not null,
)

---- 5 ---
insert into Books
values
(1, 'Leo', 'Tolstoy', 1877, 'Anna Karenina', 'Russian'),
(2, 'Gustave', 'Flaubert', 1856, 'Madame Bovary', 'French'),
(3, 'Mark', 'Twain', 1884, 'Adventures of Huckleberry Finn', 'English'),
(4, 'Charles', 'Dickens', 1860, 'Great Expectations', 'English'),
(5, 'Ralph', 'Ellison', 1952, 'Invisible Man', 'English')

insert into Categories
values
(1, 'Children'),
(2, 'Drama'),
(3, 'Science fiction'),
(4, 'Romance'),
(5, 'Mystery')

insert into BooksCategories
values
(1,2),
(1,4),
(3,1),
(2,2),
(4,2),
(5,3),
(5,5)

--- 6 ---
-- h-i
DECLARE
@BookName nvarchar(100) = 'Great Expectations',
@AuthorFirstName nvarchar(50) = 'Charles',
@AuthorLastName nvarchar(50) = 'Dickens',
@PublishYear int = 1860,
@Language nvarchar(50) = 'English',
@Category nvarchar(50) = 'Drama'

--j
/* I didn't understand the question */

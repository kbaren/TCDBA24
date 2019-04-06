----------- 18 Table Constraints -----------
--- 1 ---
CREATE  UNIQUE nonclustered INDEX [ix_orders_OrderDate#customerid_unique]
ON orders (OrderDate, customerid) 
where [Orderdate]>='2018-01-01' 

--- 2 ---
alter table orders
with check add constraint chk_orders_freight check (freight>0)

--- 3 ---
alter table orders
with check add constraint chk_orders_Requireddate check (Requireddate>orderdate)

--- 4 ---
create table enterance_gates
(ID int not null IDENTITY(1,1) PRIMARY KEY,
 gate_description nvarchar(500) NOT NULL
)

create table Employee_enterance 
(ID int NOT NULL Foreign key REFERENCES Employees (EmployeeID),
 enterance_time datetime not null default getdate(),
 enterance_gate INT NOT NULL REFERENCES enterance_gates (ID).
 
)


--good rows
insert into enterance_gates
values ('front door of the maim building')
insert into enterance_gates
values ('back door of the maim building')
insert into enterance_gates
values ('left door of the secondary building')

select * from enterance_gates

--bad rows - Identity violation
insert into enterance_gates(ID, gate_description)
values (25, 'front door of the maim building')
--bad rows - PK violation
SET IDENTITY_INSERT enterance_gates ON
insert into enterance_gates(ID, gate_description)
values (2, 'back door')
SET IDENTITY_INSERT enterance_gates OFF

--good rows
insert into Employee_enterance
values (2, getdate(), 1)
insert into Employee_enterance
values (9, getdate(), 2)
insert into Employee_enterance (ID, enterance_gate)
values (1, 3)

select * from Employee_enterance

--bad rows fk Employees violation
insert into Employee_enterance
values (25, getdate(), 1)
--bad rows fk enterance_gates violation
insert into Employee_enterance (ID, enterance_gate)
values (1, 800)



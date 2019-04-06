
--- 1 ---
create view Operation.SomeInvitations_vw
as
select id, RequestingSessionId, receivingMemberId, CreationDateTime, statusId, ResponseDateTime
from operation.Invitations

--b
insert into Operation.SomeInvitations_vw
values (240655, 60031, '2012-05-11 05:44:54', 3, '2013-02-27 14:50:24')

--c
alter view Operation.SomeInvitations_vw
as
select id, RequestingSessionId, receivingMemberId, CreationDateTime, statusId
from operation.Invitations

--d
insert into Operation.SomeInvitations_vw
values (240655, 60031, '2012-05-11 05:44:54', 3, '2013-02-27 14:50:24')
-- we received the following error
-- An explicit value for the identity column in table 'Operation.SomeInvitations_vw' can only be specified when a column list is used and IDENTITY_INSERT is ON.

--e
insert into Operation.SomeInvitations_vw
values (240655, 60031, '2012-05-11 05:44:54', 3)

--f
alter view Operation.SomeInvitations_vw
as
select id, RequestingSessionId,  CreationDateTime, statusId
from operation.Invitations

--g
insert into Operation.SomeInvitations_vw
values (60031, '2012-05-11 05:44:54', 3)
--Cannot insert the value NULL into column 'ReceivingMemberId', table 'eDate.Operation.Invitations'; column does not allow nulls. INSERT fails.


--h.
alter view Operation.SomeInvitations_vw
as
select id, RequestingSessionId, receivingMemberId, CreationDateTime, statusId
from operation.Invitations

--i
insert into Operation.SomeInvitations_vw
values (240655, 60031, '2012-05-11 05:44:54', 2)

--j
alter view Operation.SomeInvitations_vw
as
select id, RequestingSessionId, receivingMemberId, CreationDateTime, statusId
from operation.Invitations
WITH CHECK OPTION

--k
insert into Operation.SomeInvitations_vw
values (240655, 60031, '2012-05-11 05:44:54', 2)

--l
alter view Operation.SomeInvitations_vw
as
select i.id, i.RequestingSessionId, i.receivingMemberId, i.CreationDateTime, i.statusId, m.MemberId
from operation.Invitations i join Operation.MemberSessions m
on i.receivingMemberid = m.MemberId
WITH CHECK OPTION

--m
insert into Operation.SomeInvitations_vw
values (459889,55868,'2018-12-05 21:25:43', 2)
--View or function 'Operation.SomeInvitations_vw' is not updatable because the modification affects multiple base tables.

--n.
create view Operation.MemberSessionsView_vw
as
select id, MemberId, LoginDateTime, EndDateTime, EndReasonId
from Operation.MemberSessions

--o
create view Operation.LastMonthSessions_vw
as
select id, MemberId, LoginDateTime, EndDateTime, EndReasonId
from Operation.MemberSessionsView_vw
where month(LoginDateTime) = month(getdate())-1

select *
from Operation.LastMonthSessions_vw

--p.
create view Operation.SingleMembersSessions_vw
as
select ms.Id, ms.MemberId, LoginDateTime, EndDateTime, EndReasonId
from Operation.MemberSessions ms join Lists.MaritalStatuses m
on ms.MemberId = m.Id
where m.name = 'Single'

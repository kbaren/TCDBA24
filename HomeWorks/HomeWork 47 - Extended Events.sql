--1--
CREATE EVENT SESSION [QueriesLongerThan5s] ON SERVER 
ADD EVENT sqlserver.sql_statement_completed(SET collect_statement=(1)
    ACTION(sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text)
    WHERE ([duration]>(5000000)))
ADD TARGET package0.ring_buffer
GO

--2--
CREATE EVENT SESSION [findDepricated] ON SERVER 
ADD EVENT sqlserver.deprecation_announcement(
    ACTION(sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text)),
ADD EVENT sqlserver.deprecation_final_support(
    ACTION(sqlserver.database_name,sqlserver.nt_username,sqlserver.sql_text))
ADD TARGET package0.ring_buffer
GO

--3--
CREATE EVENT SESSION [deadlock] ON SERVER 
ADD EVENT sqlserver.database_xml_deadlock_report,
ADD EVENT sqlserver.lock_deadlock,
ADD EVENT sqlserver.lock_deadlock_chain,
ADD EVENT sqlserver.xml_deadlock_report(
    ACTION(sqlserver.database_name,sqlserver.sql_text))
ADD TARGET package0.ring_buffer
GO

--4. find history of function call
CREATE EVENT SESSION [FuctionsHist] ON SERVER 
ADD EVENT sqlserver.existing_connection(
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.login(SET collect_options_text=(1)
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.logout(
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.module_end(
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.module_start(
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)),
ADD EVENT sqlserver.rpc_starting(
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)))),
ADD EVENT sqlserver.sp_statement_starting(SET collect_object_name=(1),collect_statement=(1)
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0)))),
ADD EVENT sqlserver.sql_batch_starting(
    ACTION(package0.callstack,sqlserver.compile_plan_guid,sqlserver.database_name,sqlserver.sql_text,sqlserver.tsql_stack)
    WHERE ([package0].[greater_than_uint64]([sqlserver].[database_id],(4)) AND [package0].[equal_boolean]([sqlserver].[is_system],(0))))
ADD TARGET package0.ring_buffer
WITH (MAX_MEMORY=4096 KB,EVENT_RETENTION_MODE=ALLOW_SINGLE_EVENT_LOSS,MAX_DISPATCH_LATENCY=30 SECONDS,MAX_EVENT_SIZE=0 KB,MEMORY_PARTITION_MODE=NONE,TRACK_CAUSALITY=ON,STARTUP_STATE=OFF)
GO
Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'Function Nname Starts With udf_', @description=N'Function names must begin with udf_', @facet=N'UserDefinedFunction', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>LIKE</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>String</TypeClass>
    <Name>Name</Name>
  </Attribute>
  <Constant>
    <TypeClass>String</TypeClass>
    <ObjType>System.String</ObjType>
    <Value>udf_%</Value>
  </Constant>
</Operator>', @is_name_condition=2, @obj_name=N'udf_%', @condition_id=@condition_id OUTPUT
Select @condition_id

GO


Declare @condition_id int
EXEC msdb.dbo.sp_syspolicy_add_condition @name=N'On Casino', @description=N'', @facet=N'Database', @expression=N'<Operator>
  <TypeClass>Bool</TypeClass>
  <OpType>EQ</OpType>
  <Count>2</Count>
  <Attribute>
    <TypeClass>String</TypeClass>
    <Name>Name</Name>
  </Attribute>
  <Constant>
    <TypeClass>String</TypeClass>
    <ObjType>System.String</ObjType>
    <Value>Casino</Value>
  </Constant>
</Operator>', @is_name_condition=1, @obj_name=N'Casino', @condition_id=@condition_id OUTPUT
Select @condition_id

GO

Declare @object_set_id int
EXEC msdb.dbo.sp_syspolicy_add_object_set @object_set_name=N'FunctionNameValidation_ObjectSet', @facet=N'UserDefinedFunction', @object_set_id=@object_set_id OUTPUT
Select @object_set_id

Declare @target_set_id int
EXEC msdb.dbo.sp_syspolicy_add_target_set @object_set_name=N'FunctionNameValidation_ObjectSet', @type_skeleton=N'Server/Database/UserDefinedFunction', @type=N'FUNCTION', @enabled=True, @target_set_id=@target_set_id OUTPUT
Select @target_set_id

EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database/UserDefinedFunction', @level_name=N'UserDefinedFunction', @condition_name=N'', @target_set_level_id=0
EXEC msdb.dbo.sp_syspolicy_add_target_set_level @target_set_id=@target_set_id, @type_skeleton=N'Server/Database', @level_name=N'Database', @condition_name=N'On Casino', @target_set_level_id=0


GO

Declare @policy_id int
EXEC msdb.dbo.sp_syspolicy_add_policy @name=N'FunctionNameValidation', @condition_name=N'Function Nname Starts With udf_', @policy_category=N'', @description=N'Function names must begin with udf_', @help_text=N'', @help_link=N'', @schedule_uid=N'00000000-0000-0000-0000-000000000000', @execution_mode=1, @is_enabled=False, @policy_id=@policy_id OUTPUT, @root_condition_name=N'', @object_set=N'FunctionNameValidation_ObjectSet'
Select @policy_id


GO


DROP TABLE #temp

go

select case when substring('12345670',1, 1) * 1 >9 then cast(Left(substring('12345670',1, 1) * 1,1)  as int)+ Cast(RIGHT (substring('12345670',1, 1) * 1 ,1) as int) else substring('12345670',1, 1) * 1 end
	    +																		 														
	   case when substring('12345670',2, 1) * 2 >9 then cast(Left(substring('12345670',2, 1) * 2,1)  as int)+ Cast(RIGHT (substring('12345670',2, 1) * 2 ,1) as int) else substring('12345670',2, 1) * 2 end
	    +														    			 														
       case when substring('12345670',3, 1) * 1 >9 then cast(Left(substring('12345670',3, 1) * 1,1)  as int)+ Cast(RIGHT (substring('12345670',3, 1) * 1 ,1) as int) else substring('12345670',3, 1) * 1 end
	    +														    
	   case when substring('12345670',4, 1) * 2 >9 then cast(Left(substring('12345670',4, 1) * 2,1)  as int)+ Cast(RIGHT (substring('12345670',4, 1) * 2 ,1) as int) else substring('12345670',4, 1) * 2 end
	    +														    
	   case when substring('12345670',5, 1) * 1 >9 then cast(Left(substring('12345670',5, 1) * 1,1)  as int)+ Cast(RIGHT (substring('12345670',5, 1) * 1 ,1) as int) else substring('12345670',5, 1) * 1 end
	    +														   																	    
	   case when substring('12345670',6, 1) * 2 >9 then cast(Left(substring('12345670',6, 1) * 2,1)  as int)+ Cast(RIGHT (substring('12345670',6, 1) * 2 ,1) as int) else substring('12345670',6, 1) * 2 end
	    +														    															
       case when substring('12345670',7, 1) * 1 >9 then cast(Left(substring('12345670',7, 1) * 1,1)  as int)+ Cast(RIGHT (substring('12345670',7, 1) * 1 ,1) as int) else substring('12345670',7, 1) * 1 end
	    +														    																 
	   case when substring('12345670',8, 1) * 2 >9 then cast(Left(substring('12345670',8, 1) * 2,1)  as int)+ Cast(RIGHT (substring('12345670',8, 1) * 2 ,1) as int) else substring('12345670',8, 1) * 2 end
	    AS SUM
into #temp


go

select ceiling(cast(SUM as float) / 10)*10 - SUM
from #temp

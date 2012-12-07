select
    a.computer_sys_id
    ,b.inst_mem_id
    ,b.module_size_mb
    ,b.max_module_size_mb
    ,b.socket_name     
    ,b.packaging
    ,b.mem_type
    ,b.record_time
	,CURRENT TIMESTAMP as update_time
from
    computer a
    ,Mem_Modules b
where
    a.computer_sys_id = b.computer_sys_id
with ur;
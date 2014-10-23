select
    a.computer_sys_id
    ,b.processor_num
    ,b.record_time
    ,CURRENT TIMESTAMP as acquisition_time
    ,c.manufacturer
    ,c.processor_model
    ,c.max_speed
    ,c.bus_speed
    ,b.is_enabled
    ,b.ser_num
    ,b.processor_board
    ,b.processor_module
    ,'' as pvu
    ,c.ecache_mb
    ,c.current_speed
from
    computer a
    left outer join inst_processor b on
    	a.computer_sys_id = b.computer_sys_id,
    processor c
where
    b.processor_id = c.processor_id
with ur;

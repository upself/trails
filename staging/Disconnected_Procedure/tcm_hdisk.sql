select
    a.computer_sys_id
    ,a.model
    ,b.hdisk_size_mb
    ,a.record_time
    ,CURRENT TIMESTAMP as acquisition_time    
    ,a.manufacturer
    ,a.ser_num
    ,a.storage_type        
from
    storage_dev a
    ,hdisk b
where
    a.hdisk_id = b.hdisk_id
with ur;

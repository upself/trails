select
    a.computer_sys_id
    ,b.id
    ,b.name
    ,b.file_size
    ,CURRENT TIMESTAMP as acquisition_time
from
    matched_sware a
    ,signature b
where
    a.sware_sig_id = b.id
with ur;

select
    a.computer_sys_id
    ,a.sware_sig_id
    ,b.sware_name
    ,b.sware_size
    ,CURRENT TIMESTAMP as acquisition_time
from
    matched_sware a
    ,sware_sig b
where
    a.sware_sig_id = b.sware_sig_id
    and b.sig_status = '1'
with ur;

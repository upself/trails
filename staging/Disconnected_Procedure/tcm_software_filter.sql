select
    a.computer_sys_id
    ,a.nativ_id
    ,b.package_name
    ,b.package_vers
    ,CURRENT TIMESTAMP as acquisition_time
from
    inst_nativ_sware a
    ,nativ_sware b
where
    a.nativ_id = b.nativ_id
with ur;

select
    a.computer_sys_id
    ,a.asset_tag
    ,a.serial_number
    ,a.last_scan_dt
    ,a.record_time
    ,CURRENT TIMESTAMP as acquisition_time
from
    barcode_custom a
with ur;

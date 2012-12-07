select
    a.node_name
    ,a.tme_object_id
    ,a.computer_sys_id
    ,a.endpoint_status
    ,a.last_login_time
    ,a.record_time
from
    aab_endpoint a
with ur;

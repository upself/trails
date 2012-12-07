select
    a.computer_sys_id
    ,a.ip_addr
    ,a.ip_hostname
    ,a.ip_domain
    ,a.ip_subnet
    ,a.record_time
    ,CURRENT TIMESTAMP as acquisition_time
    ,'' as instance_id    
    ,a.ip_gateway
    ,a.ip_primary_dns
    ,a.ip_secondary_dns
    ,a.is_dhcp
    ,a.perm_mac_address
from
    ip_addr a
with ur;
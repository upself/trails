select
    a.computer_sys_id
    ,a.computer_scantime
    ,a.tme_object_id
    ,a.tme_object_label
    ,a.computer_model
    ,a.sys_ser_num
    ,a.os_name
    ,a.os_type
    ,a.os_major_vers
    ,a.os_minor_vers
    ,a.os_sub_vers
    ,a.os_inst_date
    ,b.user_name
    ,b.bios_manufacturer
    ,b.bios_model
    ,'' as server_type
    ,a.record_time
    ,CURRENT TIMESTAMP as acquisition_time
    ,'' as tech_img_id
    ,'' as ext_id
    ,'' as memory
    ,'' as disk
    ,'' as dedicated_processors
    ,'' as total_processors	   
    ,'' as shared_processors	   
    ,'' as processor_type	   
    ,'' as shared_proc_by_cores	   
    ,'' as dedicated_proc_by_cores	   
    ,'' as total_proc_by_cores	 
    ,a.computer_alias
    ,c.physical_total_kb
    ,c.virt_total_kb
    ,c.physical_free_kb
    ,c.virt_free_kb
    ,'' as node_capacity
    ,'' as lpar_capacity
    ,d.bios_date
    ,d.sys_ser_num
    ,d.sys_uuid
    ,d.board_ser_num
    ,d.case_ser_num
    ,d.case_asset_tag
    ,'' as poweron_password
from
computer a
	left outer join pc_sys_params b on
		a.computer_sys_id = b.computer_sys_id
	left outer join computer_sys_mem c on
		c.computer_sys_id = a.computer_sys_id
	left outer join inst_smbios_data d on
		d.computer_sys_id = a.computer_sys_id
with ur;

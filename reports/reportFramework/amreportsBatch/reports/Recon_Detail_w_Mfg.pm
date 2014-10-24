package AMReport;

sub report_type {
    return "customer";
}

sub database {
    return "trails3";
}

sub schema {
    return "eaadmin";
}

sub sql {
    my ($customerId, $customerType) = @_;
    if ($customerType eq 'STRATEGIC OUTSOURCING MAINFRAME') {
    return "
select
s.status
,s.cpu
,s.product_description
,s.lic_desc
,s.tower_response
,s.tower_comment
,s.action_performed
,s.dpe_comment
,s.change_control
,m.manufacturer_name
from tap.sa_installed s
left join tap.mf_price_of_change pc on pc.mf_price_of_change_id=s.mf_price_of_change_id
left join software sw on sw.software_name = s.product_description
left join manufacturer m on sw.manufacturer_id = m.manufacturer_id
where customer_id = ?
with ur
";
    }
    else {
    return "
select 
node_name
,serial_number
,owner
,type
,processor_count
,software_name
,product_description
,license_type
,status
,po_number
,quantity
,reconcile_id
,action_performed
,hw_sw_composite_id
,comments
,change_control
,version
,manufacturer_name
,country 
from ( 
select 
node_name
,serial_number
,owner
,type
,processor_count
,software_name
,product_description
,license_type
,status
,po_number
,quantity
,reconcile_id
,action_performed
,hw_sw_composite_id
,comments
,change_control
,version
,manufacturer_name
,country 
,rownumber() over (order by type ASC, owner DESC, node_name) as rn 
from (
select
hw.node_name
,hw.serial_number
,hw.owner
,hw.type
,isw.processor_count
,sw.software_name
,p.product_description
,lb.license_type
,r.status
,ld.po_number
,r.quantity
,r.reconcile_id
,r.action_performed
,hsc.hw_sw_composite_id
,r.comments
,r.change_control
,isw.version
,mfg.manufacturer_name
,hw.country 
from 
tap.hardware_baseline as hw
,tap.software as sw
,tap.manufacturer as mfg
,tap.installed_software_baseline as isw
,tap.hw_sw_composite as hsc
,tap.product_description as p
,tap.license_baseline as lb
,tap.license_detail as ld
,tap.reconcile as r 
where hsc.customer_id = ?
and hw.customer_id = hsc.customer_id
and isw.customer_id = hsc.customer_id
and lb.customer_id = hsc.customer_id
and r.customer_id = hsc.customer_id
and ld.license_detail_id = r.license_detail_id 
and ld.license_baseline_id = lb.license_baseline_id 
and lb.product_description_id = p.product_description_id 
and hsc.hw_sw_composite_id = r.hw_sw_composite_id 
and hw.hardware_baseline_id = hsc.hardware_baseline_id 
and isw.installed_software_baseline_id = hsc.installed_software_baseline_id 
and isw.software_id = sw.software_id
and sw.manufacturer_id = mfg.manufacturer_id
union
select 
hw.node_name
,hw.serial_number
,hw.owner
,hw.type
,isw.processor_count
,sw.software_name
,'' as product_description
,'' as license_type
,'UNRECONCILED' as status
,'' as po_number
,0 as quantity
,0 as reconcile_id
,'' as action_performed
,hsc.hw_sw_composite_id
,'' as comments
,'' as change_control
,isw.version
,mfg.manufacturer_name
,hw.country 
from 
tap.hardware_baseline as hw
,tap.software as sw
,tap.manufacturer as mfg
,tap.installed_software_baseline as isw
,tap.hw_sw_composite as hsc 
where 
hsc.customer_id = ?
and not exists (
select 
1 
from 
tap.reconcile 
where 
tap.reconcile.customer_id = ?
and tap.reconcile.hw_sw_composite_id = hsc.hw_sw_composite_id )
and hw.hardware_baseline_id = hsc.hardware_baseline_id 
and isw.installed_software_baseline_id = hsc.installed_software_baseline_id 
and isw.software_id = sw.software_id
and sw.manufacturer_id = mfg.manufacturer_id
union
select 
hw.node_name
,hw.serial_number
,hw.owner
,hw.type
,isw.processor_count
,sw.software_name
,'' as product_description
,'' as license_type
,r.status
,'' as po_number
,r.quantity
,r.reconcile_id
,r.action_performed
,hsc.hw_sw_composite_id
,r.comments
,r.change_control
,isw.version
,mfg.manufacturer_name
,hw.country 
from 
tap.hardware_baseline as hw
,tap.software as sw
,tap.manufacturer as mfg
,tap.installed_software_baseline as isw
,tap.hw_sw_composite as hsc
,tap.reconcile as r 
where 
hsc.customer_id = ?
and hw.customer_id = hsc.customer_id
and isw.customer_id = hsc.customer_id
and r.customer_id = hsc.customer_id
and r.license_detail_id = 0 
and hsc.hw_sw_composite_id = r.hw_sw_composite_id 
and hw.hardware_baseline_id = hsc.hardware_baseline_id 
and isw.installed_software_baseline_id = hsc.installed_software_baseline_id 
and isw.software_id = sw.software_id
and sw.manufacturer_id = mfg.manufacturer_id
) as x) as y
with ur
";
    }
}

1;

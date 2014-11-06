select distinct
    geo.name                    as "GEOGRAPHY",
    cust.customer_name,
    cust_type.customer_type_name,
    pod_name,
    sw_lpar.name                as "SOFTWARE_LPAR_NAME",
    sw.software_name,
    -- mf.manufacturer_name,
--    sw.software_name,
    sig.software_version        as "SIG_SW_VERSION",
    sig.file_name               as "SIG_FILE_NAME",
    sig.file_size               as "SIG_FILE_SIZE"

from
    software as sw
    -- left outer join manufacturer as mf
    --     on sw.manufacturer_id = mf.manufacturer_id

    inner join software_signature as sig
        on sig.software_id = sw.software_id

    -- and link it to accounts
    inner join installed_signature as inst_sig
        on sig.software_signature_id = inst_sig.software_signature_id
    -- left outer join bank_account as ba
    --     on inst_sig.bank_account_id = ba.id

    -- link to installed software...
    inner join installed_software as inst_sw
        on inst_sw.id = inst_sig.installed_software_id

    -- and link to s/w lp
    inner join software_lpar as sw_lpar
        on sw_lpar.id = inst_sw.software_lpar_id

    -- customer && type info 
    inner join customer as cust
        on sw_lpar.customer_id = cust.customer_id
    inner join customer_type as cust_type
        on cust.customer_type_id = cust_type.customer_type_id

    -- pod info
    inner join pod 
        on cust.pod_id = pod.pod_id
        
    -- geo info
    inner join country_code as cc
        on cust.country_code_id = cc.id
    inner join region
        on cc.region_id = region.id
    inner join geography as geo
        on region.geography_id = geo.id
    
where
    inst_sw.STATUS     = 'ACTIVE'
    -- and mf.status      = 'ACTIVE'
    and sw_lpar.STATUS = 'ACTIVE'
    and sig.STATUS     = 'ACTIVE'
    -- and ba.STATUS     != 'INACTIVE'
	and cust.STATUS    = 'ACTIVE'

--    and (sig.file_name like '%-CSP%' or sig.file_name like '%-csp%')
and (upper(sig.file_name) like 'ESD.%-CSP%' or upper(sig.file_name) like '%_IPLNO.SIG' or upper(sig.file_name) like '%_IPLNO.EXE')
    -- and sig.file_name like 'rh%'

    and (
            inst_sig.bank_account_id in 
                (select id from bank_account 
                where status != 'INACTIVE' and type != 'TLM')
        or    
            inst_sig.bank_account_id is null
        )
order by 
    -- mf.manufacturer_name,
    sw.software_name,
    sig.file_name,
    sig.software_version

for fetch only
with ur
;

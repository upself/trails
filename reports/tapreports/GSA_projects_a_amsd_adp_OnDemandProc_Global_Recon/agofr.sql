SELECT
                gsf.Geo
                ,gsf.Region
                ,gsf.account_number "Account number"
                ,gsf.customer_name "Customer name"
                ,tfr.Alert_status "Alert status"
                ,tfr.Alert_opened "Alert opened"
                ,tfr.Alert_duration "Alert duration"
                ,tfr.SW_LPAR_name "SW LPAR name"
                ,tfr.HW_serial "HW serial"
                ,tfr.HW_machine_type "HW machine type"
                ,tfr.Owner
                ,tfr.Country
                ,tfr.Asset_type "Asset type"
                ,tfr.Physical_HW_processor_count "Physical HW processor count"
                ,tfr.Physical_chips "Physical chips"
                ,tfr.Effective_processor_count "Effective processor count"
                ,tfr.Installed_SW_product_name "Installed SW product name"
                ,tfr.Alert_assignee "Alert assignee"
                ,tfr.Alert_assignee_comment "Alert assignee comment"
                ,tfr.Inst_SW_manufacturer "Inst SW manufacturer"
                ,tfr.Inst_SW_validation_status "Inst SW validation status"
                ,tfr.Reconciliation_action "Reconciliation action"
                ,tfr.Reconciliation_user "Reconciliation user"
                ,tfr.Reconciliation_date_time "Reconciliation date/time"
                ,tfr.Reconciliation_comments "Reconciliation comments"
                ,tfr.Reconciliation_parent_product "Reconciliation parent product"
                ,tfr.License_account_number "License account number"
                ,tfr.Full_product_description "Full product description"
                ,tfr.Catalog_match "Catalog match"
                ,tfr.License_product_name "License product name"
                ,tfr.Version
                ,tfr.Capacity_type "Capacity type"
                ,tfr.Quantity_used "Quantity used"
                ,tfr.Machine_level "Machine level"
                ,tfr.Maintenance_expiration_date "Maintenance expiration date"
                ,tfr.PO_number "PO number"
                ,tfr.License_serial_number "License serial number"
                ,tfr.License_owner "License owner"
                ,tfr.SWCM_ID "SWCM ID"
                ,tfr.License_last_update "License last update"

From (
SELECT
                sl.customer_id slcustid
                ,CASE WHEN AUS.Open = 0 THEN 'Blue' WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 90 THEN 'Red' WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 45 THEN 'Yellow' ELSE 'Green' END Alert_status
                ,aus.creation_time Alert_opened
                ,case when aus.open = 1 then DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) else days(aus.record_time) - days(aus.creation_time) end Alert_duration
                ,sl.name SW_LPAR_name
                ,h.serial HW_serial
                ,mt.name HW_machine_type 
                ,h.owner Owner
                ,h.country Country
                ,mt.type Asset_type
                ,h.processor_count Physical_HW_processor_count
                ,h.chips Physical_chips
                ,case when sle.software_lpar_id is null then sl.processor_count else sle.processor_count end Effective_processor_count
                ,instSi.name Installed_SW_product_name
                ,aus.remote_user Alert_assignee
                ,aus.comments Alert_assignee_comment
                ,instSwMan.name Inst_SW_manufacturer
                ,dt.name Inst_SW_validation_status
                ,case when rt.is_manual = 0 then rt.name || '(AUTO)' when rt.is_manual = 1 then rt.name || '(MANUAL)' end Reconciliation_action
                ,r.remote_user Reconciliation_user
                ,r.record_time Reconciliation_date_time
                ,case when rt.is_manual = 0 then 'Auto Close' when rt.is_manual = 1 then r.comments end Reconciliation_comments
                ,parentSi.name Reconciliation_parent_product
                ,c.account_number License_account_number
                ,l.full_desc Full_product_description
                ,case when l.id is null then '' when lsm.id is null then 'No' else 'Yes' end Catalog_match
                ,l.prod_name License_product_name
                ,l.version
                ,CONCAT(CONCAT(RTRIM(CHAR(L.Cap_Type)), '-'), CT.Description) Capacity_type
                ,ul.used_quantity Quantity_used
                ,case when r.id is null then '' when r.machine_level = 0 then 'No'  else 'Yes' end Machine_level
                ,REPLACE(RTRIM(CHAR(DATE(L.Expire_Date), USA)), '/', '-') Maintenance_expiration_date
                ,l.po_number PO_number
                ,l.cpu_serial License_serial_number
                ,case when l.ibm_owned = 0 then 'Customer' when l.ibm_owned = 1 then 'IBM'  else '' end License_owner
                ,l.ext_src_id  SWCM_ID
                ,l.record_time  License_last_update
From  
                eaadmin.software_lpar sl
                left outer join eaadmin.software_lpar_eff sle on 
                sl.id = sle.software_lpar_id 
                and sle.status = 'ACTIVE' 
                and sle.processor_count != 0 
                inner join eaadmin.hw_sw_composite hsc on 
                sl.id = hsc.software_lpar_id 
                inner join eaadmin.hardware_lpar hl on 
                hsc.hardware_lpar_id = hl.id 
                inner join eaadmin.hardware h on 
                hl.hardware_id = h.id 
                inner join eaadmin.machine_type mt on 
                h.machine_type_id = mt.id 
                inner join eaadmin.installed_software is on 
                sl.id = is.software_lpar_id 
                inner join eaadmin.product_info instPi on 
                is.software_id = instPi.id 
                inner join eaadmin.product instP on 
                instPi.id = instP.id 
                inner join eaadmin.software_item instSi on 
                instP.id = instSi.id 
                inner join eaadmin.manufacturer instSwMan on 
                instP.manufacturer_id = instSwMan.id 
                inner join eaadmin.discrepancy_type dt on 
                is.discrepancy_type_id = dt.id 
                inner join eaadmin.alert_unlicensed_sw aus on 
                is.id = aus.installed_software_id 
                left outer join eaadmin.reconcile r on 
                is.id = r.installed_software_id 
                left outer join eaadmin.reconcile_type rt on 
                r.reconcile_type_id = rt.id 
                left outer join eaadmin.installed_software parent on 
                r.parent_installed_software_id = parent.id 
                left outer join eaadmin.product_info parentPi on 
                parent.software_id = parentPi.id 
                left outer join eaadmin.product parentP on 
                parentPi.id = parentP.id 
                left outer join eaadmin.software_item parentSi on 
                parentSi.id = parentP.id 
                left outer join eaadmin.reconcile_used_license rul on 
                r.id = rul.reconcile_id 
                left outer join eaadmin.used_license ul on 
                rul.used_license_id = ul.id 
                left outer join eaadmin.license l on 
                ul.license_id = l.id 
                left outer join eaadmin.license_sw_map lsm on 
                l.id = lsm.license_id 
                left outer join eaadmin.capacity_type ct on 
                l.cap_type = ct.code 
                left outer join eaadmin.customer c on 
                l.customer_id = c.customer_id 

--inner join EAADMIN.Schedule_F SF on sf.customer_id = sl.customer_id and instPi.id = sf.software_id

Where 

sl.customer_id = hl.customer_id
--and sl.customer_id in (12164)

--and (aus.open = 1 or (aus.open = 0 and is.id = r.installed_software_id))
--and (aus.open = 0 and is.id = r.installed_software_id)
and aus.open = 1

--and r.record_time between '2012-04-01 00:00:00.000000' and current timestamp
--and r.record_time between '2012-04-01 00:00:00.000000' and '2012-05-01 00:00:00.000000' 
--and month(r.record_time) = (CASE month(current timestamp) WHEN 01 THEN 12 ELSE month(current timestamp) - 1 END)
--AND year(r.record_time) = (CASE month(current timestamp) WHEN 01 THEN year(current timestamp) - 1 else year(current timestamp) END)

--AND SF.Scope_Id IN (1,2,3)

--AND NOT EXISTS (SELECT SF.Software_Id FROM EAADMIN.Schedule_F SF, EAADMIN.Status S3 WHERE SF.Customer_Id = c.customer_Id AND SF.Software_Id = instSi.Id AND S3.Id = SF.Status_Id AND S3.Description = 'ACTIVE')

--Order by sl.name

) tfr

inner join
(SELECT
                geog.name Geo
                ,reg.name Region
                ,cc.name Country_code
                ,c.customer_id
                ,c.customer_name
                ,c.account_number
From    
                eaadmin.customer c
                inner join eaadmin.country_code cc on c.country_code_id = cc.id
                inner join eaadmin.region reg on cc.region_id = reg.id
                inner join eaadmin.geography geog on reg.geography_id = geog.id
) gsf on tfr.slcustid = gsf.customer_id

Where gsf.geo in ('NA','LA')

for fetch only
with ur
;

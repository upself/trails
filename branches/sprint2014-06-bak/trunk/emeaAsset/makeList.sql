connect to traherp user dbryson using apr10new;

set schema eaadmin;

export to /home/dbryson/asset_emea/emea_list.txt of del 
select account_number from customer where country_code_id in
(select id from eaadmin.country_code where region_id in 
(select id from eaadmin.region where geography_id = 2)
) with ur;

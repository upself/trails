select count(*)
from 
  scarlet_reconcile sr 
  join reconcile r on sr.id  =r.id
  join installed_software is on r.installed_software_id  = is.id
  join software_lpar sl on is.software_lpar_id = sl.id
  join software_item si on is.software_id = si.id
  
  left outer join schedule_f sf
  on sf.customer_id = sl.customer_id and sf.software_name = si.name
  	and sf.hostname = sl.name
where
sf.level = 'HOSTNAME'
and sf.status_id = 2 
and r.machine_level = 1
with ur;
--Result on DEV: 14


select count(*)
from 
  reconcile r 
  join installed_software is on r.installed_software_id  = is.id
  join software_lpar sl on is.software_lpar_id = sl.id
  join software_item si on is.software_id = si.id
  
  left outer join schedule_f sf
  on sf.customer_id = sl.customer_id and sf.software_name = si.name
  	and sf.hostname = sl.name
where
sf.level = 'HOSTNAME'
and sf.status_id = 2 
and r.machine_level = 1
with ur 
--Reuslt on DEV: 16463
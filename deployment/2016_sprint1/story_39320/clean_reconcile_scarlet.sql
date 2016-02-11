--This is a one time script that clean the item 
--in Scarlet_Reconcile which reconcile_type_id not equals 5. 

delete from scarlet_reconcile sr
where sr.id in (

select r.id from reconcile r
where exists (select 1 from scarlet_reconcile sr where sr.id = r.id)
and r.reconcile_type_id = 3

)

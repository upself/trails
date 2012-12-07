select
    customer_id
    ,min(record_time)
from
    v_recon_queue
group by
    customer_id
order by
    min(record_time)
with ur
;

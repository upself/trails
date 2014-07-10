select  distinct
        f.software_name,
        f.software_version,
        'PLACE_HOLDER',
        0,
        s.software_name,
        f.map_software_version,
        1,
        s.level,
        'NATIV',
        date(f.record_time)
from
        software_filter f,
        software s
where
        f.software_id = s.software_id and
        s.status = 'ACTIVE' and
        f.status = 'ACTIVE'


;

select
	sf1.software_id
	,sf1.software_name
	,sf1.software_version
	,sf1.map_software_version
	,sf2.map_software_version

from
	software_filter sf1
	,software_filter sf2
where
	sf1.software_name = sf2.software_name
	and sf1.software_version = sf2.software_version
	and sf1.map_software_version != sf2.map_software_version
;

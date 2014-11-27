package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Software;

public interface SoftwareDAO extends BaseEntityDAO<Software, Long> {

	Software getSoftwareDetails(Long softwareId);

	Manufacturer getManufacturerBySoftwareId(Long manufacturerId);
}

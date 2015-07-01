package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.Manufacturer;

public interface ManufacturerDAO extends
		BaseEntityDAO<Manufacturer, Long> {
	public Manufacturer findManufacturerByName(String name); 
}

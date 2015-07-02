package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.Manufacturer;


public interface ManufacturerDAO extends BaseEntityDAO<Manufacturer, Long> {

	List<Manufacturer> findByNameLike(String name);

	public Manufacturer findManufacturerByName(String name); 

}

package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.Manufacturer;

public interface ManufacturerService {

	public Manufacturer findManufacturerById(Long id);

	public List<Manufacturer> findByNameLike(String name);
}

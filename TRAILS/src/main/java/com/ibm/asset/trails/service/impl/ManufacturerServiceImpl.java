package com.ibm.asset.trails.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.dao.ManufacturerDAO;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.service.ManufacturerService;

@Service
public class ManufacturerServiceImpl implements ManufacturerService{

	@Autowired
	private ManufacturerDAO manufacturerDAO;

	@Override
	public Manufacturer findManufacturerById(Long id) {
		return this.manufacturerDAO.findById(id);
	}
}

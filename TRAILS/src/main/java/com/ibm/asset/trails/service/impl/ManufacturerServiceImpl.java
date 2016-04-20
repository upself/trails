package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.dao.ManufacturerDAO;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.service.ManufacturerService;

@Service
public class ManufacturerServiceImpl implements ManufacturerService {

	@Autowired
	private ManufacturerDAO manufacturerDAO;

	public Manufacturer findManufacturerById(Long id) {
		return this.manufacturerDAO.findById(id);
	}


	public List<Manufacturer> findByNameLike(String name) {
		return this.manufacturerDAO.findByNameLike(name);
	}


	@Override
	public Manufacturer findManufacturerByName(String name) {
		// TODO Auto-generated method stub
		return manufacturerDAO.findManufacturerByName(name);
	}
	
	@Override
	public  List<Manufacturer> findManufacturerListByName(String name) {
		return manufacturerDAO.findManufacturerListbyName(name);
	}

}

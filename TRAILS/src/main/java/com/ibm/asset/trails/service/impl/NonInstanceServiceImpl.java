package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.dao.NonInstanceDAO;
import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.Software;
import com.ibm.asset.trails.service.NonInstanceService;

@Service
public class NonInstanceServiceImpl extends AbstractGenericEntityService<NonInstance, Long> implements NonInstanceService{

	@Autowired
	private NonInstanceDAO dao;
	
	
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public NonInstanceDisplay findNonInstanceDisplayById(Long Id) {
		// TODO Auto-generated method stub
		return dao.findNonInstanceDisplayById(Id);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceDisplay> findNonInstanceDisplays(
			NonInstanceDisplay nonInstanceDisplay) {
		// TODO Auto-generated method stub
		return dao.findNonInstanceDisplays(nonInstanceDisplay);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceHDisplay> findNonInstanceHDisplays(Long nonInstanceId) {
		// TODO Auto-generated method stub
		return dao.findNonInstanceHDisplays(nonInstanceId);
	}
	
	
	@Override
	protected BaseEntityDAO<NonInstance, Long> getDao() {
		// TODO Auto-generated method stub
		return dao;
	}
}

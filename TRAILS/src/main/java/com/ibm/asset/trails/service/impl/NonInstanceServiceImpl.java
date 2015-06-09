package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.dao.NonInstanceDAO;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.service.NonInstanceService;

@Service
public class NonInstanceServiceImpl extends AbstractGenericEntityService<NonInstance, Long> implements NonInstanceService{

	@Autowired
	private NonInstanceDAO dao;
	@Override
	protected BaseEntityDAO<NonInstance, Long> getDao() {
		// TODO Auto-generated method stub
		return dao;
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceDisplay> findNonInstanceDisplays(
			NonInstanceDisplay nonInstanceDisplay) {
		// TODO Auto-generated method stub
		return dao.findNonInstanceDisplays(nonInstanceDisplay);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public NonInstance findNonInstancesDisplayById(Long id) {
		// TODO Auto-generated method stub
		return dao.findNonInstancesDisplayById(id);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstancesByRestriction(String restriction) {
		// TODO Auto-generated method stub
		return dao.findNonInstancesByRestriction(restriction);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstancesBySoftwareId(long softwareId) {
		// TODO Auto-generated method stub
		return dao.findNonInstancesBySoftwareId(softwareId);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstance> findNonInstancesByManufacturerId(
			Long manufacturerId) {
		// TODO Auto-generated method stub
		return dao.findNonInstancesByManufacturerId(manufacturerId);
	}

	public void removeNonInsanceById(Long id) {
		// TODO Auto-generated method stub
		dao.removeNonInsanceById(id);
	}

}

package com.ibm.asset.trails.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.dao.AllocationMethodologyDao;
import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.domain.AllocationMethodology;
import com.ibm.asset.trails.service.AllocationMethodologyService;

@Service
public class AllocationMethodologyServiceImpl extends
		AbstractGenericEntityService<AllocationMethodology, Long> implements
		AllocationMethodologyService {

	@Autowired
	private AllocationMethodologyDao dao;

	@Override
	protected BaseEntityDAO<AllocationMethodology, Long> getDao() {
		return dao;
	}

}

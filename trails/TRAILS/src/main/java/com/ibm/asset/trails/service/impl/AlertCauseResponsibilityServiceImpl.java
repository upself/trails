package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.AlertCauseResponsibilityDao;
import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.service.AlertCauseResponsibilityService;

@Service
public class AlertCauseResponsibilityServiceImpl extends
		AbstractGenericEntityService<AlertCauseResponsibility, Long> implements
		AlertCauseResponsibilityService {

	@Autowired
	private AlertCauseResponsibilityDao dao;

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<AlertCauseResponsibility> list() {
		return dao.list();
	}

	@Override
	protected BaseEntityDAO<AlertCauseResponsibility, Long> getDao() {
		return dao;
	}

}

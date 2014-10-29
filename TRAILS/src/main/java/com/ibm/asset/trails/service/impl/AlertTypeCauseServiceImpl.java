package com.ibm.asset.trails.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.dao.AlertTypeCauseDao;
import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.domain.AlertTypeCause;
import com.ibm.asset.trails.service.AlertTypeCauseService;

@Service
public class AlertTypeCauseServiceImpl extends
		AbstractGenericEntityService<AlertTypeCause, Long> implements
		AlertTypeCauseService {

	@Autowired
	private AlertTypeCauseDao dao;

	public AlertTypeCause getByTypeCauseId(Long alertTypeId, Long alertCauseId) {
		return dao.getByTypeCauseId(alertTypeId, alertCauseId);
	}

	@Override
	protected BaseEntityDAO<AlertTypeCause, Long> getDao() {
		return dao;
	}

	public void add(AlertTypeCause alertTypeCause) {
		dao.persist(alertTypeCause);
	}

	@Override
	public AlertTypeCause update(AlertTypeCause entity) {
		return dao.update(entity);
	}

}

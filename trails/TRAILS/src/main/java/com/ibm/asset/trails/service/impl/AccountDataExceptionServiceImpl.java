package com.ibm.asset.trails.service.impl;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.dao.DataExceptionTypeDao;
import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.service.AccountDataExceptionService;

@Service
public class AccountDataExceptionServiceImpl extends
		AbstractGenericEntityService<DataException, Long> implements
		AccountDataExceptionService {

	@Autowired
	private DataExceptionTypeDao alertTypeDAO;

	@Transactional(readOnly = true)
	public List<Map<String, String>> getAlertTypeSummary(final Long accountId,
			final String alertTypeType) {
		List<Map<String, String>> list = alertTypeDAO.summary(accountId,
				alertTypeType);
		return list;
	}

	@Override
	protected BaseEntityDAO<DataException, Long> getDao() {
		// TODO Auto-generated method stub
		return null;
	}
}
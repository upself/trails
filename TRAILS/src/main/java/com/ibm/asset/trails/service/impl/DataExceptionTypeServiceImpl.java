package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.dao.DataExceptionTypeDao;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.service.DataExceptionTypeService;

@Service
public class DataExceptionTypeServiceImpl extends
        AbstractGenericEntityService<AlertType, Long> implements
        DataExceptionTypeService {

    @Autowired
    private DataExceptionTypeDao dao;

    @Override
    protected BaseEntityDAO<AlertType, Long> getDao() {
        return dao;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public AlertType findWithAlertCauses(Long plId) {
        return dao.findWithCauses(plId);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<AlertType> list() {
        return dao.list();
    }

	@Override
	public List<AlertType> getAlertTypeForSOMs() {
		return dao.getAlertTypeForSOMs();
	}

}

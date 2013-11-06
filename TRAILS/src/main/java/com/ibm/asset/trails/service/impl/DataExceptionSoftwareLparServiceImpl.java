package com.ibm.asset.trails.service.impl;

import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionDao;
import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.dao.DataExceptionTypeDao;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.service.DataExceptionService;

@Service
public class DataExceptionSoftwareLparServiceImpl implements
        DataExceptionService {

    private DataExceptionDao alertSoftwareLparDao;

    @Autowired
    private DataExceptionTypeDao alertTypeDao;

    private DataExceptionHistoryDao alertHistoryDao;
    private String alertTypeCode;

    public String getAlertTypeCode() {
        return alertTypeCode;
    }

    public DataExceptionDao getAlertSoftwareLparDao() {
        return alertSoftwareLparDao;
    }

    public void setAlertSoftwareLparDao(DataExceptionDao alertSoftwareLparDao) {
        this.alertSoftwareLparDao = alertSoftwareLparDao;
    }

    public DataExceptionTypeDao getAlertTypeDao() {
        return alertTypeDao;
    }

    public void setAlertTypeDao(DataExceptionTypeDao alertTypeDao) {
        this.alertTypeDao = alertTypeDao;
    }

    public DataExceptionHistoryDao getAlertHistoryDao() {
        return alertHistoryDao;
    }

    public void setAlertHistoryDao(DataExceptionHistoryDao alertHistoryDao) {
        this.alertHistoryDao = alertHistoryDao;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<? extends DataException> paginatedList(Account account,
            int firstResult, int maxResults, String sortBy, String sortDirection) {

        List<? extends DataException> list = alertSoftwareLparDao
                .paginatedList(account, firstResult, maxResults, sortBy,
                        sortDirection);

        return list;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public long getAlertListSize(Account account, AlertType alertType) {
        return alertSoftwareLparDao.getAlertQtyByAccountAlertType(account,
                alertType);
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void updateAssignment(DataException alert, String sessionUser,
            String comments, boolean assign) {

        if (assign) {
            alert.setAssignee(sessionUser);
        } else {
            alert.setAssignee(null);
        }

        alert.setRemoteUser(sessionUser);
        alert.setComment(comments);
        alert.setRecordTime(new Date());

        alertSoftwareLparDao.update(alert);

    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public DataExceptionSoftwareLpar getById(long id) {
        return (DataExceptionSoftwareLpar) alertSoftwareLparDao.getById(id);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public AlertType getAlertType() {
        return alertTypeDao.getAlertTypeByCode(alertSoftwareLparDao
                .getAlertTypeCode());
    }

    public void setAlertTypeCode(String alertTypeCode) {
        this.alertTypeCode = alertTypeCode;
        alertSoftwareLparDao.setAlertTypeCode(alertTypeCode);
    }
}

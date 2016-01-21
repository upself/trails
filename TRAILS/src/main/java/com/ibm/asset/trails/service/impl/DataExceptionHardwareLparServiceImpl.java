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
import com.ibm.asset.trails.domain.DataExceptionHardwareLpar;
import com.ibm.asset.trails.domain.AlertType;
import com.ibm.asset.trails.domain.DataExceptionHistory;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.service.DataExceptionService;

@Service
public class DataExceptionHardwareLparServiceImpl implements
        DataExceptionService {

    private DataExceptionDao alertHardwareLparDao;

    @Autowired
    private DataExceptionTypeDao alertTypeDao;

    private DataExceptionHistoryDao alertHistoryDao;
    private String alertTypeCode;

    public String getAlertTypeCode() {
        return alertTypeCode;
    }

    public DataExceptionDao getAlertHardwareLparDao() {
        return alertHardwareLparDao;
    }

    public void setAlertHardwareLparDao(DataExceptionDao alertHardwareLparDao) {
        this.alertHardwareLparDao = alertHardwareLparDao;
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

        List<? extends DataException> list = alertHardwareLparDao
                .paginatedList(account, firstResult, maxResults, sortBy,
                        sortDirection);

        return list;
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public long getAlertListSize(Account account, AlertType alertType) {
        return alertHardwareLparDao.getAlertQtyByAccountAlertType(account,
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

        alertHardwareLparDao.update(alert);

    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public DataExceptionHardwareLpar getById(long id) {
        return (DataExceptionHardwareLpar) alertHardwareLparDao.getById(id);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public AlertType getAlertType() {
        return alertTypeDao.getAlertTypeByCode(alertHardwareLparDao
                .getAlertTypeCode());
    }

    public void setAlertTypeCode(String alertTypeCode) {
        this.alertTypeCode = alertTypeCode;
        alertHardwareLparDao.setAlertTypeCode(alertTypeCode);
    }

	@Override
	public void assign(List<Long> list, String remoteUser, String comments) {
		for(Long dataExpId: list){
			DataExceptionHardwareLpar dataExpSwLpar = (DataExceptionHardwareLpar) alertHardwareLparDao.getById(dataExpId);
            this.updateAssignmentAndCreateHistory(dataExpSwLpar, remoteUser,comments, true);
        }	
	}

	@Override
	public void unassign(List<Long> alertIds, String remoteUser, String comments) {
		for(Long dataExpId: alertIds){
			DataExceptionHardwareLpar dataExpSwLpar = (DataExceptionHardwareLpar) alertHardwareLparDao.getById(dataExpId);
            this.updateAssignmentAndCreateHistory(dataExpSwLpar, remoteUser,comments, false);
        }
	}

	@Override
	public void assignAll(Long customerId, String dataExpTypeCode,
			String remoteUser, String comments) {
		Long alertTypeId = alertTypeDao.getAlertTypeByCode(dataExpTypeCode).getId();
	      List<Long> dataExpIds = alertHardwareLparDao.getOpenAlertIdsByCustomerIdAndAlertTypeId(customerId, alertTypeId);
	      for(Long dataExpId: dataExpIds){
	    	  DataExceptionHardwareLpar dataExpHwLpar = (DataExceptionHardwareLpar) alertHardwareLparDao.getById(dataExpId);
	         this.updateAssignmentAndCreateHistory(dataExpHwLpar, remoteUser,comments, true);  
	      }
	}

	@Override
	public void unassignAll(Long customerId, String dataExpTypeCode,
			String remoteUser, String comments) {
		Long alertTypeId = alertTypeDao.getAlertTypeByCode(dataExpTypeCode).getId();
	      List<Long> dataExpIds = alertHardwareLparDao.getOpenAlertIdsByCustomerIdAndAlertTypeId(customerId, alertTypeId);
	      for(Long dataExpId: dataExpIds){
	    	  DataExceptionHardwareLpar dataExpHwLpar = (DataExceptionHardwareLpar) alertHardwareLparDao.getById(dataExpId);
	         this.updateAssignmentAndCreateHistory(dataExpHwLpar, remoteUser,comments, false);  
	      }		
	}

	@Override
	public void updateAssignmentAndCreateHistory(DataException alert,
			String sessionUser, String comments, boolean assign) {
		
		DataExceptionHistory alertHistory = this.transformToHistory(alert);
		alertHistoryDao.save(alertHistory);
		
		if (assign) {
            alert.setAssignee(sessionUser);
        } else {
            alert.setAssignee(null);
        }

        alert.setRemoteUser(sessionUser);
        alert.setComment(comments);
        alert.setRecordTime(new Date());

        alertHardwareLparDao.update(alert);
	}
	
	private DataExceptionHistory transformToHistory(DataException alert) {

		DataExceptionHistory alertHistory = new DataExceptionHistory();
		alertHistory.setAccount(alert.getAccount());
		alertHistory.setAlert(alert);
		alertHistory.setAlertCause(alert.getAlertCause());
		alertHistory.setAlertType(alert.getAlertType());
		alertHistory.setAssignee(alert.getAssignee());
		alertHistory.setComment(alert.getComment());
		alertHistory.setCreationTime(alert.getCreationTime());
		alertHistory.setOpen(alert.isOpen());
		alertHistory.setRecordTime(alert.getRecordTime());
		alertHistory.setRemoteUser(alert.getRemoteUser());

		return alertHistory;
	}
}

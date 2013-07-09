package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionDao;
import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.domain.DataException;
import com.ibm.asset.trails.domain.DataExceptionHistory;
import com.ibm.asset.trails.domain.DataExceptionSoftwareLpar;
import com.ibm.asset.trails.domain.DataExceptionHardwareLpar;
import com.ibm.asset.trails.service.DataExceptionHistoryService;

@Service
public class DataExceptionHistoryServiceImpl implements
		DataExceptionHistoryService {

	private DataExceptionDao alertLparDao;

	private DataExceptionHistoryDao alertHistoryDao;

	private String lparType;

	public void setAlertHistoryDao(DataExceptionHistoryDao alertHistoryDao) {
		this.alertHistoryDao = alertHistoryDao;
	}

	public void setAlertLparDao(DataExceptionDao alertLparDao) {
		this.alertLparDao = alertLparDao;
	}
	
	public void setLparType(String lparType) {
		this.lparType = lparType;
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<DataExceptionHistory> getHistory(Long alertId) {

		List<DataExceptionHistory> list = alertHistoryDao.getByAlertId(alertId);
		if (lparType.equalsIgnoreCase("Hwlpar")) {
			DataExceptionHardwareLpar hwlparAlert = (DataExceptionHardwareLpar) alertLparDao
					.getById(alertId);
			DataExceptionHistory history = transformToHistory(hwlparAlert);
			list.add(history);
		}
		if (lparType.equalsIgnoreCase("Swlpar")) {
			DataExceptionSoftwareLpar swlparAlert = (DataExceptionSoftwareLpar) alertLparDao
					.getById(alertId);
			DataExceptionHistory history = transformToHistory(swlparAlert);
			list.add(history);
		}

		return list;
	}

	public DataExceptionHistory transformToHistory(DataException alert) {

		DataExceptionHistory history = new DataExceptionHistory();
		history.setAccount(alert.getAccount());
		history.setAlert(alert);
		history.setAlertCause(alert.getAlertCause());
		history.setAlertType(alert.getAlertType());
		history.setAssignee(alert.getAssignee());
		history.setComment(alert.getComment());
		history.setCreationTime(alert.getCreationTime());
		history.setOpen(alert.isOpen());
		history.setRecordTime(alert.getRecordTime());
		history.setRemoteUser(alert.getRemoteUser());

		return history;
	}

	@Transactional(readOnly = false, propagation = Propagation.SUPPORTS)
	public void save(DataExceptionHistory history) {
		alertHistoryDao.save(history);
	}

}

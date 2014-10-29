package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionCauseDao;
import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.domain.AlertCauseResponsibility;
import com.ibm.asset.trails.domain.AlertTypeCause;
import com.ibm.asset.trails.service.DataExceptionCauseService;
import com.opensymphony.xwork2.validator.ValidationException;

@Service
public class DataExceptionCauseServiceImpl implements DataExceptionCauseService {
	private DataExceptionCauseDao alertCauseDao;

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public AlertCause find(Long plId) {
		return getAlertCauseDao().find(plId);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public AlertCause findByNameResposibility(String alertCauseName,
			AlertCauseResponsibility responsibility) {
		return getAlertCauseDao().find(alertCauseName, responsibility);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<AlertTypeCause> getAlertCauseListByIdList(
			List<Long> plAlertCauseId) {
		return getAlertCauseDao().getAlertCauseListByIdList(plAlertCauseId);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<AlertTypeCause> getAvailableAlertCauseList(List<Long> plId) {
		return getAlertCauseDao().getAvailableAlertCauseList(plId);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<AlertTypeCause> list() {
		return getAlertCauseDao().list();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public List<AlertTypeCause> listWithTypeJoin() {
		return getAlertCauseDao().listWithTypeJoin();
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public String save(Long plId, String psName) throws ValidationException {
		AlertCause lacSave = null;

		if (plId == null) { // Adding a new AlertCause
			lacSave = new AlertCause();
			if (getAlertCauseDao().find(psName) != null) {
				throw new ValidationException(
						"A cause code with this name already exists.");
			}

			lacSave.setName(psName);
			lacSave.setShowInGui(true);
			getAlertCauseDao().add(lacSave);
			return "The cause code was added successfully.";
		} else { // Updating an existing AlertCause
			lacSave = find(plId);
			if (lacSave == null) {
				throw new ValidationException(
						"Could not find the current cause code.");
			} else if (find(psName, plId) != null) {
				throw new ValidationException(
						"A cause code with this name already exists.");
			}

			lacSave.setName(psName);
			getAlertCauseDao().update(lacSave);
			return "The cause code was updated successfully.";
		}
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	private AlertCause find(String psName, Long plId) {
		return getAlertCauseDao().find(psName, plId);
	}

	public void update(AlertCause alertCause) {
		alertCauseDao.update(alertCause);
	}

	public void save(AlertCause alertCause) {
		alertCauseDao.add(alertCause);
	}

	public AlertCause findByName(String alertCauseName) {
		return alertCauseDao.find(alertCauseName);
	}

	public DataExceptionCauseDao getAlertCauseDao() {
		return alertCauseDao;
	}

	public void setAlertCauseDao(DataExceptionCauseDao alertCauseDao) {
		this.alertCauseDao = alertCauseDao;
	}

}

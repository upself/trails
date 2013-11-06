package com.ibm.asset.trails.service.impl;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionCauseDao;
import com.ibm.asset.trails.domain.AlertCause;
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
    public List<AlertCause> getAlertCauseListByIdList(
            List<Long> plAlertCauseId) {
        return getAlertCauseDao().getAlertCauseListByIdList(plAlertCauseId);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<AlertCause> getAvailableAlertCauseList(List<Long> plId) {
        return getAlertCauseDao().getAvailableAlertCauseList(plId);
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<AlertCause> list() {
        return getAlertCauseDao().list();
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

    public DataExceptionCauseDao getAlertCauseDao() {
        return alertCauseDao;
    }

    public void setAlertCauseDao(DataExceptionCauseDao alertCauseDao) {
        this.alertCauseDao = alertCauseDao;
    }
}

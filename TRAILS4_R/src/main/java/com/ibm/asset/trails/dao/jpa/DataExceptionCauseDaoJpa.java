package com.ibm.asset.trails.dao.jpa;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionCauseDao;
import com.ibm.asset.trails.domain.DataExceptionCause;

@Transactional
@Repository
public class DataExceptionCauseDaoJpa extends AbstractDataExceptionJpa
        implements DataExceptionCauseDao {

    public void add(DataExceptionCause pacAdd) {
        getEntityManager().persist(pacAdd);
    }

    public DataExceptionCause find(Long plId) {
        return getEntityManager().find(DataExceptionCause.class, plId);
    }

    public DataExceptionCause find(String psName) {
        @SuppressWarnings("unchecked")
        List<DataExceptionCause> results = getEntityManager()
                .createNamedQuery("findAlertCauseByName")
                .setParameter("name", psName).getResultList();
        DataExceptionCause result;
        if (results == null || results.isEmpty()) {
            result = null;
        } else {
            result = results.get(0);
        }
        return result;
    }

    public DataExceptionCause find(String psName, Long plId) {
        @SuppressWarnings("unchecked")
        List<DataExceptionCause> results = getEntityManager()
                .createNamedQuery("findAlertCauseByNameNotId")
                .setParameter("name", psName).setParameter("id", plId)
                .getResultList();
        DataExceptionCause result;
        if (results == null || results.isEmpty()) {
            result = null;
        } else {
            result = results.get(0);
        }
        return result;
    }

    @SuppressWarnings("unchecked")
    public List<DataExceptionCause> getAlertCauseListByIdList(
            List<Long> plAlertCauseId) {
        if (plAlertCauseId.size() == 0) {
            return new ArrayList<DataExceptionCause>();
        } else {
            return getEntityManager()
                    .createNamedQuery("getAlertCauseListByIdList")
                    .setParameter("idList", plAlertCauseId).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    public List<DataExceptionCause> getAvailableAlertCauseList(List<Long> plId) {
        if (plId.size() == 0) {
            return getEntityManager().createNamedQuery("getAlertCauseList")
                    .getResultList();
        } else {
            return getEntityManager()
                    .createNamedQuery("getAvailableAlertCauseList")
                    .setParameter("idList", plId).getResultList();
        }
    }

    @SuppressWarnings("unchecked")
    public List<DataExceptionCause> list() {
        return getEntityManager().createNamedQuery("getAlertCauseList")
                .getResultList();
    }

    public void update(DataExceptionCause pacUpdate) {
        getEntityManager().merge(pacUpdate);
    }
}

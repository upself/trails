package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionHistoryDao;
import com.ibm.asset.trails.domain.DataExceptionHistory;

@Transactional(readOnly = true)
@Repository
public class DataExceptionHistoryDaoJpa extends AbstractDataExceptionJpa
        implements DataExceptionHistoryDao {

    @Transactional(propagation = Propagation.REQUIRED, readOnly = false)
    public void save(DataExceptionHistory history) {
        getEntityManager().persist(history);
        getEntityManager().flush();
    }

    @SuppressWarnings("unchecked")
    public List<DataExceptionHistory> getByAlertId(Long alertId) {
        return getEntityManager().createNamedQuery("getAlertHistoryByAlertId")
                .setParameter("alertId", alertId).getResultList();
    }
}

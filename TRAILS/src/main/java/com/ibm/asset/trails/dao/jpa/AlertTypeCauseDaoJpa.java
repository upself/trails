package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.AlertTypeCauseDao;
import com.ibm.asset.trails.domain.AlertTypeCause;

@Repository
public class AlertTypeCauseDaoJpa extends
		AbstractGenericEntityDAOJpa<AlertTypeCause, Long> implements
		AlertTypeCauseDao {

	public AlertTypeCause getByTypeCauseId(Long alertTypeId, Long alertCauseId) {
		@SuppressWarnings("unchecked")
		List<AlertTypeCause> list = entityManager
				.createNamedQuery("getByATCTypeCauseId")
				.setParameter("alertTypeId", alertTypeId)
				.setParameter("alertCauseId", alertCauseId).getResultList();

		if (list.size() == 0) {
			return null;
		}

		return list.get(0);
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public AlertTypeCause update(AlertTypeCause entity) {
		AlertTypeCause alertTypeCause = entityManager.merge(entity);
		entityManager.flush();
		return alertTypeCause;
	}

	@Transactional(readOnly = false, propagation = Propagation.REQUIRED)
	public void persist(AlertTypeCause entity) {
		entityManager.persist(entity);
		entityManager.flush();
	}
}

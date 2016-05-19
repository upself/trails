package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.FlushModeType;
import javax.persistence.PersistenceContext;

import com.ibm.asset.trails.dao.ScheduleFDao;
import com.ibm.asset.trails.domain.ScheduleF;

public class ScheduleFDaoJpa implements ScheduleFDao{

	protected EntityManager entityManager;

	@PersistenceContext
	public void setEntityManager(EntityManager entityManager) {
		entityManager.setFlushMode(FlushModeType.COMMIT);
		this.entityManager = entityManager;
	}

	public EntityManager getEntityManager() {
		return entityManager;
	}
	
	public void merge(ScheduleF entity) {
	    getEntityManager().merge(entity);
	}
	
	public List<ScheduleF> findBySwId(Long id) {
		@SuppressWarnings("unchecked")
		List<ScheduleF> list = getEntityManager()
				.createQuery(
						"SELECT ScheduleF h where h.softwareId = :swid")
				.setParameter("swid", id)
				.setHint("org.hibernate.cacheable", Boolean.TRUE)
				.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list;
		}
	}
}

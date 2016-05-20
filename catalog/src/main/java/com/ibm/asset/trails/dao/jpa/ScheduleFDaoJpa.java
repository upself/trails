package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.FlushModeType;
import javax.persistence.PersistenceContext;
import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ScheduleFDao;
import com.ibm.asset.trails.domain.ScheduleF;

@Repository
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
		List<ScheduleF> list = getEntityManager().createNamedQuery("findScheduleFById").setParameter("sfid",895941L)
				.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list;
		}
	}
	
	public void findswByNaturalKey(Long key) {}
}

package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.criteria.CriteriaBuilder;
import javax.persistence.criteria.CriteriaQuery;
import javax.persistence.criteria.Root;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.PidDao;
import com.ibm.asset.trails.domain.Pid;
import com.ibm.asset.trails.domain.Pid_;

@Repository
public class PidDaoJpa extends DaoJpa<Pid, Long> implements PidDao {

	public Pid findByNaturalKey(String pid) {
		CriteriaBuilder builder = entityManager.getCriteriaBuilder();
		CriteriaQuery<Pid> criteria = builder.createQuery(Pid.class);
		Root<Pid> pidRoot = criteria.from(Pid.class);
		criteria.select(pidRoot);
		criteria.where(builder.equal(pidRoot.get(Pid_.pid), pid));
		List<Pid> pids = entityManager.createQuery(criteria)
				.setHint("org.hibernate.cacheable", Boolean.TRUE)
				.getResultList();
		if (pids == null || pids.isEmpty()) {
			return null;
		}
		return pids.get(0);
	}

	public Pid findByNaturalKey(Object... key) {
		// Unimplemented
		return null;
	}

	public Long findIdByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

}

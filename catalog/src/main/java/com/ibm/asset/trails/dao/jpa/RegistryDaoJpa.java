package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.RegistryDao;
import com.ibm.asset.trails.domain.Registry;

@Repository
public class RegistryDaoJpa extends DaoJpa<Registry, Long> implements
		RegistryDao {

	public Registry findByNaturalKey(Object... key) {
		Query q;
		if (key[1] == null) {
			q = getEntityManager()
					.createQuery(
							"SELECT h FROM Registry h where h.key = :key and h.value is null")
					.setParameter("key", key[0])
					.setHint("org.hibernate.cacheable", Boolean.TRUE);
		} else {
			q = getEntityManager()
					.createQuery(
							"SELECT h FROM Registry h where h.key = :key and h.value = :value")
					.setParameter("key", key[0]).setParameter("value", key[1])
					.setHint("org.hibernate.cacheable", Boolean.TRUE);
		}
		@SuppressWarnings("unchecked")
		List<Registry> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

	public Long findIdByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

}

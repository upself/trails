package com.ibm.asset.trails.dao.jpa;

import java.io.Serializable;
import java.util.Date;
import java.util.List;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import com.ibm.asset.trails.dao.KbDefinitionDao;
import com.ibm.asset.trails.domain.KbDefinition;

public abstract class KbDefinitionDaoJpa<E extends KbDefinition, I extends Serializable>
		extends DaoJpa<E, I> implements KbDefinitionDao<E, I> {

	public final Date findMaxModificationDate() {
		Query q = entityManager
				.createQuery("select max(k.modifiedDate) from KbDefinition k");
		try {
			return (Date) q.getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

	public final E findByNaturalKey(Object... key) {
		Query q = getEntityManager()
				.createQuery(
						"SELECT h FROM " + entityClass.getName()
								+ " h where h.guid = :guid")
				.setParameter("guid", key[0])
				.setHint("org.hibernate.cacheable", Boolean.TRUE);
		@SuppressWarnings("unchecked")
		List<E> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

	public final I findIdByNaturalKey(Object... key) {
		Query q = getEntityManager()
				.createQuery(
						"SELECT h.id FROM " + entityClass.getName()
								+ " h where h.guid = :guid")
				.setParameter("guid", key[0])
				.setHint("org.hibernate.cacheable", Boolean.TRUE);
		@SuppressWarnings("unchecked")
		List<I> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}
}

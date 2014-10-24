package com.ibm.asset.trails.dao.jpa;

import java.util.Date;
import java.util.List;

import javax.persistence.NoResultException;
import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.ibm.asset.swkbt.schema.PlatformsEnum;
import com.ibm.asset.trails.dao.PlatformDao;
import com.ibm.asset.trails.domain.Platform;

@Repository
public class PlatformDaoJpa extends DaoJpa<Platform, Long> implements
		PlatformDao {

	public Platform findByName(PlatformsEnum platformEnum) {
		Query q = getEntityManager()
				.createQuery(
						"SELECT h FROM Platform h where h.name = :platformEnum")
				.setParameter("platformEnum", platformEnum)
				.setHint("org.hibernate.cacheable", Boolean.TRUE);
		@SuppressWarnings("unchecked")
		List<Platform> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

	public Platform findByNaturalKey(Object... key) {
		Query q = getEntityManager()
				.createQuery(
						"SELECT h FROM Platform h where h.swkbtId = :swkbtId")
				.setParameter("swkbtId", key[0])
				.setHint("org.hibernate.cacheable", Boolean.TRUE);
		try {
			return (Platform) q.getSingleResult();
		} catch (NoResultException e) {
			return null;
		}
	}

	public Long findIdByNaturalKey(Object... key) {
		Query q = getEntityManager()
				.createQuery(
						"SELECT h.id FROM Platform h where h.name = :platformEnum")
				.setParameter("platformEnum", key[0])
				.setHint("org.hibernate.cacheable", Boolean.TRUE);
		@SuppressWarnings("unchecked")
		List<Long> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

	public Long findIdBySwkbtId(int swkbtId) {
		Query q = getEntityManager()
				.createQuery(
						"SELECT h.id FROM Platform h where h.swkbtId = :swkbtId")
				.setParameter("swkbtId", swkbtId)
				.setHint("org.hibernate.cacheable", Boolean.TRUE);
		@SuppressWarnings("unchecked")
		List<Long> list = q.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}
}

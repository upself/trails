package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.VersionDao;
import com.ibm.asset.trails.domain.Version;

@Repository
public class VersionDaoJpa extends SoftwareItemDaoJpa<Version, Long> implements
		VersionDao {

	public Version findByNaturalKey(String key) {
		@SuppressWarnings("unchecked")
		List<Version> list = getEntityManager()
				.createQuery(
						"SELECT h FROM Version h left join fetch h.pids where h.guid = :key")
				.setParameter("guid", key)
				.setHint("org.hibernate.cacheable", Boolean.TRUE)
				.getResultList();
		if (list == null || list.isEmpty()) {
			return null;
		} else {
			return list.get(0);
		}
	}

}

package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ReleaseDao;
import com.ibm.asset.trails.domain.Release;

@Repository
public class ReleaseDaoJpa extends SoftwareItemDaoJpa<Release, Long> implements
		ReleaseDao {

	public Release findByNaturalKey(String key) {
		@SuppressWarnings("unchecked")
		List<Release> list = getEntityManager()
				.createQuery(
						"SELECT h FROM Release h left join fetch h.cVersionId left join fetch h.pids where h.guid = :key")
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

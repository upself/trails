package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.PartNumberDao;
import com.ibm.asset.trails.domain.PartNumber;

@Repository
public class PartNumberDaoJpa extends KbDefinitionDaoJpa<PartNumber, Long>
		implements PartNumberDao {

	public PartNumber findByNaturalKey(String key) {
		@SuppressWarnings("unchecked")
		List<PartNumber> list = getEntityManager()
				.createQuery(
						"SELECT h FROM PartNumber h left join fetch h.pids where guid = :key")
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

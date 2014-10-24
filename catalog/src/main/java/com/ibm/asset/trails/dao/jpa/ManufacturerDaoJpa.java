package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ManufacturerDao;
import com.ibm.asset.trails.domain.Manufacturer;

@Repository
public class ManufacturerDaoJpa extends KbDefinitionDaoJpa<Manufacturer, Long>
		implements ManufacturerDao {

	public Manufacturer findByNaturalKey(String key) {
		@SuppressWarnings("unchecked")
		List<Manufacturer> list = getEntityManager()
				.createQuery(
						"SELECT h FROM Manufacturer h left join fetch h.alias where guid = :key")
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

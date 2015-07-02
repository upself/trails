package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ManufacturerDAO;
import com.ibm.asset.trails.domain.Manufacturer;

@Repository
public class ManufacturerDAOJap extends
		AbstractGenericEntityDAOJpa<Manufacturer, Long> implements
		ManufacturerDAO {

	@SuppressWarnings("unchecked")
	public List<Manufacturer> findByNameLike(String name) {
		return (List<Manufacturer>) entityManager
				.createNamedQuery("manufacturerByNameLike")
				.setParameter("name", name).getResultList();
	}
}

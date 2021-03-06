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

	@Override
	public Manufacturer findManufacturerByName(String name) {
		// TODO Auto-generated method stub
		@SuppressWarnings("unchecked")
		List<Manufacturer> list = entityManager
				.createNamedQuery("manufacturerByName")
				.setParameter("name", name.toUpperCase()).getResultList();

		if (list.size() == 0) {
			return null;
		}

		return list.get(0);

	}
	
	@Override
	public List<Manufacturer> findManufacturerListbyName(String name) {
		// TODO Auto-generated method stub
		@SuppressWarnings("unchecked")
		List<Manufacturer> list = entityManager
				.createNamedQuery("manufacturerListByName")
				.setParameter("name", name.toUpperCase()).getResultList();
		if (list.size() == 0) {
		return null;
		} else {
		return list;
		}
	}
}

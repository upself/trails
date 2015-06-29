package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ManufacturerDAO;
import com.ibm.asset.trails.domain.Manufacturer;

@Repository
public class ManufacturerDAOJap extends
		AbstractGenericEntityDAOJpa<Manufacturer, Long> implements
		ManufacturerDAO {
}

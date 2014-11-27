package com.ibm.asset.trails.dao.jpa;

import javax.persistence.Query;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.Software;

@Repository
public class SoftwareDAOJpa extends AbstractGenericEntityDAOJpa<Software, Long>
		implements SoftwareDAO {

	public Software getSoftwareDetails(Long softwareId) {
		Query lQuery = entityManager.createNamedQuery("softwareDetail");

		lQuery.setParameter("softwareId", softwareId);

		return (Software) lQuery.getSingleResult();
	}

	public Manufacturer getManufacturerBySoftwareId(Long manufacturerId) {
		return (Manufacturer) entityManager
				.createQuery(
						"FROM Manufacturer m where m.id  = :manufacturerId")
				.setParameter("manufacturerId", manufacturerId).getSingleResult();
	}

}

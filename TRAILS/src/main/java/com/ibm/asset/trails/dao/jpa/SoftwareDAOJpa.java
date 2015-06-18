package com.ibm.asset.trails.dao.jpa;

import java.util.List;

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

	  @SuppressWarnings("unchecked")
	    public List<Software> findSoftwareBySoftwareName(String softwareName) {
	        return entityManager.createNamedQuery("softwareBySoftwareName")
	                .setParameter("name", softwareName.toUpperCase())
	                .getResultList();
	    }
	  
	  @SuppressWarnings("unchecked")
	    public List<Software> findInactiveSoftwareBySoftwareName(String softwareName) {
	        return entityManager.createNamedQuery("inactiveSoftwareBySoftwareName")
	                .setParameter("name", softwareName.toUpperCase())
	                .getResultList();
	    }


}

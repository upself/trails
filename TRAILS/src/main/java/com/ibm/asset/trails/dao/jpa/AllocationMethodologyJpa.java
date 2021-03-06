package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.AllocationMethodologyDao;
import com.ibm.asset.trails.domain.AllocationMethodology;

@Repository
public class AllocationMethodologyJpa extends
		AbstractGenericEntityDAOJpa<AllocationMethodology, Long> implements
		AllocationMethodologyDao {

	public AllocationMethodology findByCode(String code) {
		return (AllocationMethodology) entityManager
				.createNamedQuery("findAllocationMethodologyByCode")
				.setParameter("code", code).getSingleResult();
	}

}

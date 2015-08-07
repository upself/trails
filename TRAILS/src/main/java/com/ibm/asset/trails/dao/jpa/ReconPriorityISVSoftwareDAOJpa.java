package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ReconPriorityISVSoftwareDAO;
import com.ibm.asset.trails.domain.ReconPriorityISVSoftware;

@Repository
public class ReconPriorityISVSoftwareDAOJpa extends
		AbstractGenericEntityDAOJpa<ReconPriorityISVSoftware, Long> implements
		ReconPriorityISVSoftwareDAO {

	@SuppressWarnings("unchecked")
	@Override
	public ReconPriorityISVSoftware findReconPriorityISVSoftwareByUniqueKeys(
			Long manufacturerId, Long customerId) {
		List<ReconPriorityISVSoftware> results;
		 
		if(customerId == null){
	       results = entityManager
		                .createNamedQuery("findReconPriorityISVSoftwareByUniqueKeys1")
		                .setParameter("manufacturerId", manufacturerId).getResultList();
	    }
		else{
		   results = entityManager
	                .createNamedQuery("findReconPriorityISVSoftwareByUniqueKeys2")
	                .setParameter("customerId", customerId)
	                .setParameter("manufacturerId", manufacturerId)
	                .getResultList();
		}
		
	    ReconPriorityISVSoftware result;
        if (results == null || results.isEmpty()) {
            result = null;
        } else {
            result = results.get(0);
        }
        return result;
	}
}

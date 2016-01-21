package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ReconLicenseDAO;
import com.ibm.asset.trails.domain.ReconLicense;

@Repository
public class ReconLicenseDaoJpa extends AbstractGenericEntityDAOJpa<ReconLicense, Long>
implements ReconLicenseDAO  {

	@Override
	public ReconLicense getExistingReconLicense(Long licenseId) {

		@SuppressWarnings("unchecked")		
		List<ReconLicense> results =  entityManager.createNamedQuery("getExistingReconLicense")
				.setParameter("licenseId", licenseId).getResultList();
		ReconLicense result;
		if (results == null || results.isEmpty()) {
			result = null;
		} else {
			result = results.get(0);
		}
		return result;
	
	}

}

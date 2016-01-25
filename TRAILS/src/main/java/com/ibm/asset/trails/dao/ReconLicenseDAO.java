package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.ReconLicense;

public  interface ReconLicenseDAO extends BaseEntityDAO<ReconLicense, Long> {	
	ReconLicense getExistingReconLicense(Long licenseId);
}

package com.ibm.asset.trails.dao;

import com.ibm.asset.trails.domain.InstalledSignature;

public interface InstalledSignatureDao extends
		BaseDao<InstalledSignature, Long> {

	Long hitCount(Long id);

	Boolean signatureExists(String fileName, Integer fileSize);
}

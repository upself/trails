package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.InstallRegistrySignatureDao;
import com.ibm.asset.trails.domain.InstallRegistrySignature;

@Repository
public class InstallRegistrySignatureDaoJpa extends
		SignatureDaoJpa<InstallRegistrySignature, Long> implements
		InstallRegistrySignatureDao {

}

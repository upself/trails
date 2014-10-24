package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ApplicationServerSignatureDao;
import com.ibm.asset.trails.domain.ApplicationServerSignature;

@Repository
public class ApplicationServerSignatureDaoJpa extends
		SignatureDaoJpa<ApplicationServerSignature, Long> implements
		ApplicationServerSignatureDao {

}

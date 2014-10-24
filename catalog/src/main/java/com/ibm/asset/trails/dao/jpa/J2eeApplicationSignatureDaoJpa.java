package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.J2eeApplicationSignatureDao;
import com.ibm.asset.trails.domain.J2EeApplicationSignature;

@Repository
public class J2eeApplicationSignatureDaoJpa extends
		SignatureDaoJpa<J2EeApplicationSignature, Long> implements
		J2eeApplicationSignatureDao {

}

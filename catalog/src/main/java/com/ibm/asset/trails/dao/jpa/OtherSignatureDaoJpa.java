package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.OtherSignatureDao;
import com.ibm.asset.trails.domain.OtherSignature;

@Repository
public class OtherSignatureDaoJpa extends SignatureDaoJpa<OtherSignature, Long>
		implements OtherSignatureDao {

}

package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.XslmIdSignatureDao;
import com.ibm.asset.trails.domain.XslmIdSignature;

@Repository
public class XslmIdSignatureDaoJpa extends
		SignatureDaoJpa<XslmIdSignature, Long> implements XslmIdSignatureDao {

}

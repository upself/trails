package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.FilterSignatureDao;
import com.ibm.asset.trails.domain.FilterSignature;

@Repository
public class FilterSignatureDaoJpa extends
		SignatureDaoJpa<FilterSignature, Long> implements FilterSignatureDao {

}

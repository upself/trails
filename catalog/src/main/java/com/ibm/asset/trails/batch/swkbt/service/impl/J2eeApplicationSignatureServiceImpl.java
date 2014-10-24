package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.J2EeApplicationSignatureType;
import com.ibm.asset.trails.batch.swkbt.service.J2eeApplicationSignatureService;
import com.ibm.asset.trails.dao.J2eeApplicationSignatureDao;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.J2EeApplicationSignature;

@Service
public class J2eeApplicationSignatureServiceImpl
		extends
		SignatureServiceImpl<J2EeApplicationSignature, J2EeApplicationSignatureType, Long>
		implements J2eeApplicationSignatureService {

	@Autowired
	private J2eeApplicationSignatureDao dao;

	public void save(J2EeApplicationSignatureType xmlEntity) {
		J2EeApplicationSignature existing = findByNaturalKey(xmlEntity
				.getGuid());
		if (existing == null) {
			existing = new J2EeApplicationSignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public J2EeApplicationSignature update(J2EeApplicationSignature existing,
			J2EeApplicationSignatureType xmlEntity) {
		super.update(existing, xmlEntity);
		existing.setName(xmlEntity.getName());
		return existing;
	}

	@Override
	public SignatureDao<J2EeApplicationSignature, Long> getDao() {
		return dao;
	}

}

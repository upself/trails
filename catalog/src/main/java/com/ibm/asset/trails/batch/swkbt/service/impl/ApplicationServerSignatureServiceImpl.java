package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.ApplicationServerSignatureType;
import com.ibm.asset.trails.batch.swkbt.service.ApplicationServerSignatureService;
import com.ibm.asset.trails.dao.ApplicationServerSignatureDao;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.ApplicationServerSignature;

@Service
public class ApplicationServerSignatureServiceImpl
		extends
		SignatureServiceImpl<ApplicationServerSignature, ApplicationServerSignatureType, Long>
		implements ApplicationServerSignatureService {

	@Autowired
	private ApplicationServerSignatureDao dao;

	public void save(ApplicationServerSignatureType xmlEntity) {
		ApplicationServerSignature existing = findByNaturalKey(xmlEntity
				.getGuid());
		if (existing == null) {
			existing = new ApplicationServerSignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public ApplicationServerSignature update(
			ApplicationServerSignature existing,
			ApplicationServerSignatureType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setName(xmlEntity.getName());
		return existing;
	}

	@Override
	public SignatureDao<ApplicationServerSignature, Long> getDao() {
		return dao;
	}

}

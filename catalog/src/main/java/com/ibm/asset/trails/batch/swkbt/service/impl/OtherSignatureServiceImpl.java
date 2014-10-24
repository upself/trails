package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.OtherSignatureType;
import com.ibm.asset.trails.batch.swkbt.service.OtherSignatureService;
import com.ibm.asset.trails.dao.OtherSignatureDao;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.OtherSignature;

@Service
public class OtherSignatureServiceImpl extends
		SignatureServiceImpl<OtherSignature, OtherSignatureType, Long>
		implements OtherSignatureService {

	@Autowired
	private OtherSignatureDao dao;

	public void save(OtherSignatureType xmlEntity) {
		OtherSignature existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new OtherSignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public OtherSignature update(OtherSignature existing,
			OtherSignatureType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setBody(xmlEntity.getBody());
		existing.setType(xmlEntity.getType());
		return existing;
	}

	@Override
	public SignatureDao<OtherSignature, Long> getDao() {
		return dao;
	}

}

package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.XslmIdSignatureType;
import com.ibm.asset.trails.batch.swkbt.service.XslmIdSignatureService;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.dao.XslmIdSignatureDao;
import com.ibm.asset.trails.domain.XslmIdSignature;

@Service
public class XslmIdSignatureServiceImpl extends
		SignatureServiceImpl<XslmIdSignature, XslmIdSignatureType, Long>
		implements XslmIdSignatureService {

	@Autowired
	private XslmIdSignatureDao dao;

	public void save(XslmIdSignatureType xmlEntity) {
		XslmIdSignature existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new XslmIdSignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public XslmIdSignature update(XslmIdSignature existing,
			XslmIdSignatureType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setFeatureId(xmlEntity.getFeatureId());
		existing.setProductId(xmlEntity.getProductId());
		existing.setPublisherId(xmlEntity.getPublisherId());
		existing.setVersionId(xmlEntity.getVersionId());
		return existing;
	}

	@Override
	public SignatureDao<XslmIdSignature, Long> getDao() {
		return dao;
	}

}

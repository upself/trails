package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.InstallRegistrySignatureType;
import com.ibm.asset.trails.batch.swkbt.service.InstallRegistrySignatureService;
import com.ibm.asset.trails.dao.InstallRegistrySignatureDao;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.InstallRegistrySignature;

@Service
public class InstallRegistrySignatureServiceImpl
		extends
		SignatureServiceImpl<InstallRegistrySignature, InstallRegistrySignatureType, Long>
		implements InstallRegistrySignatureService {

	@Autowired
	private InstallRegistrySignatureDao dao;

	public void save(InstallRegistrySignatureType xmlEntity) {
		InstallRegistrySignature existing = findByNaturalKey(xmlEntity
				.getGuid());
		if (existing == null) {
			existing = new InstallRegistrySignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public InstallRegistrySignature update(InstallRegistrySignature existing,
			InstallRegistrySignatureType xmlEntity) {
		super.update(existing, xmlEntity);
		existing.setData(xmlEntity.getData());
		existing.setKey(xmlEntity.getKey());
		existing.setSource(xmlEntity.getSource());
		return existing;
	}

	@Override
	public SignatureDao<InstallRegistrySignature, Long> getDao() {
		return dao;
	}

}

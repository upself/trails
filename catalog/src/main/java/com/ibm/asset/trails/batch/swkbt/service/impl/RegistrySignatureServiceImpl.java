package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.RegistrySignatureType;
import com.ibm.asset.trails.batch.swkbt.service.RegistryService;
import com.ibm.asset.trails.batch.swkbt.service.RegistrySignatureService;
import com.ibm.asset.trails.dao.RegistrySignatureDao;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.Registry;
import com.ibm.asset.trails.domain.RegistrySignature;

@Service
public class RegistrySignatureServiceImpl extends
		SignatureServiceImpl<RegistrySignature, RegistrySignatureType, Long>
		implements RegistrySignatureService {

	@Autowired
	private RegistrySignatureDao dao;
	@Autowired
	private RegistryService registryService;

	public void save(RegistrySignatureType xmlEntity) {
		RegistrySignature existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new RegistrySignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public RegistrySignature update(RegistrySignature existing,
			RegistrySignatureType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setOperator(xmlEntity.getOperator());
		Set<Registry> registries = registryService.findFromXmlSet(xmlEntity
				.getRegistry());
		existing.getRegistry().retainAll(registries);
		existing.getRegistry().addAll(registries);
		return existing;
	}

	@Override
	public SignatureDao<RegistrySignature, Long> getDao() {
		return dao;
	}

}

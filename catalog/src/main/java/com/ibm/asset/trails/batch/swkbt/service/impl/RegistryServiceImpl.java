package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.RegistryType;
import com.ibm.asset.trails.batch.swkbt.service.RegistryService;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.dao.RegistryDao;
import com.ibm.asset.trails.domain.Registry;

@Service
public class RegistryServiceImpl extends
		GenericService<Registry, RegistryType, Long> implements RegistryService {

	@Autowired
	private RegistryDao dao;

	public void save(RegistryType xmlEntity) {
		Registry existing = findByNaturalKey(xmlEntity.getKey(),
				xmlEntity.getValue());
		if (existing == null) {
			existing = new Registry();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public Registry update(Registry existing, RegistryType xmlEntity) {
		existing.setKey(xmlEntity.getKey());
		existing.setValue(xmlEntity.getValue());
		existing.setType(xmlEntity.getType());
		return existing;
	}

	public Set<Registry> findFromXmlSet(List<RegistryType> registryTypes) {
		Set<Registry> newRegistries = new HashSet<Registry>();
		for (RegistryType registryType : registryTypes) {
			Registry registry = findByNaturalKey(registryType.getKey(),
					registryType.getValue());
			newRegistries.add(registry);
		}
		return newRegistries;
	}

	@Override
	public BaseDao<Registry, Long> getDao() {
		return dao;
	}

}

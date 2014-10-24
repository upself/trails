package com.ibm.asset.trails.batch.swkbt.service;

import java.util.List;
import java.util.Set;

import com.ibm.asset.swkbt.schema.RegistryType;
import com.ibm.asset.trails.domain.Registry;

public interface RegistryService extends
		BaseService<Registry, RegistryType, Long> {

	Set<Registry> findFromXmlSet(List<RegistryType> registry);

}

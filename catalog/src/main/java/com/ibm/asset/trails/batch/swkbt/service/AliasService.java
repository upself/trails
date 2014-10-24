package com.ibm.asset.trails.batch.swkbt.service;

import java.util.List;
import java.util.Set;

import com.ibm.asset.swkbt.schema.AliasType;
import com.ibm.asset.trails.domain.Alias;

public interface AliasService extends BaseService<Alias, AliasType, Long> {

	Set<Alias> findFromXmlSet(List<AliasType> aliasAndAdditional);

	Set<Alias> findFromXmlObjectSet(List<Object> aliasAndAdditional);

}

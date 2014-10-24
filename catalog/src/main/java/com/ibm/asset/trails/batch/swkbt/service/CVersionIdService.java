package com.ibm.asset.trails.batch.swkbt.service;

import java.util.List;
import java.util.Set;

import com.ibm.asset.swkbt.schema.CVersionIdType;
import com.ibm.asset.trails.domain.CVersionId;

public interface CVersionIdService extends
		BaseService<CVersionId, CVersionIdType, Long> {

	Set<CVersionId> findFromXmlSet(List<CVersionIdType> cVersionId);

}

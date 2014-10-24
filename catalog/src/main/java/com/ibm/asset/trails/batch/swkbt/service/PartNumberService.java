package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.PartNumberType;
import com.ibm.asset.trails.domain.PartNumber;

public interface PartNumberService extends
		KbDefinitionService<PartNumber, PartNumberType, Long> {

}

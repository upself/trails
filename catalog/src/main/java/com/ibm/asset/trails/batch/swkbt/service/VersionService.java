package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.DistributedVersionType;
import com.ibm.asset.trails.domain.Version;

public interface VersionService extends
		SoftwareItemService<Version, DistributedVersionType, Long> {

}

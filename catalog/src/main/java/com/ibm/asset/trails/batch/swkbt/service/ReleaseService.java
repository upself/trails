package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.DistributedReleaseType;
import com.ibm.asset.trails.domain.Release;

public interface ReleaseService extends
		SoftwareItemService<Release, DistributedReleaseType, Long> {
}

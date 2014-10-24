package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.PlatformType;
import com.ibm.asset.trails.domain.Platform;

public interface PlatformService extends
		BaseService<Platform, PlatformType, Long> {

	Long findIdBySwkbtId(int swkbtId);
}

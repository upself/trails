package com.ibm.asset.trails.dao;

import com.ibm.asset.swkbt.schema.PlatformsEnum;
import com.ibm.asset.trails.domain.Platform;

public interface PlatformDao extends BaseDao<Platform, Long> {
	Platform findByName(PlatformsEnum platformsEnum);

	Long findIdBySwkbtId(int swkbtId);
}

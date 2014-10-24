package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;

import com.ibm.asset.swkbt.schema.MainframeVersionType;
import com.ibm.asset.swkbt.schema.SoftwareItemType;
import com.ibm.asset.trails.domain.MainframeVersion;
import com.ibm.asset.trails.domain.SoftwareItem;

public interface MainframeVersionService extends
		SoftwareItemService<MainframeVersion, MainframeVersionType, Long> {

}

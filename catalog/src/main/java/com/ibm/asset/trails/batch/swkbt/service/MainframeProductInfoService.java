package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.MainframeProductType;
import com.ibm.asset.trails.domain.ProductInfo;

public interface MainframeProductInfoService extends
		MainframeProductService<ProductInfo, MainframeProductType, Long> {

	boolean licensableOverrideExists(String guid);

	void addToRecon(ProductInfo pInfo);

}

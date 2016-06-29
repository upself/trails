package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.DistributedProductType;
import com.ibm.asset.trails.domain.ProductInfo;

public interface ProductInfoService extends
		ProductService<ProductInfo, DistributedProductType, Long> {

	void addToRecon(ProductInfo pInfo);

}

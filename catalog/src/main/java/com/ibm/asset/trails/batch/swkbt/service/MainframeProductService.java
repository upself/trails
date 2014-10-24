package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;

import com.ibm.asset.swkbt.schema.MainframeProductType;
import com.ibm.asset.trails.domain.Product;

public interface MainframeProductService<E extends Product, X extends MainframeProductType, I extends Serializable>
		extends SoftwareItemService<E, X, I> {

}

package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;

import com.ibm.asset.swkbt.schema.DistributedProductType;
import com.ibm.asset.trails.domain.Product;

public interface ProductService<E extends Product, X extends DistributedProductType, I extends Serializable>
		extends SoftwareItemService<E, X, I> {

}

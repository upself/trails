package com.ibm.asset.trails.dao;

import java.io.Serializable;

import com.ibm.asset.trails.domain.Product;

public interface ProductDao<E extends Product, I extends Serializable> extends
		SoftwareItemDao<E, I> {

}

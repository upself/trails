package com.ibm.asset.trails.dao.jpa;

import java.io.Serializable;

import com.ibm.asset.trails.dao.ProductDao;
import com.ibm.asset.trails.domain.ProductInfo;

public abstract class ProductDaoJpa<E extends ProductInfo, I extends Serializable>
		extends SoftwareItemDaoJpa<E, I> implements ProductDao<E, I> {

}

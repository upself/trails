package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ProductInfo.class)
public class ProductInfo_ extends Product_ {
	public static volatile SingularAttribute<ProductInfo, SoftwareCategory> softwareCategory;
	public static volatile SingularAttribute<ProductInfo, Integer> priority;
	public static volatile SingularAttribute<ProductInfo, Boolean> licensable;
}

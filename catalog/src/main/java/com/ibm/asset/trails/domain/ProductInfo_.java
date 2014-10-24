package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(ProductInfo.class)
public class ProductInfo_ extends Product_ {
	public static volatile SingularAttribute<ProductInfo, Long> softwareCategoryId;
	public static volatile SingularAttribute<ProductInfo, Integer> priority;
	public static volatile SingularAttribute<ProductInfo, Boolean> licensable;
	public static volatile SingularAttribute<ProductInfo, String> changeJustification;
	public static volatile SingularAttribute<ProductInfo, String> remoteUser;
	public static volatile SingularAttribute<ProductInfo, Date> recordTime;
	public static volatile SingularAttribute<ProductInfo, Recon> recon;
}

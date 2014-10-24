package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(FilterSignature.class)
public class FilterSignature_ extends Signature_ {
	public static volatile SingularAttribute<FilterSignature, String> packageName;
	public static volatile SingularAttribute<FilterSignature, String> packageVendor;
	public static volatile SingularAttribute<FilterSignature, String> packageVersion;
}

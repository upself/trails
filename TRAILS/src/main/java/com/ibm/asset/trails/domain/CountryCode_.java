package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(CountryCode.class)
public class CountryCode_ {
	public static volatile SingularAttribute<CountryCode, Long> id;
	public static volatile SingularAttribute<CountryCode, String> name;
	public static volatile SingularAttribute<CountryCode, String> code;
	public static volatile SingularAttribute<CountryCode, Region> region;
}

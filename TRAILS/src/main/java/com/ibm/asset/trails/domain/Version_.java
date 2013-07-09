package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Version.class)
public class Version_ extends SoftwareItem_ {
	public static volatile SingularAttribute<Version, Manufacturer> manufacturer;
	public static volatile SingularAttribute<Version, String> identifier;
	public static volatile SingularAttribute<Version, Integer> version;
	public static volatile SingularAttribute<Version, Product> product;
}

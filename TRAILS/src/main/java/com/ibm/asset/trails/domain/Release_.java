package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Release.class)
public class Release_ extends SoftwareItem_ {
	public static volatile SingularAttribute<Release, Manufacturer> manufacturer;
	public static volatile SingularAttribute<Release, String> release;
	public static volatile SingularAttribute<Release, String> identifier;
	public static volatile SingularAttribute<Release, Version> version;
}

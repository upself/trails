package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Release.class)
public class Release_ extends SoftwareItem_ {
	public static volatile SetAttribute<Release, CVersionId> cVersionId;
	public static volatile SingularAttribute<Release, String> identifier;
	public static volatile SingularAttribute<Release, Long> manufacturer;
	public static volatile SingularAttribute<Release, String> release;
	public static volatile SingularAttribute<Release, Long> version;
}

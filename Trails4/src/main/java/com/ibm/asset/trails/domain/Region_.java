package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Region.class)
public class Region_ {
	public static volatile SingularAttribute<Region, Long> id;
	public static volatile SingularAttribute<Region, String> name;
	public static volatile SingularAttribute<Region, Geography> geography;
}

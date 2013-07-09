package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Sector.class)
public class Sector_ {
	public static volatile SingularAttribute<Sector, Long> id;
	public static volatile SingularAttribute<Sector, String> name;
}

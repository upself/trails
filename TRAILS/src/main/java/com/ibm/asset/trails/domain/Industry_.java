package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Industry.class)
public class Industry_ {
	public static volatile SingularAttribute<Industry, Long> id;
	public static volatile SingularAttribute<Industry, String> name;
	public static volatile SingularAttribute<Industry, Sector> sector;
}

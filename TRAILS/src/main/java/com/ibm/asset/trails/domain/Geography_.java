package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Geography.class)
public class Geography_ {
	public static volatile SingularAttribute<Geography, Long> id;
	public static volatile SingularAttribute<Geography, String> name;
}

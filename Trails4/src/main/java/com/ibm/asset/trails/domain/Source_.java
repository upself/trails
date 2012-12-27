package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Source.class)
public class Source_ {
	public static volatile SingularAttribute<Source, Long> id;
	public static volatile SingularAttribute<Source, String> description;
}

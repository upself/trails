package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Alias.class)
public class Alias_ {
	public static volatile SingularAttribute<Alias, Long> id;
	public static volatile SingularAttribute<Alias, String> name;
	public static volatile SingularAttribute<Alias, Boolean> preferred;
}

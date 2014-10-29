package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Scope.class)
public class Scope_ {
	public static volatile SingularAttribute<Scope, Long> id;
	public static volatile SingularAttribute<Scope, String> description;
}

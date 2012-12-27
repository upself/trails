package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ReconcileType.class)
public class ReconcileType_ {
	public static volatile SingularAttribute<ReconcileType, Long> id;
	public static volatile SingularAttribute<ReconcileType, String> name;
	public static volatile SingularAttribute<ReconcileType, Boolean> manual;
}

package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Status.class)
public class Status_ {
	public static volatile SingularAttribute<Status, Long> id;
	public static volatile SingularAttribute<Status, String> description;
}

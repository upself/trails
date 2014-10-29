package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(DiscrepancyType.class)
public class DiscrepancyType_ {
	public static volatile SingularAttribute<DiscrepancyType, Long> id;
	public static volatile SingularAttribute<DiscrepancyType, String> name;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(CapacityType.class)
public class CapacityType_ {
	public static volatile SingularAttribute<CapacityType, Integer> code;
	public static volatile SingularAttribute<CapacityType, String> description;
	public static volatile SingularAttribute<CapacityType, Date> recordTime;
}

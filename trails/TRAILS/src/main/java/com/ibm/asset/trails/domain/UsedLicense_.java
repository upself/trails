package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(UsedLicense.class)
public class UsedLicense_ {
	public static volatile SingularAttribute<UsedLicense, Long> id;
	public static volatile SingularAttribute<UsedLicense, Integer> usedQuantity;
	public static volatile SingularAttribute<UsedLicense, License> license;
	public static volatile SingularAttribute<UsedLicense, CapacityType> capacityType;
	public static volatile SetAttribute<UsedLicense, Reconcile> reconciles;
}

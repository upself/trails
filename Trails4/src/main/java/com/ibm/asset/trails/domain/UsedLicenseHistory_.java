package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(UsedLicenseHistory.class)
public class UsedLicenseHistory_ {
	public static volatile SingularAttribute<UsedLicenseHistory, Long> id;
	public static volatile SingularAttribute<UsedLicenseHistory, Integer> usedQuantity;
	public static volatile SingularAttribute<UsedLicenseHistory, License> license;
	public static volatile SingularAttribute<UsedLicenseHistory, CapacityType> capacityType;
	public static volatile SetAttribute<UsedLicenseHistory, ReconcileH> reconciles;
}

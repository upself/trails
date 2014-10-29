package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Reconcile.class)
public class Reconcile_ {
	public static volatile SingularAttribute<Reconcile, Long> id;
	public static volatile SingularAttribute<Reconcile, ReconcileType> reconcileType;
	public static volatile SingularAttribute<Reconcile, InstalledSoftware> installedSoftware;
	public static volatile SingularAttribute<Reconcile, InstalledSoftware> parentInstalledSoftware;
	public static volatile SetAttribute<Reconcile, UsedLicense> usedLicenses;
	public static volatile SingularAttribute<Reconcile, String> comments;
	public static volatile SingularAttribute<Reconcile, String> remoteUser;
	public static volatile SingularAttribute<Reconcile, Date> recordTime;
	public static volatile SingularAttribute<Reconcile, Integer> machineLevel;
	public static volatile SingularAttribute<Reconcile, AllocationMethodology> allocationMethodology;
}

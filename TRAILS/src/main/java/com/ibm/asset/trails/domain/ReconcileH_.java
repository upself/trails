package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ReconcileH.class)
public class ReconcileH_ {
	public static volatile SingularAttribute<ReconcileH, Long> id;
	public static volatile SingularAttribute<ReconcileH, ReconcileType> reconcileType;
	public static volatile SingularAttribute<ReconcileH, InstalledSoftware> installedSoftware;
	public static volatile SingularAttribute<ReconcileH, InstalledSoftware> parentInstalledSoftware;
	public static volatile SetAttribute<ReconcileH, UsedLicenseHistory> usedLicenses;
	public static volatile SingularAttribute<ReconcileH, String> comments;
	public static volatile SingularAttribute<ReconcileH, String> remoteUser;
	public static volatile SingularAttribute<ReconcileH, Date> recordTime;
	public static volatile SingularAttribute<ReconcileH, Integer> machineLevel;
	public static volatile SingularAttribute<ReconcileH, Boolean> manualBreak;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertUnlicensedSwRecon.class)
public class AlertUnlicensedSwRecon_ {
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, Long> id;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, InstalledSoftware> installedSoftware;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, String> comments;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, String> type;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, String> remoteUser;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, Date> creationTime;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, Date> recordTime;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, Boolean> open;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, Reconcile> reconcile;
	public static volatile SingularAttribute<AlertUnlicensedSwRecon, Integer> alertAge;
}

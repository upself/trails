package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertUnlicensedSw.class)
public class AlertUnlicensedSw_ {
	public static volatile SingularAttribute<AlertUnlicensedSw, Long> id;
	public static volatile SingularAttribute<AlertUnlicensedSw, InstalledSoftware> installedSoftware;
	public static volatile SingularAttribute<AlertUnlicensedSw, String> comments;
	public static volatile SingularAttribute<AlertUnlicensedSw, String> type;
	public static volatile SingularAttribute<AlertUnlicensedSw, String> remoteUser;
	public static volatile SingularAttribute<AlertUnlicensedSw, Date> creationTime;
	public static volatile SingularAttribute<AlertUnlicensedSw, Date> recordTime;
	public static volatile SingularAttribute<AlertUnlicensedSw, Boolean> open;
	public static volatile SingularAttribute<AlertUnlicensedSw, Reconcile> reconcile;
}

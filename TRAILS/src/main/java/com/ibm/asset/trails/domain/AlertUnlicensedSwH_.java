package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertUnlicensedSwH.class)
public class AlertUnlicensedSwH_ {
	public static volatile SingularAttribute<AlertUnlicensedSwH, Long> id;
	public static volatile SingularAttribute<AlertUnlicensedSwH, AlertUnlicensedSw> alertUnlicensedSw;
	public static volatile SingularAttribute<AlertUnlicensedSwH, String> comments;
	public static volatile SingularAttribute<AlertUnlicensedSwH, String> remoteUser;
	public static volatile SingularAttribute<AlertUnlicensedSwH, Date> creationTime;
	public static volatile SingularAttribute<AlertUnlicensedSwH, Date> recordTime;
	public static volatile SingularAttribute<AlertUnlicensedSwH, Boolean> open;
}

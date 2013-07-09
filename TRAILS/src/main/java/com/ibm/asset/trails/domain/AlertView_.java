package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertView.class)
public class AlertView_ {
	public static volatile SingularAttribute<AlertView, String> id;
	public static volatile SingularAttribute<AlertView, Long> tableId;
	public static volatile SingularAttribute<AlertView, Account> account;
	public static volatile SingularAttribute<AlertView, String> comments;
	public static volatile SingularAttribute<AlertView, String> remoteUser;
	public static volatile SingularAttribute<AlertView, Integer> alertAge;
	public static volatile SingularAttribute<AlertView, Date> creationTime;
	public static volatile SingularAttribute<AlertView, Date> recordTime;
	public static volatile SingularAttribute<AlertView, Boolean> open;
	public static volatile SingularAttribute<AlertView, String> type;
	public static volatile SingularAttribute<AlertView, String> displayName;
}

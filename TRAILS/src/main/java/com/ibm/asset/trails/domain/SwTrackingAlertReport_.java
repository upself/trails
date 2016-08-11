package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(SwTrackingAlertReport.class)
public class SwTrackingAlertReport_ {
	public static volatile SingularAttribute<SwTrackingAlertReport, String> id;
	public static volatile SingularAttribute<SwTrackingAlertReport, Account> account;
	public static volatile SingularAttribute<SwTrackingAlertReport, String> displayName;
	public static volatile SingularAttribute<SwTrackingAlertReport, String> assetType;
	public static volatile SingularAttribute<SwTrackingAlertReport, Date> recordTime;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> assigned;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> red;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> yellow;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> green;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> red91;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> red121;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> red151;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> red181;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> red366;
	public static volatile SingularAttribute<SwTrackingAlertReport, Integer> assetTotal;
}

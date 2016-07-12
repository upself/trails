package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(MqtAlertReport.class)
public class SwTrackingAlertReport_ {
	public static volatile SingularAttribute<MqtAlertReport, String> id;
	public static volatile SingularAttribute<MqtAlertReport, Account> account;
	public static volatile SingularAttribute<MqtAlertReport, String> displayName;
	public static volatile SingularAttribute<MqtAlertReport, String> assetType;
	public static volatile SingularAttribute<MqtAlertReport, Date> recordTime;
	public static volatile SingularAttribute<MqtAlertReport, Integer> assigned;
	public static volatile SingularAttribute<MqtAlertReport, Integer> red;
	public static volatile SingularAttribute<MqtAlertReport, Integer> yellow;
	public static volatile SingularAttribute<MqtAlertReport, Integer> green;
	public static volatile SingularAttribute<MqtAlertReport, Integer> red91;
	public static volatile SingularAttribute<MqtAlertReport, Integer> red121;
	public static volatile SingularAttribute<MqtAlertReport, Integer> red151;
	public static volatile SingularAttribute<MqtAlertReport, Integer> red181;
	public static volatile SingularAttribute<MqtAlertReport, Integer> red366;
	public static volatile SingularAttribute<MqtAlertReport, Integer> assetTotal;
}

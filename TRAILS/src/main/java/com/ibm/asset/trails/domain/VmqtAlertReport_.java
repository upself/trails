package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(VmqtAlertReport.class)
public class VmqtAlertReport_ {
	public static volatile SingularAttribute<VmqtAlertReport, String> id;
	public static volatile SingularAttribute<VmqtAlertReport, Account> account;
	public static volatile SingularAttribute<VmqtAlertReport, String> displayName;
	public static volatile SingularAttribute<VmqtAlertReport, String> assetType;
	public static volatile SingularAttribute<VmqtAlertReport, Date> recordTime;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> assigned;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> red;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> yellow;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> green;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> red91;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> red121;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> red151;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> red181;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> red366;
	public static volatile SingularAttribute<VmqtAlertReport, Integer> assetTotal;
}

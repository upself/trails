package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertReportView.class)
public class AlertReportView_ {
	public static volatile SingularAttribute<AlertReportView, String> id;
	public static volatile SingularAttribute<AlertReportView, Account> account;
	public static volatile SingularAttribute<AlertReportView, Boolean> open;
	public static volatile SingularAttribute<AlertReportView, Integer> assigned;
	public static volatile SingularAttribute<AlertReportView, Integer> red;
	public static volatile SingularAttribute<AlertReportView, Integer> yellow;
	public static volatile SingularAttribute<AlertReportView, Integer> green;
	public static volatile SingularAttribute<AlertReportView, String> displayName;
}

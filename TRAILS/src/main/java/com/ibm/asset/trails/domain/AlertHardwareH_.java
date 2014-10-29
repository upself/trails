package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertHardwareH.class)
public class AlertHardwareH_ {
	public static volatile SingularAttribute<AlertHardwareH, Long> id;
	public static volatile SingularAttribute<AlertHardwareH, AlertHardware> alertHardware;
	public static volatile SingularAttribute<AlertHardwareH, String> comments;
	public static volatile SingularAttribute<AlertHardwareH, String> remoteUser;
	public static volatile SingularAttribute<AlertHardwareH, Date> creationTime;
	public static volatile SingularAttribute<AlertHardwareH, Date> recordTime;
	public static volatile SingularAttribute<AlertHardwareH, Boolean> open;
	public static volatile SingularAttribute<AlertHardwareH, Integer> alertAge;
}

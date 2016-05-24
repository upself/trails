package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(ScheduleFH.class)
public class ScheduleFH_ {
	public static volatile SingularAttribute<ScheduleFH, Long> id;
	public static volatile SingularAttribute<ScheduleFH, ScheduleF> scheduleF;
	public static volatile SingularAttribute<ScheduleFH, Long> softwareId;
	public static volatile SingularAttribute<ScheduleFH, String> softwareTitle;
	public static volatile SingularAttribute<ScheduleFH, String> softwareName;
	public static volatile SingularAttribute<ScheduleFH, String> manufacturer;
	public static volatile SingularAttribute<ScheduleFH, String> statusId;
	public static volatile SingularAttribute<ScheduleFH, String> level;
	public static volatile SingularAttribute<ScheduleFH, String> hwOwner;
	public static volatile SingularAttribute<ScheduleFH, String> serial;
	public static volatile SingularAttribute<ScheduleFH, String> machineType;
	public static volatile SingularAttribute<ScheduleFH, String> hostname;
	public static volatile SingularAttribute<ScheduleFH, Long> customerId;
	public static volatile SingularAttribute<ScheduleFH, Long> scopeId;
	public static volatile SingularAttribute<ScheduleFH, Long> sourceId;
	public static volatile SingularAttribute<ScheduleFH, String> SWFinanceResp;
	public static volatile SingularAttribute<ScheduleFH, String> sourceLocation;
	public static volatile SingularAttribute<ScheduleFH, String> remoteUser;
	public static volatile SingularAttribute<ScheduleFH, Date> recordTime;
	public static volatile SingularAttribute<ScheduleFH, String> businessJustification;
}

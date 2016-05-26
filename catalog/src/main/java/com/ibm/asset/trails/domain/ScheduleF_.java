package com.ibm.asset.trails.domain;


import java.util.Date;
import java.util.List;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(ScheduleF.class)
public class ScheduleF_ {
	public static volatile SingularAttribute<ScheduleF, Long> id;
	public static volatile SingularAttribute<ScheduleF, Long> softwareId;
	public static volatile SingularAttribute<ScheduleF, String> softwareTitle;
	public static volatile SingularAttribute<ScheduleF, String> softwareName;
	public static volatile SingularAttribute<ScheduleF, String> manufacturer;
	public static volatile SingularAttribute<ScheduleF, String> statusId;
	public static volatile SingularAttribute<ScheduleF, String> level;
	public static volatile SingularAttribute<ScheduleF, String> hwOwner;
	public static volatile SingularAttribute<ScheduleF, String> serial;
	public static volatile SingularAttribute<ScheduleF, String> machineType;
	public static volatile SingularAttribute<ScheduleF, String> hostname;
	public static volatile SingularAttribute<ScheduleF, Long> customerId;
	public static volatile SingularAttribute<ScheduleF, Long> scopeId;
	public static volatile SingularAttribute<ScheduleF, Long> sourceId;
	public static volatile SingularAttribute<ScheduleF, String> SWFinanceResp;
	public static volatile SingularAttribute<ScheduleF, String> sourceLocation;
	public static volatile SingularAttribute<ScheduleF, String> remoteUser;
	public static volatile SingularAttribute<ScheduleF, Date> recordTime;
	public static volatile SingularAttribute<ScheduleF, String> businessJustification;
	public static volatile SingularAttribute<ScheduleF, List<ScheduleFH>> scheduleFHList;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(InstalledSoftware.class)
public class InstalledSoftware_ {
	public static volatile SingularAttribute<InstalledSoftware, Long> id;
	public static volatile SingularAttribute<InstalledSoftware, VSoftwareLpar> softwareLpar;
	public static volatile SingularAttribute<InstalledSoftware, Software> software;
	public static volatile SingularAttribute<InstalledSoftware, DiscrepancyType> discrepancyType;
	public static volatile SingularAttribute<InstalledSoftware, Integer> users;
	public static volatile SingularAttribute<InstalledSoftware, Integer> processorCount;
	public static volatile SingularAttribute<InstalledSoftware, String> remoteUser;
	public static volatile SingularAttribute<InstalledSoftware, Date> recordTime;
	public static volatile SingularAttribute<InstalledSoftware, String> status;
	public static volatile SingularAttribute<InstalledSoftware, AlertUnlicensedSwRecon> alert;
	public static volatile SingularAttribute<InstalledSoftware, ScheduleF> scheduleF;
}

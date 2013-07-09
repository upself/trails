package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ScheduleFH.class)
public class ScheduleFH_ {
	public static volatile SingularAttribute<ScheduleFH, Long> id;
	public static volatile SingularAttribute<ScheduleFH, ScheduleF> scheduleF;
	public static volatile SingularAttribute<ScheduleFH, Account> account;
	public static volatile SingularAttribute<ScheduleFH, ProductInfo> productInfo;
	public static volatile SingularAttribute<ScheduleFH, String> softwareTitle;
	public static volatile SingularAttribute<ScheduleFH, String> softwareName;
	public static volatile SingularAttribute<ScheduleFH, String> manufacturer;
	public static volatile SingularAttribute<ScheduleFH, Scope> scope;
	public static volatile SingularAttribute<ScheduleFH, Source> source;
	public static volatile SingularAttribute<ScheduleFH, String> sourceLocation;
	public static volatile SingularAttribute<ScheduleFH, Status> status;
	public static volatile SingularAttribute<ScheduleFH, String> businessJustification;
	public static volatile SingularAttribute<ScheduleFH, String> remoteUser;
	public static volatile SingularAttribute<ScheduleFH, Date> recordTime;
}

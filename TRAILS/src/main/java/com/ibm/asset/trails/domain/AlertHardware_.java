package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertHardware.class)
public class AlertHardware_ {
	public static volatile SingularAttribute<AlertHardware, Long> id;
	public static volatile SingularAttribute<AlertHardware, Hardware> hardware;
	public static volatile SingularAttribute<AlertHardware, String> comments;
	public static volatile SingularAttribute<AlertHardware, String> remoteUser;
	public static volatile SingularAttribute<AlertHardware, Date> creationTime;
	public static volatile SingularAttribute<AlertHardware, Date> recordTime;
	public static volatile SingularAttribute<AlertHardware, Boolean> open;
	public static volatile SingularAttribute<AlertHardware, Integer> alertAge;
}

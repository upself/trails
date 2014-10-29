package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertHardwareLparH.class)
public class AlertHardwareLparH_ {
	public static volatile SingularAttribute<AlertHardwareLparH, Long> id;
	public static volatile SingularAttribute<AlertHardwareLparH, AlertHardwareLpar> alertHardwareLpar;
	public static volatile SingularAttribute<AlertHardwareLparH, String> comments;
	public static volatile SingularAttribute<AlertHardwareLparH, String> remoteUser;
	public static volatile SingularAttribute<AlertHardwareLparH, Date> creationTime;
	public static volatile SingularAttribute<AlertHardwareLparH, Date> recordTime;
	public static volatile SingularAttribute<AlertHardwareLparH, Boolean> open;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertSoftwareLparH.class)
public class AlertSoftwareLparH_ {
	public static volatile SingularAttribute<AlertSoftwareLparH, Long> id;
	public static volatile SingularAttribute<AlertSoftwareLparH, AlertSoftwareLpar> alertSoftwareLpar;
	public static volatile SingularAttribute<AlertSoftwareLparH, String> comments;
	public static volatile SingularAttribute<AlertSoftwareLparH, String> remoteUser;
	public static volatile SingularAttribute<AlertSoftwareLparH, Date> creationTime;
	public static volatile SingularAttribute<AlertSoftwareLparH, Date> recordTime;
	public static volatile SingularAttribute<AlertSoftwareLparH, Boolean> open;
}

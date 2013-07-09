package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertSoftwareLpar.class)
public class AlertSoftwareLpar_ {
	public static volatile SingularAttribute<AlertSoftwareLpar, Long> id;
	public static volatile SingularAttribute<AlertSoftwareLpar, SoftwareLpar> softwareLpar;
	public static volatile SingularAttribute<AlertSoftwareLpar, String> comments;
	public static volatile SingularAttribute<AlertSoftwareLpar, String> remoteUser;
	public static volatile SingularAttribute<AlertSoftwareLpar, Date> creationTime;
	public static volatile SingularAttribute<AlertSoftwareLpar, Date> recordTime;
	public static volatile SingularAttribute<AlertSoftwareLpar, Boolean> open;
}

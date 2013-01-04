package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertExpiredScan.class)
public class AlertExpiredScan_ {
	public static volatile SingularAttribute<AlertExpiredScan, Long> id;
	public static volatile SingularAttribute<AlertExpiredScan, SoftwareLpar> softwareLpar;
	public static volatile SingularAttribute<AlertExpiredScan, String> comments;
	public static volatile SingularAttribute<AlertExpiredScan, String> remoteUser;
	public static volatile SingularAttribute<AlertExpiredScan, Date> creationTime;
	public static volatile SingularAttribute<AlertExpiredScan, Date> recordTime;
	public static volatile SingularAttribute<AlertExpiredScan, Boolean> open;
}

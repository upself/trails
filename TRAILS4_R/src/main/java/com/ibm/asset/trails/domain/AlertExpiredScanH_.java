package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertExpiredScanH.class)
public class AlertExpiredScanH_ {
	public static volatile SingularAttribute<AlertExpiredScanH, Long> id;
	public static volatile SingularAttribute<AlertExpiredScanH, AlertExpiredScan> alertExpiredScan;
	public static volatile SingularAttribute<AlertExpiredScanH, String> comments;
	public static volatile SingularAttribute<AlertExpiredScanH, String> remoteUser;
	public static volatile SingularAttribute<AlertExpiredScanH, Date> creationTime;
	public static volatile SingularAttribute<AlertExpiredScanH, Boolean> open;
	public static volatile SingularAttribute<AlertExpiredScanH, Date> recordTime;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertExpiredMaint.class)
public class AlertExpiredMaint_ {
	public static volatile SingularAttribute<AlertExpiredMaint, Long> id;
	public static volatile SingularAttribute<AlertExpiredMaint, License> license;
	public static volatile SingularAttribute<AlertExpiredMaint, String> comments;
	public static volatile SingularAttribute<AlertExpiredMaint, String> remoteUser;
	public static volatile SingularAttribute<AlertExpiredMaint, Date> creationTime;
	public static volatile SingularAttribute<AlertExpiredMaint, Date> recordTime;
	public static volatile SingularAttribute<AlertExpiredMaint, Boolean> open;
}

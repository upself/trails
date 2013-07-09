package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertExpiredMaintH.class)
public class AlertExpiredMaintH_ {
	public static volatile SingularAttribute<AlertExpiredMaintH, Long> id;
	public static volatile SingularAttribute<AlertExpiredMaintH, AlertExpiredMaint> alertExpiredMaint;
	public static volatile SingularAttribute<AlertExpiredMaintH, String> comments;
	public static volatile SingularAttribute<AlertExpiredMaintH, String> remoteUser;
	public static volatile SingularAttribute<AlertExpiredMaintH, Date> creationTime;
	public static volatile SingularAttribute<AlertExpiredMaintH, Date> recordTime;
	public static volatile SingularAttribute<AlertExpiredMaintH, Boolean> open;
}

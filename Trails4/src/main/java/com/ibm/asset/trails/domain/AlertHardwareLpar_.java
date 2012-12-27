package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertHardwareLpar.class)
public class AlertHardwareLpar_ {
	public static volatile SingularAttribute<AlertHardwareLpar, Long> id;
	public static volatile SingularAttribute<AlertHardwareLpar, HardwareLpar> hardwareLpar;
	public static volatile SingularAttribute<AlertHardwareLpar, String> comments;
	public static volatile SingularAttribute<AlertHardwareLpar, String> remoteUser;
	public static volatile SingularAttribute<AlertHardwareLpar, Date> creationTime;
	public static volatile SingularAttribute<AlertHardwareLpar, Date> recordTime;
	public static volatile SingularAttribute<AlertHardwareLpar, Boolean> open;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(MachineType.class)
public class MachineType_ {
	public static volatile SingularAttribute<MachineType, Long> id;
	public static volatile SingularAttribute<MachineType, String> name;
	public static volatile SingularAttribute<MachineType, String> definition;
	public static volatile SingularAttribute<MachineType, String> type;
	public static volatile SingularAttribute<MachineType, String> remoteUser;
	public static volatile SingularAttribute<MachineType, Date> recordTime;
	public static volatile SingularAttribute<MachineType, String> status;
}

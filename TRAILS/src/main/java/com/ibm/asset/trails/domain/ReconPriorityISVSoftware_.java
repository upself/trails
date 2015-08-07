package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ReconPriorityISVSoftware.class)
public class ReconPriorityISVSoftware_ {
	public static volatile SingularAttribute<ReconPriorityISVSoftware, Long> id;
	public static volatile SingularAttribute<ReconPriorityISVSoftware, Account> account;
	public static volatile SingularAttribute<ReconPriorityISVSoftware, Manufacturer> manufacturer;
	public static volatile SingularAttribute<ReconPriorityISVSoftware, String> action;
	public static volatile SingularAttribute<ReconPriorityISVSoftware, String> remoteUser;
	public static volatile SingularAttribute<ReconPriorityISVSoftware, Date> recordTime;
}

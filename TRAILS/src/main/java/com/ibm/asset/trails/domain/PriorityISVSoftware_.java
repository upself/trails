package com.ibm.asset.trails.domain;

import java.util.Date;
import javax.persistence.metamodel.SingularAttribute;

public class PriorityISVSoftware_ {
	
	public static volatile SingularAttribute<PriorityISVSoftware, Long> id;
	public static volatile SingularAttribute<PriorityISVSoftware, String> level;
	public static volatile SingularAttribute<PriorityISVSoftware, Account> account;
	public static volatile SingularAttribute<PriorityISVSoftware, Manufacturer> manufacturer;
	public static volatile SingularAttribute<PriorityISVSoftware, String> evidenceLocation;
	public static volatile SingularAttribute<PriorityISVSoftware, Status> status;
	public static volatile SingularAttribute<PriorityISVSoftware, String> businessJustification;
	public static volatile SingularAttribute<PriorityISVSoftware, String> remoteUser;
	public static volatile SingularAttribute<PriorityISVSoftware, Date> recordTime;
}

package com.ibm.asset.trails.domain;

import java.util.Date;
import javax.persistence.metamodel.SingularAttribute;

public class NonInstance_ {
	
	public static volatile SingularAttribute<NonInstance, Long> id;
	public static volatile SingularAttribute<NonInstance, Software> software;
	public static volatile SingularAttribute<NonInstance, Manufacturer> manufacturer;
	public static volatile SingularAttribute<NonInstance, String> restriction;
	public static volatile SingularAttribute<NonInstance, CapacityType> capacityType;
	public static volatile SingularAttribute<NonInstance, Integer> baseOnly;
	public static volatile SingularAttribute<NonInstance, Status> status;
	public static volatile SingularAttribute<NonInstance, String> remoteUser;
	public static volatile SingularAttribute<NonInstance, Date> recordTime;
}

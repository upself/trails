package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertViewRedAging.class)
public class AlertViewRedAging_ {
	public static volatile SingularAttribute<AlertViewRedAging, String> id;
	public static volatile SingularAttribute<AlertViewRedAging, Long> customerId;
	public static volatile SingularAttribute<AlertViewRedAging, Long> accountNumber;
	public static volatile SingularAttribute<AlertViewRedAging, String> customerType;
	public static volatile SingularAttribute<AlertViewRedAging, String> displayName;
	public static volatile SingularAttribute<AlertViewRedAging, Integer> alertAge;
	public static volatile SingularAttribute<AlertViewRedAging, String> machineType;
	public static volatile SingularAttribute<AlertViewRedAging, String> serial;
	public static volatile SingularAttribute<AlertViewRedAging, String> hardwareLparName;
	public static volatile SingularAttribute<AlertViewRedAging, String> softwareLparName;
	public static volatile SingularAttribute<AlertViewRedAging, String> softwareName;
}

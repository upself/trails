package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Hardware.class)
public class Hardware_ {
	public static volatile SingularAttribute<Hardware, Long> id;
	public static volatile SingularAttribute<Hardware, Account> account;
	public static volatile SingularAttribute<Hardware, MachineType> machineType;
	public static volatile SingularAttribute<Hardware, String> serial;
	public static volatile SingularAttribute<Hardware, String> country;
	public static volatile SingularAttribute<Hardware, String> owner;
	public static volatile SingularAttribute<Hardware, String> customerNumber;
	public static volatile SingularAttribute<Hardware, String> remoteUser;
	public static volatile SingularAttribute<Hardware, Date> recordTime;
	public static volatile SingularAttribute<Hardware, String> status;
	public static volatile SingularAttribute<Hardware, String> hardwareStatus;
	public static volatile SingularAttribute<Hardware, Integer> processorCount;
	public static volatile SingularAttribute<Hardware, String> processorModel;
	public static volatile SingularAttribute<Hardware, String> processorBrand;
	public static volatile SingularAttribute<Hardware, Integer> chips;
}

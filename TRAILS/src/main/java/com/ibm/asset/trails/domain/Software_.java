package com.ibm.asset.trails.domain;

import java.sql.Timestamp;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Software.class)
public class Software_ {
	public static volatile SingularAttribute<Software, Long> softwareId;
	public static volatile SingularAttribute<Software, String> changeJustification;
	public static volatile SingularAttribute<Software, String> comments;
	public static volatile SingularAttribute<Software, String> level;
	public static volatile SingularAttribute<Software, Long> softwareCategoryId;
	public static volatile SingularAttribute<Software, Timestamp> recordTime;
	public static volatile SingularAttribute<Software, Integer> priority;
	public static volatile SingularAttribute<Software, String> remoteUser;
	public static volatile SingularAttribute<Software, String> softwareName;
	public static volatile SingularAttribute<Software, Manufacturer> manufacturer;
	public static volatile SingularAttribute<Software, String> status;
	public static volatile SingularAttribute<Software, String> type;
	public static volatile SingularAttribute<Software, Integer> vendorManaged;
	public static volatile SingularAttribute<Software, String> productRole;
	public static volatile SingularAttribute<Software, String> version;
	public static volatile SingularAttribute<Software, String> pid;
	public static volatile SingularAttribute<Software, ProductInfo> productInfo;
}

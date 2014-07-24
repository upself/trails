package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(License.class)
public class License_ {
	public static volatile SingularAttribute<License, Long> id;
	public static volatile SingularAttribute<License, ProductInfo> productInfo;
	public static volatile SingularAttribute<License, String> poNumber;
	public static volatile SingularAttribute<License, String> cpuSerial;
	public static volatile SingularAttribute<License, Boolean> ibmOwned;
	public static volatile SingularAttribute<License, Date> expireDate;
	public static volatile SingularAttribute<License, Integer> quantity;
	public static volatile SingularAttribute<License, String> fullDesc;
	public static volatile SingularAttribute<License, String> prodName;
	public static volatile SingularAttribute<License, CapacityType> capacityType;
	public static volatile SingularAttribute<License, String> version;
	public static volatile SingularAttribute<License, String> extSrcId;
	public static volatile SingularAttribute<License, Account> account;
	public static volatile SingularAttribute<License, String> remoteUser;
	public static volatile SingularAttribute<License, Date> recordTime;
	public static volatile SingularAttribute<License, String> status;
	public static volatile SetAttribute<License, UsedLicense> usedLicenses;
	public static volatile SetAttribute<License, UsedLicenseHistory> usedLicenseHistories;
	public static volatile SingularAttribute<License, Integer> pool;
	public static volatile SingularAttribute<License, String> environment;
}

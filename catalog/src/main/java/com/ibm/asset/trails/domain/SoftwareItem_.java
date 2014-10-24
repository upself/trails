package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.ProductRoleEnumeration;

@StaticMetamodel(SoftwareItem.class)
public class SoftwareItem_ extends KbDefinition_ {
	public static volatile SingularAttribute<SoftwareItem, Date> activationDate;
	public static volatile SingularAttribute<SoftwareItem, Date> endOfSupportDate;
	public static volatile SingularAttribute<SoftwareItem, String> name;
	public static volatile SingularAttribute<SoftwareItem, String> productId;
	public static volatile SingularAttribute<SoftwareItem, String> productIds;
	public static volatile SetAttribute<SoftwareItem, Pid> pids;
	public static volatile SingularAttribute<SoftwareItem, ProductRoleEnumeration> productRole;
	public static volatile SingularAttribute<SoftwareItem, String> website;
	public static volatile SingularAttribute<SoftwareItem, Boolean> subCapacityLicensing;
	public static volatile SingularAttribute<SoftwareItem, String> ipla;
	public static volatile SingularAttribute<ProductInfo, Recon> recon;
}

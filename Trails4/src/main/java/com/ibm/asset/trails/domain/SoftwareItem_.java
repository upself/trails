package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(SoftwareItem.class)
public class SoftwareItem_ extends KbDefinition_ {
	public static volatile SingularAttribute<SoftwareItem, String> name;
	public static volatile SingularAttribute<SoftwareItem, Date> endOfSupport;
	public static volatile SingularAttribute<SoftwareItem, String> productId;
	public static volatile SingularAttribute<SoftwareItem, String> website;
	public static volatile SingularAttribute<SoftwareItem, Date> activationDate;
	public static volatile SingularAttribute<SoftwareItem, ProductRoleEnumeration> productRole;
	public static volatile SetAttribute<SoftwareItem, Pid> pids;
}

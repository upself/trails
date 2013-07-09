package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ReconCustomerSoftware.class)
public class ReconCustomerSoftware_ {
	public static volatile SingularAttribute<ReconCustomerSoftware, Long> id;
	public static volatile SingularAttribute<ReconCustomerSoftware, ProductInfo> productInfo;
	public static volatile SingularAttribute<ReconCustomerSoftware, Account> account;
	public static volatile SingularAttribute<ReconCustomerSoftware, String> action;
	public static volatile SingularAttribute<ReconCustomerSoftware, String> remoteUser;
	public static volatile SingularAttribute<ReconCustomerSoftware, Date> recordTime;
}

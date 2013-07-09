package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(CustomerNumber.class)
public class CustomerNumber_ {
	public static volatile SingularAttribute<CustomerNumber, Long> id;
	public static volatile SingularAttribute<CustomerNumber, String> name;
	public static volatile SingularAttribute<CustomerNumber, Account> account;
	public static volatile SingularAttribute<CustomerNumber, String> status;
}

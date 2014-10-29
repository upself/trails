package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AccountType.class)
public class AccountType_ {
	public static volatile SingularAttribute<AccountType, Long> id;
	public static volatile SingularAttribute<AccountType, String> name;
}

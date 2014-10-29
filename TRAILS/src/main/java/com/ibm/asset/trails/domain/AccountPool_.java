package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AccountPool.class)
public class AccountPool_ {
	public static volatile SingularAttribute<AccountPool, Long> id;
	public static volatile SingularAttribute<AccountPool, Account> masterAccount;
	public static volatile SingularAttribute<AccountPool, Account> memberAccount;
	public static volatile SingularAttribute<AccountPool, Boolean> deleted;
}

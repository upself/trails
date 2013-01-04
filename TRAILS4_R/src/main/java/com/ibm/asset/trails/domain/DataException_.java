package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(DataException.class)
public class DataException_ {
	public static volatile SingularAttribute<DataException, Account> account;
	public static volatile SingularAttribute<DataException, DataExceptionType> alertType;
	public static volatile SingularAttribute<DataException, DataExceptionCause> alertCause;
	public static volatile SingularAttribute<DataException, Boolean> open;
	public static volatile SingularAttribute<DataException, Long> id;
	public static volatile SingularAttribute<DataException, Date> creationTime;
	public static volatile SingularAttribute<DataException, Date> recordTime;
	public static volatile SingularAttribute<DataException, String> remoteUser;
	public static volatile SingularAttribute<DataException, String> assignee;
	public static volatile SingularAttribute<DataException, String> comment;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(DataExceptionHistory.class)
public class DataExceptionHistory_ {
	public static volatile SingularAttribute<DataExceptionHistory, DataException> alert;
	public static volatile SingularAttribute<DataExceptionHistory, Account> account;
	public static volatile SingularAttribute<DataExceptionHistory, AlertType> alertType;
	public static volatile SingularAttribute<DataExceptionHistory, AlertCause> alertCause;
	public static volatile SingularAttribute<DataExceptionHistory, Boolean> open;
	public static volatile SingularAttribute<DataExceptionHistory, Long> id;
	public static volatile SingularAttribute<DataExceptionHistory, Date> creationTime;
	public static volatile SingularAttribute<DataExceptionHistory, Date> recordTime;
	public static volatile SingularAttribute<DataExceptionHistory, String> remoteUser;
	public static volatile SingularAttribute<DataExceptionHistory, String> assignee;
	public static volatile SingularAttribute<DataExceptionHistory, String> comment;
}

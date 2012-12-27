package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(DataExceptionType.class)
public class DataExceptionType_ {
	public static volatile SingularAttribute<DataExceptionType, Long> id;
	public static volatile SingularAttribute<DataExceptionType, String> name;
	public static volatile SingularAttribute<DataExceptionType, String> code;
	public static volatile SetAttribute<DataExceptionType, DataExceptionCause> alertCauseSet;
}

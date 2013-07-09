package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(DataExceptionCause.class)
public class DataExceptionCause_ {
	public static volatile SingularAttribute<DataExceptionCause, Long> id;
	public static volatile SingularAttribute<DataExceptionCause, String> name;
	public static volatile SingularAttribute<DataExceptionCause, Boolean> showInGui;
}

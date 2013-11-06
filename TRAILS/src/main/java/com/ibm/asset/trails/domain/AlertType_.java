package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(AlertType.class)
public class AlertType_ {
	public static volatile SingularAttribute<AlertType, Long> id;
	public static volatile SingularAttribute<AlertType, String> name;
	public static volatile SingularAttribute<AlertType, String> code;
	public static volatile SetAttribute<AlertType, AlertCause> alertCauseSet;
}

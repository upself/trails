package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(AlertCause.class)
public class AlertCause_ {
	public static volatile SingularAttribute<AlertCause, Long> id;
	public static volatile SingularAttribute<AlertCause, String> name;
	public static volatile SingularAttribute<AlertCause, Boolean> showInGui;
	public static volatile SingularAttribute<AlertCause, AlertCauseResponsibility> alertCauseResponsibility;
	public static volatile SetAttribute<AlertCause, AlertTypeCause> alertTypeCauses;
}

package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(AlertCause.class)
public class AlertCauseResponsibility_ {
	public static volatile SingularAttribute<AlertCause, Long> id;
	public static volatile SingularAttribute<AlertCause, String> name;
}

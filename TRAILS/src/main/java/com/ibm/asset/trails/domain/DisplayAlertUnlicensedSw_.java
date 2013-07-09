package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(DisplayAlertUnlicensedSw.class)
public class DisplayAlertUnlicensedSw_ {
	public static volatile SingularAttribute<DisplayAlertUnlicensedSw, String> softwareItemName;
	public static volatile SingularAttribute<DisplayAlertUnlicensedSw, Integer> alertCount;
	public static volatile SingularAttribute<DisplayAlertUnlicensedSw, Integer> alertAge;
	public static volatile SingularAttribute<DisplayAlertUnlicensedSw, Date> creationTime;
}

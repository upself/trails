package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(SoftwareCategory.class)
public class SoftwareCategory_ {
	public static volatile SingularAttribute<SoftwareCategory, Long> softwareCategoryId;
	public static volatile SingularAttribute<SoftwareCategory, String> softwareCategoryName;
	public static volatile SingularAttribute<SoftwareCategory, String> changeJustification;
	public static volatile SingularAttribute<SoftwareCategory, String> comments;
	public static volatile SingularAttribute<SoftwareCategory, String> remoteUser;
	public static volatile SingularAttribute<SoftwareCategory, Date> recordTime;
	public static volatile SingularAttribute<SoftwareCategory, String> status;
}

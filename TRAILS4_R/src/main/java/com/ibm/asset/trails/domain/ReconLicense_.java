package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ReconLicense.class)
public class ReconLicense_ {
	public static volatile SingularAttribute<ReconLicense, Long> id;
	public static volatile SingularAttribute<ReconLicense, License> license;
	public static volatile SingularAttribute<ReconLicense, Account> account;
	public static volatile SingularAttribute<ReconLicense, String> action;
	public static volatile SingularAttribute<ReconLicense, String> remoteUser;
	public static volatile SingularAttribute<ReconLicense, Date> recordTime;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ReconInstalledSoftware.class)
public class ReconInstalledSoftware_ {
	public static volatile SingularAttribute<ReconInstalledSoftware, Long> id;
	public static volatile SingularAttribute<ReconInstalledSoftware, InstalledSoftware> installedSoftware;
	public static volatile SingularAttribute<ReconInstalledSoftware, Account> account;
	public static volatile SingularAttribute<ReconInstalledSoftware, String> action;
	public static volatile SingularAttribute<ReconInstalledSoftware, String> remoteUser;
	public static volatile SingularAttribute<ReconInstalledSoftware, Date> recordTime;
}

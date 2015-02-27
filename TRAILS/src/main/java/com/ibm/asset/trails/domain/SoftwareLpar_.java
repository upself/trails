package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(SoftwareLpar.class)
public class SoftwareLpar_ {
	public static volatile SingularAttribute<SoftwareLpar, Long> id;
	public static volatile SingularAttribute<SoftwareLpar, Account> account;
	public static volatile SingularAttribute<SoftwareLpar, String> name;
	public static volatile SingularAttribute<SoftwareLpar, String> model;
	public static volatile SingularAttribute<SoftwareLpar, String> serial;
	public static volatile SingularAttribute<SoftwareLpar, Integer> processorCount;
	public static volatile SingularAttribute<SoftwareLpar, Date> scanTime;
	public static volatile SingularAttribute<SoftwareLpar, String> remoteUser;
	public static volatile SingularAttribute<SoftwareLpar, Date> recordTime;
	public static volatile SingularAttribute<SoftwareLpar, String> status;
	public static volatile SingularAttribute<SoftwareLpar, String> osName;
	public static volatile SingularAttribute<SoftwareLpar, String> extId;
	public static volatile SingularAttribute<SoftwareLpar, String> techImgId;
	public static volatile SingularAttribute<SoftwareLpar, HardwareLpar> hardwareLpar;
	public static volatile SingularAttribute<SoftwareLpar, SoftwareLparEff> softwareLparEff;
}

package com.ibm.asset.trails.domain;

import java.util.Date;
import java.math.BigDecimal;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(HardwareLpar.class)
public class HardwareLpar_ {
	public static volatile SingularAttribute<HardwareLpar, Long> id;
	public static volatile SingularAttribute<HardwareLpar, Account> account;
	public static volatile SingularAttribute<HardwareLpar, String> name;
	public static volatile SingularAttribute<HardwareLpar, String> extId;
	public static volatile SingularAttribute<HardwareLpar, String> techImgId;
	public static volatile SingularAttribute<HardwareLpar, Hardware> hardware;
	public static volatile SingularAttribute<HardwareLpar, String> remoteUser;
	public static volatile SingularAttribute<HardwareLpar, Date> recordTime;
	public static volatile SingularAttribute<HardwareLpar, String> status;
	public static volatile SingularAttribute<HardwareLpar, String> lparStatus;
	public static volatile SingularAttribute<HardwareLpar, Integer> partLsprMips;
	public static volatile SingularAttribute<HardwareLpar, Integer> partMsu;
	public static volatile SingularAttribute<HardwareLpar, BigDecimal> partGartnerMips;
	public static volatile SingularAttribute<HardwareLpar, String> spla;
	public static volatile SingularAttribute<HardwareLpar, String> sysplex;
	public static volatile SingularAttribute<HardwareLpar, String> internetIccFlag;
	public static volatile SingularAttribute<HardwareLpar, String> serverType;
	public static volatile SingularAttribute<HardwareLpar, BigDecimal> effectiveThreads;

}

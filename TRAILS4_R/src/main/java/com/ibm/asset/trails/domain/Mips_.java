package com.ibm.asset.trails.domain;

import java.math.BigDecimal;
import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Mips.class)
public class Mips_ {
	public static volatile SingularAttribute<Mips, MipsId> id;
	public static volatile SingularAttribute<Mips, BigDecimal> mips;
	public static volatile SingularAttribute<Mips, String> upduser;
	public static volatile SingularAttribute<Mips, Date> updstamp;
	public static volatile SingularAttribute<Mips, String> updIntranetId;
	public static volatile SingularAttribute<Mips, String> status;
}

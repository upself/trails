package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Recon.class)
public class Recon_ {
	public static volatile SingularAttribute<Recon, String> action;
	public static volatile SingularAttribute<Recon, String> remoteUser;
	public static volatile SingularAttribute<Recon, Date> recordTime;
	public static volatile SingularAttribute<Recon, Long> id;
	public static volatile SingularAttribute<Recon, ProductInfo> productInfo;
}

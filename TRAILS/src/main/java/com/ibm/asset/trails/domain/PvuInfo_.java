package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(PvuInfo.class)
public class PvuInfo_ {
	public static volatile SingularAttribute<PvuInfo, Long> id;
	public static volatile SingularAttribute<PvuInfo, Long> pvuId;
	public static volatile SingularAttribute<PvuInfo, String> processorType;
	public static volatile SingularAttribute<PvuInfo, Integer> valueUnitsPerCore;
}

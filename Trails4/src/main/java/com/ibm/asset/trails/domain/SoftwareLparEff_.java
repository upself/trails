package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(SoftwareLparEff.class)
public class SoftwareLparEff_ {
	public static volatile SingularAttribute<SoftwareLparEff, Long> id;
	public static volatile SingularAttribute<SoftwareLparEff, SoftwareLpar> softwareLpar;
	public static volatile SingularAttribute<SoftwareLparEff, Integer> processorCount;
	public static volatile SingularAttribute<SoftwareLparEff, String> status;
}

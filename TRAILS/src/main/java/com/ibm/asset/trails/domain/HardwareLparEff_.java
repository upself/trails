package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(HardwareLparEff.class)
public class HardwareLparEff_ {
	public static volatile SingularAttribute<HardwareLparEff, Long> id;
	public static volatile SingularAttribute<HardwareLparEff, Integer> porcessorCount;
	public static volatile SingularAttribute<HardwareLparEff, String> porcessorCountStatus;
	public static volatile SingularAttribute<HardwareLparEff, HardwareLpar> hardwareLpar;
	public static volatile SingularAttribute<HardwareLparEff, String> status;
	public static volatile SingularAttribute<HardwareLparEff, Integer> processorCount;
}

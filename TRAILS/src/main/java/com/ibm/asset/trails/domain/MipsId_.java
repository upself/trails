package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(MipsId.class)
public class MipsId_ {
	public static volatile SingularAttribute<MipsId, Long> machineTypeId;
	public static volatile SingularAttribute<MipsId, String> model;
	public static volatile SingularAttribute<MipsId, String> mipsGroup;
	public static volatile SingularAttribute<MipsId, String> vendor;
	public static volatile SingularAttribute<MipsId, String> mipsvendor;
}

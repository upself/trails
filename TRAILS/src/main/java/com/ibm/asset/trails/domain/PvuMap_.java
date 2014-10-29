package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(PvuMap.class)
public class PvuMap_ {
	public static volatile SingularAttribute<PvuMap, Long> id;
	public static volatile SingularAttribute<PvuMap, String> processorBrand;
	public static volatile SingularAttribute<PvuMap, String> processorModel;
	public static volatile SingularAttribute<PvuMap, ProcessorValueUnit> processorValueUnit;
	public static volatile SingularAttribute<PvuMap, MachineType> machineType;
}

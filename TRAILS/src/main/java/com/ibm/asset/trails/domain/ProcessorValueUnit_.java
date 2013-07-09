package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.ListAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ProcessorValueUnit.class)
public class ProcessorValueUnit_ {
	public static volatile SingularAttribute<ProcessorValueUnit, Long> id;
	public static volatile SingularAttribute<ProcessorValueUnit, String> processorBrand;
	public static volatile SingularAttribute<ProcessorValueUnit, String> processorModel;
	public static volatile ListAttribute<ProcessorValueUnit, ProcessorValueUnitInfo> processorValueUnitInfo;
	public static volatile ListAttribute<ProcessorValueUnit, PvuMap> pvuMap;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ProcessorValueUnitInfo.class)
public class ProcessorValueUnitInfo_ {
	public static volatile SingularAttribute<ProcessorValueUnitInfo, Long> id;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, ProcessorValueUnit> processorValueUnit;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, String> processorType;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, Integer> valueUnitsPerCore;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, String> status;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, String> processorArchitecture;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, String> serverVendor;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, String> serverBrand;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, String> processorVendor;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, Date> startDate;
	public static volatile SingularAttribute<ProcessorValueUnitInfo, Date> endDate;
}

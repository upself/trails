package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(PartNumber.class)
public class PartNumber_ extends KbDefinition_ {
	public static volatile SingularAttribute<PartNumber, Boolean> isPVU;
	public static volatile SingularAttribute<PartNumber, Boolean> isSubCap;
	public static volatile SingularAttribute<PartNumber, String> name;
	public static volatile SingularAttribute<PartNumber, String> partNumber;
	public static volatile SetAttribute<PartNumber, Pid> pids;
	public static volatile SingularAttribute<PartNumber, Boolean> readOnly;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(ReconPvu.class)
public class ReconPvu_ {
	public static volatile SingularAttribute<ReconPvu, Long> id;
	public static volatile SingularAttribute<ReconPvu, String> processorBrand;
	public static volatile SingularAttribute<ReconPvu, String> processorModel;
	public static volatile SingularAttribute<ReconPvu, String> action;
	public static volatile SingularAttribute<ReconPvu, String> remoteUser;
	public static volatile SingularAttribute<ReconPvu, Date> recordTime;
	public static volatile SingularAttribute<ReconPvu, MachineType> machineType;
}

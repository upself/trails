package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(VSoftwareLpar.class)
public class VSoftwareLpar_ {
	public static volatile SingularAttribute<VSoftwareLpar, Long> id;
	public static volatile SingularAttribute<VSoftwareLpar, Account> account;
	public static volatile SingularAttribute<VSoftwareLpar, Integer> processorCount;
	public static volatile SingularAttribute<VSoftwareLpar, HardwareLpar> hardwareLpar;
	public static volatile SetAttribute<VSoftwareLpar, InstalledSoftware> installedSoftwares;
}

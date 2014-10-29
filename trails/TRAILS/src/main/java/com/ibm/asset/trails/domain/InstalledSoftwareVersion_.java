package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(InstalledSoftwareVersion.class)
public class InstalledSoftwareVersion_ {
	public static volatile SingularAttribute<InstalledSoftwareVersion, Long> id;
	public static volatile SingularAttribute<InstalledSoftwareVersion, VSoftwareLpar> softwareLpar;
	public static volatile SingularAttribute<InstalledSoftwareVersion, Product> product;
	public static volatile SingularAttribute<InstalledSoftwareVersion, String> version;
}

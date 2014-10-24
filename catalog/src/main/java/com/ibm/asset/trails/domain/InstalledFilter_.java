package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(InstalledFilter.class)
public class InstalledFilter_ {
	public static volatile SingularAttribute<InstalledFilter, Long> id;
	public static volatile SingularAttribute<InstalledFilter, Long> softwareFilterId;
}

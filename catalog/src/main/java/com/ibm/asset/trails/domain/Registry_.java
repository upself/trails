package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.RegistryDataTypeEnum;

@StaticMetamodel(Registry.class)
public class Registry_ {
	public static volatile SingularAttribute<Registry, Long> id;
	public static volatile SingularAttribute<Registry, String> key;
	public static volatile SingularAttribute<Registry, RegistryDataTypeEnum> type;
	public static volatile SingularAttribute<Registry, String> value;
}

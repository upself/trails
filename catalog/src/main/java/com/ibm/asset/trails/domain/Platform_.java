package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.PlatformsEnum;

@StaticMetamodel(Platform.class)
public class Platform_ {
	public static volatile SingularAttribute<Platform, Long> id;
	public static volatile SingularAttribute<Platform, Integer> swkbtId;
	public static volatile SingularAttribute<Platform, PlatformsEnum> name;
}

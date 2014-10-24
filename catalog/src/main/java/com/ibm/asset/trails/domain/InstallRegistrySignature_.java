package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.RegistrySourceEnum;

@StaticMetamodel(InstallRegistrySignature.class)
public class InstallRegistrySignature_ extends Signature_ {
	public static volatile SingularAttribute<InstallRegistrySignature, String> data;
	public static volatile SingularAttribute<InstallRegistrySignature, String> key;
	public static volatile SingularAttribute<InstallRegistrySignature, RegistrySourceEnum> source;
}

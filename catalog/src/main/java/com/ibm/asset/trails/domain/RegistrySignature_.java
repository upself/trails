package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.SignatureOperatorType;

@StaticMetamodel(RegistrySignature.class)
public class RegistrySignature_ extends Signature_ {
	public static volatile SetAttribute<RegistrySignature, Registry> registry;
	public static volatile SingularAttribute<RegistrySignature, SignatureOperatorType> operator;
}

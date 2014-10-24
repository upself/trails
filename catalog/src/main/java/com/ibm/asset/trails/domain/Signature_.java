package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Signature.class)
public class Signature_ extends KbDefinition_ {
	public static volatile SingularAttribute<Signature, Integer> confidenceLevel;
	public static volatile SingularAttribute<Signature, Platform> platformCVersion;
	public static volatile SingularAttribute<Signature, Platform> platformType;
	public static volatile SingularAttribute<Signature, SoftwareItem> softwareItem;
}

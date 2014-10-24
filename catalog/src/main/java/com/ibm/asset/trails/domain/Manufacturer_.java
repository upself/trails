package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Manufacturer.class)
public class Manufacturer_ extends KbDefinition_ {
	public static volatile SetAttribute<Manufacturer, Alias> alias;
	public static volatile SingularAttribute<Manufacturer, String> dId;
	public static volatile SingularAttribute<Manufacturer, String> name;
	public static volatile SingularAttribute<Manufacturer, String> website;
}

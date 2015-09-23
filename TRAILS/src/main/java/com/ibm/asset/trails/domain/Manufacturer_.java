package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Manufacturer.class)
public class Manufacturer_ extends KbDefinition_ {
	public static volatile SingularAttribute<Manufacturer, String> manufacturerName;
	public static volatile SingularAttribute<Manufacturer, String> website;
}

package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(Variation.class)
public class Variation_ extends KbDefinition_ {
	public static volatile SingularAttribute<Variation, Date> activationDate;
	public static volatile SingularAttribute<Variation, Long> release;
	public static volatile SingularAttribute<Variation, String> variation;
}

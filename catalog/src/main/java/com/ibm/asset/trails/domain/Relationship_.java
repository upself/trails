package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

import com.ibm.asset.swkbt.schema.RelationshipTypeEnum;

@StaticMetamodel(Relationship.class)
public class Relationship_ extends KbDefinition_ {
	public static volatile SingularAttribute<Relationship, RelationshipTypeEnum> type;
	public static volatile SingularAttribute<Relationship, SoftwareItem> sinkSoftwareItem;
	public static volatile SingularAttribute<Relationship, SoftwareItem> sourceSoftwareItem;
}

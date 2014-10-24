package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(KbDefinition.class)
public class KbDefinition_ {
	public static volatile SingularAttribute<KbDefinition, Long> id;
	public static volatile SingularAttribute<KbDefinition, Boolean> active;
	public static volatile SingularAttribute<KbDefinition, Date> createdDate;
	public static volatile SingularAttribute<KbDefinition, String> customField1;
	public static volatile SingularAttribute<KbDefinition, String> vendorManaged;
	public static volatile SingularAttribute<KbDefinition, String> customField3;
	public static volatile SingularAttribute<KbDefinition, Integer> dataInput;
	public static volatile SingularAttribute<KbDefinition, String> definitionSource;
	public static volatile SingularAttribute<KbDefinition, Boolean> deleted;
	public static volatile SingularAttribute<KbDefinition, String> description;
	public static volatile SingularAttribute<KbDefinition, String> externalId;
	public static volatile SingularAttribute<KbDefinition, String> guid;
	public static volatile SingularAttribute<KbDefinition, Date> modifiedDate;
}

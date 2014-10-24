package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(CVersionId.class)
public class CVersionId_ {
	public static volatile SingularAttribute<CVersionId, Long> id;
	public static volatile SingularAttribute<CVersionId, String> cVersionId;
	public static volatile SingularAttribute<CVersionId, Long> platform;
}

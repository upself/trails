package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(OtherSignature.class)
public class OtherSignature_ extends Signature_ {
	public static volatile SingularAttribute<OtherSignature, String> body;
	public static volatile SingularAttribute<OtherSignature, String> type;
}

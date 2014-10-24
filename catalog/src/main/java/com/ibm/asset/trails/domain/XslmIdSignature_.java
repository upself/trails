package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(XslmIdSignature.class)
public class XslmIdSignature_ extends Signature_ {
	public static volatile SingularAttribute<XslmIdSignature, String> featureId;
	public static volatile SingularAttribute<XslmIdSignature, String> productId;
	public static volatile SingularAttribute<XslmIdSignature, String> publisherId;
	public static volatile SingularAttribute<XslmIdSignature, String> versionId;
}

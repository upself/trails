package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(MqtOpMetricsSwlm.class)
public class MqtOpMetricsSwlm_ {
	public static volatile SingularAttribute<MqtOpMetricsSwlm, String> id;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Account> account;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, String> displayName;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, String> assetType;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Date> recordTime;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> assigned;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> red;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> yellow;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> green;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> red91;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> red121;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> red151;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> red181;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> red366;
	public static volatile SingularAttribute<MqtOpMetricsSwlm, Integer> assetTotal;
}

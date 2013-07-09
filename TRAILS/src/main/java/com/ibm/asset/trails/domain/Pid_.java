package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Pid.class)
public class Pid_ {
	public static volatile SingularAttribute<Pid, Long> id;
	public static volatile SingularAttribute<Pid, String> pid;
}

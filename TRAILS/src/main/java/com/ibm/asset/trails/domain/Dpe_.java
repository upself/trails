package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Dpe.class)
public class Dpe_ {
	public static volatile SingularAttribute<Dpe, Long> id;
	public static volatile SingularAttribute<Dpe, String> name;
	public static volatile SingularAttribute<Dpe, String> email;
	public static volatile SingularAttribute<Dpe, String> notesMail;
	public static volatile SingularAttribute<Dpe, String> serial;
}

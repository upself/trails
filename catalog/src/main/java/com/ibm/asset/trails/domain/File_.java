package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;

@StaticMetamodel(File.class)
public class File_ {
	public static volatile SingularAttribute<File, Long> id;
	public static volatile SingularAttribute<File, String> name;
	public static volatile SingularAttribute<File, Integer> size;
}

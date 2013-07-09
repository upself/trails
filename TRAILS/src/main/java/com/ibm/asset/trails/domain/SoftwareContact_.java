package com.ibm.asset.trails.domain;

import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(SoftwareContact.class)
public class SoftwareContact_ {
	public static volatile SingularAttribute<SoftwareContact, Long> id;
	public static volatile SingularAttribute<SoftwareContact, String> name;
	public static volatile SingularAttribute<SoftwareContact, String> email;
	public static volatile SingularAttribute<SoftwareContact, String> notesMail;
	public static volatile SingularAttribute<SoftwareContact, String> serial;
}

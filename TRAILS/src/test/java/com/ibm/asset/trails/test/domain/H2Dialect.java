package com.ibm.asset.trails.test.domain;

public class H2Dialect extends org.hibernate.dialect.H2Dialect{
	@Override
	public String getCrossJoinSeparator() {
		return ", ";
	}
}

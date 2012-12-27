package com.ibm.asset.trails.domain;

public class DB2Dialect extends org.hibernate.dialect.DB2Dialect {
	@Override
	public String getCrossJoinSeparator() {
		return ", ";
	}
}

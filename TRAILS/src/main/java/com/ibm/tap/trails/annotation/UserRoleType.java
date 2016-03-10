package com.ibm.tap.trails.annotation;

public enum UserRoleType {

	READER("com.ibm.tap.asset,"
			+ "com.ibm.ea.asset.secure.michelin,"
			+ "com.ibm.tap.asset.ap,"
			+ "com.ibm.tap.asset.emea,"
			+ "com.ibm.tap.asset.group,"
			+ "com.ibm.tap.asset.helpdesk,"
			+ "com.ibm.tap.asset.la"),
	REPORTSREADER("com.ibm.tap.asset,"
			+ "com.ibm.ea.asset.secure.michelin,"
			+ "com.ibm.tap.asset.ap,"
			+ "com.ibm.tap.asset.emea,"
			+ "com.ibm.tap.asset.group,"
			+ "com.ibm.tap.asset.helpdesk,"
			+ "com.ibm.tap.asset.la,"
			+ "com.ibm.tap.bravo.user"),
	EDITOR("com.ibm.tap.asset"), ADMIN("com.ibm.tap.admin");

	private String roleName;

	UserRoleType(String roleName) {
		this.roleName = roleName;
	}

	public String getRoleName() {
		return roleName;
	}
}

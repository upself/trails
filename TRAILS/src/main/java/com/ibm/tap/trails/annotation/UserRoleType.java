package com.ibm.tap.trails.annotation;

public enum UserRoleType {

	READER("com.ibm.tap.trails4"), REPORTSREADER(
			"com.ibm.tap.trails4,com.ibm.tap.bravo.user"), EDITOR(
			"com.ibm.tap.asset"), ADMIN("com.ibm.tap.admin");

	private String roleName;

	UserRoleType(String roleName) {
		this.roleName = roleName;
	}

	public String getRoleName() {
		return roleName;
	}
}

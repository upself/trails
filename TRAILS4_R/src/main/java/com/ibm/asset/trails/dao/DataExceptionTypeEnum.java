package com.ibm.asset.trails.dao;

public enum DataExceptionTypeEnum {
	SOFTWARE_LPAR("ZEROPROC");

	private String code;

	private DataExceptionTypeEnum(String code) {
		this.code = code;
	}

	public String getCode() {
		return code;
	}

}

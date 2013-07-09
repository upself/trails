package com.ibm.asset.trails.action.pagination;


public enum RequestParametersEnum {

	SORT("sort"), PAGE("page"), ASC("asc"), DESC("desc"), DIRECTION("dir");

	private final String value;

	RequestParametersEnum(final String value) {
		this.value = value;
	}

	public String value() {
		return value;
	}

	public static RequestParametersEnum fromValue(final String value) {
		for (RequestParametersEnum c : RequestParametersEnum.values()) {
			if (c.value.equals(value)) {
				return c;
			}
		}
		throw new IllegalArgumentException(value);
	}
}

package com.ibm.asset.trails.dao;

public enum DataExceptionTypeEnum {
	EXP_SCAN("SWLPAR"),HARDWARE("HWARE"),HWNCHP("HWLPAR"),HWNPRC("HWLPAR"),HW_LPAR("HWLPAR"),NCPMDL("HWLPAR"),NOCUST("SWLPAR"),NOLICIBM("INSTSW"),NOLICISV("INSTSW"),NOLP("SWLPAR"),NOOS("SWLPAR"),NOSW("SWLPAR"),NPRCTYP("HWLPAR"),NULLTIME("SWLPAR"),SW_LPAR("SWLPAR"),ZEROPROC("SWLPAR");

	private String level;

	private DataExceptionTypeEnum(String level) {
		this.level = level;
	}

	public String getLevel() {
		return level;
	}

}

package com.ibm.ea.bravo.software;

import java.util.Date;

import com.ibm.ea.sigbank.SoftwareItem;

public class InstalledTadz extends InstalledBase {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5644123551619521856L;
    private int useCount;
	private Date lastUsed;
	private SoftwareItem softwareItem;
	
	public void setSoftwareItem(SoftwareItem softwareItem) {
		this.softwareItem = softwareItem;
	}

	public SoftwareItem getSoftwareItem() {
		return softwareItem;
	}
	
	public int getUseCount() {
		return useCount;
	}

	public void setUseCount(int useCount) {
		this.useCount = useCount;
	}

	public Date getLastUsed() {
		return lastUsed;
	}

	public void setLastUsed(Date lastUsed) {
		this.lastUsed = lastUsed;
	}




}

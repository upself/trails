package com.ibm.ea.bravo.software;

import java.util.Date;
import com.ibm.ea.sigbank.MainframeVersion;

public class InstalledTadz extends InstalledBase {

	/**
	 * 
	 */
	private static final long serialVersionUID = 5644123551619521856L;
    private int useCount;
	private Date lastUsed;
	private MainframeVersion mainframeVersion;

	public void setMainframeVersion(MainframeVersion mainframeVersion) {
		this.mainframeVersion = mainframeVersion;
	}

	public MainframeVersion getMainframeVersion() {
		return mainframeVersion;
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

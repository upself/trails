package com.ibm.ea.bravo.software;

import com.ibm.ea.sigbank.SoftwareScript;

public class InstalledScript extends InstalledBase {

    /**
	 * 
	 */
	private static final long serialVersionUID = 8907486538962987556L;
	private SoftwareScript softwareScript;

	public SoftwareScript getSoftwareScript() {
		return softwareScript;
	}

	public void setSoftwareScript(SoftwareScript softwareScript) {
		this.softwareScript = softwareScript;
	}
}

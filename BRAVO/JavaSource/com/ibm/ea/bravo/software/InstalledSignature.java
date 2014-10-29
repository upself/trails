/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.sigbank.SoftwareSignature;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class InstalledSignature extends InstalledBase {

	/**
     * 
     */
    private static final long serialVersionUID = 6296166450809463565L;

    private SoftwareSignature softwareSignature;

	private String path;

	/**
	 * @return Returns the softwareSignature.
	 */
	public SoftwareSignature getSoftwareSignature() {
		return softwareSignature;
	}

	/**
	 * @param softwareSignature
	 *            The softwareSignature to set.
	 */
	public void setSoftwareSignature(SoftwareSignature softwareSignature) {
		this.softwareSignature = softwareSignature;
	}

	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}
}

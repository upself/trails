/*
 * Created on May 31, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.sigbank.SoftwareFilter;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class InstalledFilter extends InstalledBase {

	/**
     * 
     */
    private static final long serialVersionUID = 4669007683285161606L;
    private SoftwareFilter softwareFilter;

	/**
	 * @return Returns the softwareFilter.
	 */
	public SoftwareFilter getSoftwareFilter() {
		return softwareFilter;
	}
	/**
	 * @param softwareFilter The softwareFilter to set.
	 */
	public void setSoftwareFilter(SoftwareFilter softwareFilter) {
		this.softwareFilter = softwareFilter;
	}
}

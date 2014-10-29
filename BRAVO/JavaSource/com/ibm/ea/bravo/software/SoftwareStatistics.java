/*
 * Created on Jun 26, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class SoftwareStatistics {

	private Long id;
	private SoftwareLpar softwareLpar;
	private Integer installedSoftwareCount;
	
	public Long getId() {
		return id;
	}
	public void setId(Long id) {
		this.id = id;
	}
	public Integer getInstalledSoftwareCount() {
		return installedSoftwareCount;
	}
	public void setInstalledSoftwareCount(Integer installedSoftwareCount) {
		this.installedSoftwareCount = installedSoftwareCount;
	}
	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}
	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}
}

/*
 * Created on Jun 3, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.software;

import com.ibm.ea.bravo.framework.common.OrmBase;

public class SoftwareDiscrepancyH extends OrmBase {

	/**
     * 
     */
    private static final long serialVersionUID = -2617421762970797496L;
    private Long id;
	private InstalledSoftware installedSoftware;
	private String action;
	private String comment;
	
	/**
	 * @return Returns the action.
	 */
	public String getAction() {
		return action;
	}
	/**
	 * @param action The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}
	/**
	 * @return Returns the comment.
	 */
	public String getComment() {
		return comment;
	}
	/**
	 * @param comment The comment to set.
	 */
	public void setComment(String comment) {
		this.comment = comment;
	}
	/**
	 * @return Returns the id.
	 */
	public Long getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
	/**
	 * @return Returns the installedSoftware.
	 */
	public InstalledSoftware getInstalledSoftware() {
		return installedSoftware;
	}
	/**
	 * @param installedSoftware The installedSoftware to set.
	 */
	public void setInstalledSoftware(InstalledSoftware installedSoftware) {
		this.installedSoftware = installedSoftware;
	}
}

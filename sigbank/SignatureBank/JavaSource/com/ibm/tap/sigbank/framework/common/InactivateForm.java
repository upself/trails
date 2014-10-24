/*
 * Created on Apr 29, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.sigbank.framework.common;

import org.apache.struts.validator.ValidatorActionForm;

/**
 * 
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class InactivateForm extends ValidatorActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String softwareSignatureId;

	private String comments;

	/**
	 * @return Returns the comments.
	 */
	public String getComments() {
		return comments;
	}

	/**
	 * @param comments
	 *            The comments to set.
	 */
	public void setComments(String comments) {
		this.comments = comments;
	}

	/**
	 * @return Returns the softwareSignatureId.
	 */
	public String getSoftwareSignatureId() {
		return softwareSignatureId;
	}

	/**
	 * @param softwareSignatureId
	 *            The softwareSignatureId to set.
	 */
	public void setSoftwareSignatureId(String softwareSignatureId) {
		this.softwareSignatureId = softwareSignatureId;
	}
}
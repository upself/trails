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
public class ActivateForm extends ValidatorActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String id;

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
	 * @return Returns the id.
	 */
	public String getId() {
		return id;
	}

	/**
	 * @param id
	 *            The id to set.
	 */
	public void setId(String id) {
		this.id = id;
	}
}
/*
 * Created on Jun 2, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.access;

import com.ibm.ea.bravo.framework.common.FormBase;

/**
 * @author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class FormAccess extends FormBase {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	public String comment;

	/**
	 * @return Returns the comment.
	 */
	public String getComment() {
		return this.comment;
	}

	/**
	 * @param comment
	 *            The comment to set.
	 */
	public void setComment(String comment) {
		this.comment = comment;
	}
}

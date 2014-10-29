/*
 * Created on Jun 3, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.access;

import com.ibm.ea.bravo.framework.common.OrmBase;

public class AccessH extends OrmBase {

    private static final long serialVersionUID = 486259640369933364L;
    private Long id;
	private String comment;
	
	/**
	 * @return Returns the comment.
	 */
	public String getComment() {
		return this.comment;
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
		return this.id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(Long id) {
		this.id = id;
	}
}

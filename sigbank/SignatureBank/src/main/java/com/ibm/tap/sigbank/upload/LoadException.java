/*
 * Created on May 28, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.sigbank.upload;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class LoadException extends Throwable {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	String string;

	public LoadException(String string) {
		this.string = string;
	}

	public String getString() {
		return string;
	}

}
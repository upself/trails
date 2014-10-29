/*
 * Created on Jun 19, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.machinetype;

/**
 * @author iddadmin
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Status {

	private String status;
	
	Status(){}
	
	Status(String status) {
		this();
		setStatus(status);
	}
	
	public String getLabel() {
		return status;
	}
	
	public String getValue() {
		return status;
	}

	
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
}

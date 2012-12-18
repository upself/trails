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
public class Type {

	private String type;
	
	Type() {}
	
	Type(String type) {
		this();
		setType(type);
	}
	
	public String getLabel() {
		return type;
	}
	
	public String getValue() {
		return type;
	}

	
	
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}
}

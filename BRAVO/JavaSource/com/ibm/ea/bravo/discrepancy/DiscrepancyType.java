/*
 * Created on May 25, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.discrepancy;

import com.ibm.ea.bravo.framework.common.OrmBase;

/**
 * @author donnie
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class DiscrepancyType extends OrmBase {
	/**
     * 
     */
    private static final long serialVersionUID = 3607353642178369275L;
    private Long id;
	private String name;

	public String getLabel() {
		return getName();
	}
	
	public String getValue() {
		return getId().toString();
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
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return this.name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
}

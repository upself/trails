/*
 * Created on Feb 8, 2005
 *
 *  go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.cndb;

import java.io.Serializable;
/**
 * @author denglers
 *
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class Country implements Serializable {

	private static final long serialVersionUID = 1L;
	private Long id;
	private String name;
	
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
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
}

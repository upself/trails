/*
 * Created on Feb 8, 2005
 *
 *  go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.cndb;

/**
 * @author denglers
 *
 * 
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class AssetProcess {

	private Long id;
	private String name;
	private String description;
	
	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}
	/**
	 * @param description The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
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

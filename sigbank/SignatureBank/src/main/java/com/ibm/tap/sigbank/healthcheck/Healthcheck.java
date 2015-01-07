/*
 * Created on Oct 14, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.healthcheck;

import java.util.Date;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Healthcheck {
	private String key;

	private String description;

	private String severity;

	private Date timestamp;

	/**
	 * @return Returns the description.
	 */
	public String getDescription() {
		return description;
	}

	/**
	 * @param description
	 *            The description to set.
	 */
	public void setDescription(String description) {
		this.description = description;
	}

	/**
	 * @return Returns the key.
	 */
	public String getKey() {
		return key;
	}

	/**
	 * @param key
	 *            The key to set.
	 */
	public void setKey(String key) {
		this.key = key;
	}

	/**
	 * @return Returns the severity.
	 */
	public String getSeverity() {
		return severity;
	}

	/**
	 * @param severity
	 *            The severity to set.
	 */
	public void setSeverity(String severity) {
		this.severity = severity;
	}

	/**
	 * @return Returns the timestamp.
	 */
	public Date getTimestamp() {
		return timestamp;
	}

	/**
	 * @param timestamp
	 *            The timestamp to set.
	 */
	public void setTimestamp(Date timestamp) {
		this.timestamp = timestamp;
	}
}

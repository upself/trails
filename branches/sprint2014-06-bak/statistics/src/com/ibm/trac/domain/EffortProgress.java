/**
 * 
 */
package com.ibm.trac.domain;

import java.util.Date;

/**
 * @author zhangyi
 * 
 */
public class EffortProgress {

	private long id;
	private Sprint sprint;
	private Date time;
	private float effort;

	public Sprint getSprint() {
		return sprint;
	}

	public void setSprint(Sprint sprint) {
		this.sprint = sprint;
	}

	public Date getTime() {
		return time;
	}

	public void setTime(Date time) {
		this.time = time;
	}

	public float getEffort() {
		return effort;
	}

	public void setEffort(float effort) {
		this.effort = effort;
	}

	/**
	 * @return the id
	 */
	public long getId() {
		return id;
	}

	/**
	 * @param id
	 *            the id to set
	 */
	public void setId(long id) {
		this.id = id;
	}

}

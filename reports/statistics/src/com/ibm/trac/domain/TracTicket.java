/**
 * 
 */
package com.ibm.trac.domain;

/**
 * @author zhangyi
 * 
 */
public class TracTicket {

	private long id;
	private float estimate;
	private float progress;

	public long getId() {
		return id;
	}

	public void setId(long id) {
		this.id = id;
	}

	public float getEstimate() {
		return estimate;
	}

	public void setEstimate(float estimate) {
		this.estimate = estimate;
	}

	public float getProgress() {
		return progress;
	}

	public void setProgress(float progress) {
		this.progress = progress;
	}

}

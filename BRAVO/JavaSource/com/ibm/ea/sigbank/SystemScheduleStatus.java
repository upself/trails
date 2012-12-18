package com.ibm.ea.sigbank;

import java.io.Serializable;
import java.sql.Timestamp;

public class SystemScheduleStatus implements Serializable {
	private static final long serialVersionUID = 1L;

	private Long id;

	private String name;

	private String comments;

	private Timestamp startTime;

	private Timestamp endTime;

	private String status;

	public String getElapsedTime() {
		if (this.getEndTime() == null) {
			return "";
		} else {
			return new StringBuffer(String
					.valueOf((getEndTime().getTime() - getStartTime().getTime())
							/ (1000 * 60))).append(" minutes").toString(); 
		}
	}

	public String getComments() {
		return comments;
	}

	public void setComments(String comments) {
		this.comments = comments;
	}

	public Timestamp getEndTime() {
		return endTime;
	}

	public void setEndTime(Timestamp endTime) {
		this.endTime = endTime;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public Timestamp getStartTime() {
		return startTime;
	}

	public void setStartTime(Timestamp startTime) {
		this.startTime = startTime;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}
}

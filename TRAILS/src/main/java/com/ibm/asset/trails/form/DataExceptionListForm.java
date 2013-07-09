package com.ibm.asset.trails.form;

public class DataExceptionListForm {

	private boolean assign;

	private boolean beenAssigned;

	private Long id;

	private String assignee;

	public boolean isAssign() {
		return assign;
	}

	public void setAssign(boolean assign) {
		this.assign = assign;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public boolean isBeenAssigned() {
		return beenAssigned;
	}

	public void setBeenAssigned(boolean beenAssigned) {
		this.beenAssigned = beenAssigned;
	}

	public void setAssignee(String assignee) {
		this.assignee = assignee;
	}

	public String getAssignee() {
		return assignee;
	}
}
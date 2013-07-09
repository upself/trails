package com.ibm.asset.trails.form;

public class AlertListForm {

	private boolean assign;

	private boolean unassign;

	private Long id;

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

	public boolean isUnassign() {
		return unassign;
	}

	public void setUnassign(boolean unassign) {
		this.unassign = unassign;
	}

}

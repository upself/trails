package com.ibm.asset.trails.action;

import com.opensymphony.xwork2.ActionSupport;

//TODO need to go verify user roles are properly set on all the actions
public class BaseAction extends ActionSupport {

	private static final long serialVersionUID = 1L;

	private String bravoServerName;

	private String cndbServerName;

	private String trailsFileServerName;

	private String trailsServerName;

	public String getBravoServerName() {
		return bravoServerName;
	}

	public void setBravoServerName(String bravoServerName) {
		this.bravoServerName = bravoServerName;
	}

	public String getCndbServerName() {
		return cndbServerName;
	}

	public void setCndbServerName(String cndbServerName) {
		this.cndbServerName = cndbServerName;
	}

	public String getTrailsFileServerName() {
		return trailsFileServerName;
	}

	public void setTrailsFileServerName(String trailsFileServerName) {
		this.trailsFileServerName = trailsFileServerName;
	}

	public String getTrailsServerName() {
		return trailsServerName;
	}

	public void setTrailsServerName(String trailsServerName) {
		this.trailsServerName = trailsServerName;
	}
}

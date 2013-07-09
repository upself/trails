package com.ibm.asset.trails.action;

import org.apache.struts2.convention.annotation.ParentPackage;

import com.opensymphony.xwork2.ActionSupport;

@ParentPackage("trails-struts-default")
public abstract class AbstractBaseAction extends ActionSupport {
	private static final long serialVersionUID = -2095096549427540340L;
	public static final String TILES = "tiles";
	public static final String STREAM_RESULT = "stream";

}

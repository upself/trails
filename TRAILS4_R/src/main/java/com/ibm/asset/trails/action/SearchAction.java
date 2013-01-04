package com.ibm.asset.trails.action;

import com.opensymphony.xwork2.Preparable;

public interface SearchAction extends Preparable {

	public String execute();

	public String search() throws Exception;
}

package com.ibm.ea.bravo.systemstatus;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.FormBase;

public class FormSubmit extends FormBase{
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private static final Logger logger = Logger.getLogger(FormSubmit.class);
	
	//declare fields
	private String bankAccount;
	private String moduleLoader;
	private String loaderStatus;
	private boolean delta_checkbox;
	private String date_from;
	private String date_to;
	
	public FormSubmit(){
		//init fields
		logger.debug("FormSubmit - init");
		
		bankAccount = "";
		moduleLoader = "";
		loaderStatus = "";
		delta_checkbox = false;
		date_from = "";
		date_to = "";
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		//reset function, not currently used
		bankAccount = "";
		moduleLoader = "";
		loaderStatus = "";
		delta_checkbox = false;
		date_from = "";
		date_to = "";
	}
	
	//getters/setters
	public String getBankAccount() {
		return bankAccount;
	}

	public void setBankAccount(String bankAccount) {
		this.bankAccount = bankAccount;
	}

	public String getModuleLoader() {
		return moduleLoader;
	}
	public void setModuleLoader(String moduleLoader) {
		this.moduleLoader = moduleLoader;
	}
	
	public String getLoaderStatus() {
		return loaderStatus;
	}

	public void setLoaderStatus(String loaderStatus) {
		this.loaderStatus = loaderStatus;
	}
	public boolean isDelta_checkbox() {
		return delta_checkbox;
	}

	public void setDelta_checkbox(boolean delta_checkbox) {
		this.delta_checkbox = delta_checkbox;
	}

	public String getDate_from() {
		return date_from;
	}

	public void setDate_from(String date_from) {
		this.date_from = date_from;
	}

	public String getDate_to() {
		return date_to;
	}

	public void setDate_to(String date_to) {
		this.date_to = date_to;
	}
}
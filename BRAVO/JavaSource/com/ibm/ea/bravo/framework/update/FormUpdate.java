package com.ibm.ea.bravo.framework.update;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.FormBase;

public class FormUpdate extends FormBase {
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(FormUpdate.class);

	protected String string;
	protected String type;
	protected String source;
	
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		logger.debug("FormSearch.validate");
		
		ActionErrors errors = new ActionErrors();
		
		// cleanup search string and type
		this.string = this.string.trim();
		this.type = this.type.trim();
		logger.debug("FormUpdate.validate string and type:" + this.string + " - " + this.type);
		
		
		logger.debug("FormSearch.validate errors = " + errors);
		return errors;
	}
	
	public void reset(ActionMapping mapping, HttpServletRequest request) {
		setString("");
		setType("");
		setSource("");
	}
	


	/**
	 * @return Returns the logger.
	 */
	public static Logger getLogger() {
		return logger;
	}
	/**
	 * @return Returns the source.
	 */
	public String getSource() {
		return this.source;
	}
	/**
	 * @param source The source to set.
	 */
	public void setSource(String source) {
		this.source = source;
	}
	/**
	 * @return Returns the string.
	 */
	public String getString() {
		return this.string;
	}
	/**
	 * @param string The string to set.
	 */
	public void setString(String string) {
		this.string = string;
	}
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return this.type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}
}

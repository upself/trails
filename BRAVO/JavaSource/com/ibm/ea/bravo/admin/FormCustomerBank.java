/*
 * Created on Jun 2, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.admin;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bravo.framework.common.FormBase;

/**
 * @author donnie
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FormCustomerBank extends FormBase {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String[] selected;
	private String[] selectedIncludes;
	
		
	private static final Logger logger = Logger.getLogger(FormCustomerBank.class);
	
	//****************************
	//Constructors
    //****************************
	public FormCustomerBank() { }

			
	
	public String[] getSelected() {
		return selected;
	}

	public void setSelected(String[] selected) {
		this.selected = selected;
	}


	public String[] getSelectedIncludes() {
		return selectedIncludes;
	}



	public void setSelectedIncludes(String[] selectedIncludes) {
		this.selectedIncludes = selectedIncludes;
	}



	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();
		logger.debug("FormCustomerBank.validate");
		
		
		return errors;
	}	
	
	public ActionErrors init(FormCustomerBank machineType) throws Exception {
		logger.debug("FormCustomerBank.init");

		ActionErrors errors = init();		
		
		
		return errors;
	}
	
	
	public ActionErrors init() throws Exception {

		ActionErrors errors = new ActionErrors();
		logger.debug("FormCustomerBank.init");
		setSelected(null);
		setSelectedIncludes(null);
		return errors;
	}
	
}

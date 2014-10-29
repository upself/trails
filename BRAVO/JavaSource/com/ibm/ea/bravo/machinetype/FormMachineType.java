/*
 * Created on Jun 2, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.machinetype;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.common.FormBase;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
public class FormMachineType extends FormBase {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String id;
	private String name;
	private String status;
	private String definition;
	private String type;
	
	private String action;
	private String search;
	private String searchtype;
	private String context;
	
	
	private List<Type> typeList;
	private List<Status> statusList;
	
	private static final Logger logger = Logger.getLogger(FormMachineType.class);
	
	//****************************
	//Constructors
    //****************************
	public FormMachineType() { }
	
	public FormMachineType(String machineTypeID) {
		this();
		this.id = machineTypeID;
	}
	

	public String getStatusImage() {
		if (status.equals(Constants.ACTIVE))
			return "<img alt=\"" + Constants.ACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_OK + "\" width=\"12\" height=\"10\"/>";
		else
			return "<img alt=\"" + Constants.INACTIVE + "\" src=\"" + Constants.ICON_SYSTEM_STATUS_NA + "\" width=\"12\" height=\"10\"/>";
	}

	public String getStatusIcon() {
		if (status.equals(Constants.ACTIVE))
			return Constants.ICON_SYSTEM_STATUS_OK;
		else
			return Constants.ICON_SYSTEM_STATUS_NA;
	}
	
	
	public ActionErrors validate(ActionMapping mapping, HttpServletRequest request) {
		ActionErrors errors = new ActionErrors();
		logger.debug("FormMachineType.validate");
		
		name = name.trim().toUpperCase();
		definition = definition.trim();
		
		//Required Fields
		if (EaUtils.isBlank(name)) {
			errors.add(Constants.NAME, new ActionMessage(Constants.REQUIRED));
		} else {
			//name must be unique
			MachineType mt = DelegateMachineType.getMachineTypeByName(name);
			
			// if the database machine type exists and the id is different than the current id
			if (mt != null) {
				if (action.equalsIgnoreCase(Constants.CRUD_CREATE)) {
					errors.add(Constants.NAME, new ActionMessage(Constants.MACHINE_TYPE_EXISTS));
				} else if (!EaUtils.isBlank(id) && ! mt.getId().equals(Long.valueOf(id))) {
					errors.add(Constants.NAME, new ActionMessage(Constants.MACHINE_TYPE_EXISTS));
				}
			}
		}
		
		return errors;
	}	
	
	public ActionErrors init(FormMachineType machineType) throws Exception {

		ActionErrors errors = init();		
		
		if (errors.isEmpty()) {
			
			// overwrite the data from the user
			name = machineType.getName();
			status = machineType.getStatus();
			definition = machineType.getDefinition();
			type = machineType.getType();
			context = machineType.getContext();
			action = machineType.getAction();
		}
				
		//UCASE the Key Fields
		setName(name.toUpperCase());
		
		if (! EaUtils.isBlank(type)){
			setType(type.toUpperCase());
		}
		if (! EaUtils.isBlank(status)){
			setStatus(status.toUpperCase());
		}
		
		return errors;
	}
	
	
	public ActionErrors init() throws Exception {

		ActionErrors errors = new ActionErrors();
		
		// initialize the form with the data
		if (id != null && ! id.equals("")) {
	    	MachineType machinetype = (MachineType) DelegateMachineType.getMachineType(id);
	    	BeanUtils.copyProperties(this, machinetype);
		}
		
		logger.debug("FormMachineType.init - filling drop down lists");
		
		// initialize drop downs
		typeList = DelegateMachineType.getTypeList();
		statusList=DelegateMachineType.getStatusList();
			
		//UCASE the Key Fields
		if (! EaUtils.isBlank(name)){
			setName(name.toUpperCase());
		}
		
		if (! EaUtils.isBlank(type)){
			setType(type.toUpperCase());
		}
		if (! EaUtils.isBlank(status)){
			setStatus(status.toUpperCase());
		}
		
		return errors;
	}
	
	





	/**
	 * @return Returns the action.
	 */
	public String getAction() {
		return action;
	}
	/**
	 * @param action The action to set.
	 */
	public void setAction(String action) {
		this.action = action;
	}
	/**
	 * @return Returns the context.
	 */
	public String getContext() {
		return context;
	}
	/**
	 * @param context The context to set.
	 */
	public void setContext(String context) {
		this.context = context;
	}
	/**
	 * @return Returns the definition.
	 */
	public String getDefinition() {
		return definition;
	}
	/**
	 * @param definition The definition to set.
	 */
	public void setDefinition(String definition) {
		this.definition = definition;
	}
	/**
	 * @return Returns the id.
	 */
	public String getId() {
		return id;
	}
	/**
	 * @param id The id to set.
	 */
	public void setId(String id) {
		this.id = id;
	}
	/**
	 * @return Returns the name.
	 */
	public String getName() {
		return name;
	}
	/**
	 * @param name The name to set.
	 */
	public void setName(String name) {
		this.name = name;
	}
	/**
	 * @return Returns the search.
	 */
	public String getSearch() {
		return search;
	}
	/**
	 * @param search The search to set.
	 */
	public void setSearch(String search) {
		this.search = search;
	}
	/**
	 * @return Returns the searchtype.
	 */
	public String getSearchtype() {
		return searchtype;
	}
	/**
	 * @param searchtype The searchtype to set.
	 */
	public void setSearchtype(String searchtype) {
		this.searchtype = searchtype;
	}
	/**
	 * @return Returns the status.
	 */
	public String getStatus() {
		return status;
	}
	/**
	 * @param status The status to set.
	 */
	public void setStatus(String status) {
		this.status = status;
	}
	/**
	 * @return Returns the statusList.
	 */
	public List<Status> getStatusList() {
		return statusList;
	}
	/**
	 * @param statusList The statusList to set.
	 */
	public void setStatusList(List<Status> statusList) {
		this.statusList = statusList;
	}
	/**
	 * @return Returns the type.
	 */
	public String getType() {
		return type;
	}
	/**
	 * @param type The type to set.
	 */
	public void setType(String type) {
		this.type = type;
	}
	/**
	 * @return Returns the typeList.
	 */
	public List<Type> getTypeList() {
		return typeList;
	}
	/**
	 * @param typeList The typeList to set.
	 */
	public void setTypeList(List<Type> typeList) {
		this.typeList = typeList;
	}
}

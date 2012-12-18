package com.ibm.ea.bravo.machinetype;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;

import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class ActionMachineType extends ActionBase {

	private static final Logger logger = Logger.getLogger(ActionMachineType.class);
	
    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionMachineType.home");
    	
        return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward edit(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
		
		logger.debug("ActionMachineType.edit");
		FormMachineType mtype = null;
    	ActionErrors errors = new ActionErrors();
		
		//Get some of our parameters that we pass around
		String id = getParameter(request, Constants.ID);
		String action = getParameter(request, Constants.ACTION);
		String searchparam = getParameter(request, Constants.SEARCH);
		String searchtype = getParameter(request, Constants.SEARCHTYPE);
		String context = getParameter(request, Constants.CONTEXT);
		
    	// cast the form
    	FormMachineType mtForm = (FormMachineType) form;

    	// validate the form exists
    	if (form == null) {
    		return mapping.findForward(Constants.INVALID);
    	}

    	// if the user canceled the edit, return them to a previous screen
		logger.debug("ActionMachineType.edit form.action = " + mtForm.getAction());
		if (mtForm.getAction().equalsIgnoreCase(Constants.CANCEL)) {
    		
    		// if the ID field is in the form then we know we are either
			//updating or deleting so we can return to the detail page
			logger.debug("ActionMachineType.edit user clicked cancel - action = " + action);
			
			request.setAttribute(Constants.SEARCH, searchparam);
			request.setAttribute(Constants.SEARCHTYPE, searchtype);
			request.setAttribute(Constants.ACTION, Constants.CRUD_VIEW);
			request.setAttribute(Constants.CONTEXT, context);
			request.setAttribute(Constants.ID, id);
			
            if (!EaUtils.isBlank(mtForm.getId())){
    			logger.debug("ActionMachineType.edit user clicked cancel - id is NOT blank");
    			logger.debug("ActionMachineType.edit user clicked cancel - context is " + mtForm.getContext());
    			return mapping.findForward(Constants.SUCCESS);            	
            }else{
    			logger.debug("ActionMachineType.edit user clicked cancel - id is blank");
    			logger.debug("ActionMachineType.edit user clicked cancel - context is " + mtForm.getContext());
    			if (mtForm.getContext().equalsIgnoreCase(Constants.LIST)){
    				List<MachineType> list = DelegateMachineType.search(searchtype, searchparam);
    				request.setAttribute(Constants.LIST, list);
                	return mapping.findForward(Constants.LIST);
                }else{
                	//Get our previous result
                	MachineType machineType = DelegateMachineType.getMachineType(mtForm.getContext());
                	mtForm.setId(mtForm.getContext());
                	mtForm.setName(machineType.getName());
                	mtForm.setType(machineType.getType());
                	mtForm.setDefinition(machineType.getDefinition());
                	
                	return mapping.findForward(Constants.SUCCESS);     				
    			}

            }
    	}
		
		// initialize the form
		FormMachineType machineType = new FormMachineType(mtForm.getId());
		logger.debug("machineType = " + machineType);
		request.setAttribute(Constants.MACHINETYPE, machineType);
		machineType.setSearch(searchparam);
		machineType.setSearchtype(searchtype);
    	errors = machineType.init(mtForm);
    	
		// TODO more here
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}

    	// validate the form
		logger.debug("ActionMachineType.edit validate");
    	errors = machineType.validate(mapping, request);
    	
		// if there were errors, return them to the user
		if (!errors.isEmpty()) {
    		saveErrors(request, errors);
    		
			request.setAttribute(Constants.SEARCH, searchparam);
			request.setAttribute(Constants.SEARCHTYPE, searchtype);
	    	request.setAttribute(Constants.CONTEXT, context);
			request.setAttribute(Constants.ACTION, action);
			request.setAttribute(Constants.ID, id);
    		
    		return mapping.findForward(Constants.ERROR);
    	}
		
		// no errors, save the changes to the database
		machineType.setRemoteUser(request.getRemoteUser());
		
		if ((machineType.getId().equalsIgnoreCase("") || machineType.getId() == null) && machineType.getAction().equalsIgnoreCase(Constants.CRUD_CREATE)){
			machineType.setId(null);
		}

		logger.debug("ActionMachineType.edit Save or Delete");
		if (action.equalsIgnoreCase(Constants.CRUD_DELETE)){
//			mtype = DelegateMachineType.delete(mtForm);
			machineType.setStatus(Constants.INACTIVE);
			mtype = DelegateMachineType.save(machineType);
			List<MachineType> list = DelegateMachineType.search(searchtype,searchparam);
			request.setAttribute(Constants.SEARCH, searchparam);
			request.setAttribute(Constants.SEARCHTYPE, searchtype);
			request.setAttribute(Constants.ACTION, Constants.CRUD_VIEW);
			request.setAttribute(Constants.LIST,list);
			request.setAttribute(Constants.MACHINETYPE, mtype);
			return mapping.findForward(Constants.LIST);
		}else{
			mtype = DelegateMachineType.save(machineType);
		}

	    // return the form in the request
		// and set our title, buttons, etc...
		request.setAttribute(Constants.SEARCH, searchparam);
		request.setAttribute(Constants.SEARCHTYPE, searchtype);
		request.setAttribute(Constants.ACTION, Constants.CRUD_VIEW);
		request.setAttribute(Constants.ID, machineType.getId());
		request.setAttribute(Constants.MACHINETYPE, machineType);					


		
		// if the save was unsuccessful
		if (mtype == null && ! action.equalsIgnoreCase(Constants.CRUD_DELETE)) {
			mtype = new FormMachineType(machineType.getId());
			request.setAttribute(Constants.MACHINETYPE, mtype);
			errors = mtype.init(machineType);
			errors.add(Constants.DB, new ActionMessage(Constants.UNKNOWN_DB_ERROR));
			saveErrors(request, errors);

			return mapping.findForward(Constants.ERROR);
		}
		
		// if the save was successful, initialize the rest of the form
		errors = mtype.init();
		
		// make sure we initialized okay
		if (! errors.isEmpty()) {
			errors.add(Constants.DB, new ActionMessage(Constants.UNKNOWN_DB_ERROR));
			saveErrors(request, errors);

			return mapping.findForward(Constants.ERROR);
		}
		

		logger.debug("ActionMachineType.edit leaving the form - action=" + action);
		if (action.equalsIgnoreCase(Constants.CRUD_UPDATE)){
			return mapping.findForward(Constants.SUCCESS);
		}

		if (action.equalsIgnoreCase(Constants.CRUD_DELETE)){
			return mapping.findForward(Constants.LIST);
		}

		if (action.equalsIgnoreCase(Constants.CRUD_CREATE)){
			return mapping.findForward(Constants.SUCCESS);
		}
		
		
		return mapping.findForward(Constants.ERROR);			
	}


	public ActionForward view(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

		logger.debug("ActionMachineType.view");
		
		String id = getParameter(request, Constants.ID);
		String action = getParameter(request, Constants.ACTION);
		String searchparam = getParameter(request, Constants.SEARCH);
		String searchtype = getParameter(request, Constants.SEARCHTYPE);
		logger.debug("ActionMachineType.view id=" + id);
		logger.debug("ActionMachineType.view action=" + action);
		logger.debug("ActionMachineType.view searchparam=" + searchparam);
		logger.debug("ActionMachineType.view searchtype=" + searchtype);
		

		if (! EaUtils.isBlank(id)) {
			
			// create the form
			FormMachineType mtForm = new FormMachineType(id);

			request.setAttribute(Constants.MACHINETYPE, mtForm);
			ActionErrors errors = mtForm.init();

			// if there are errors, return there
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}
	
	    	// return the form in the request
			// and set our title, buttons, etc...
			request.setAttribute(Constants.SEARCH, searchparam);
			request.setAttribute(Constants.SEARCHTYPE, searchtype);
			request.setAttribute(Constants.ACTION, action);
			
			
			return mapping.findForward(Constants.SUCCESS);	

			
		}

		return mapping.findForward(Constants.ERROR);
	
	}

	
	public ActionForward cancel_search(ActionMapping mapping, HttpServletRequest request, 
			String action, String string)
            throws Exception {
    	logger.debug("ActionMachineType.cancel_search");
    	// get results
    	List<MachineType> list = DelegateMachineType.search(action, string);
    	logger.debug("ActionMachineType.quicksearch list.size = " + list.size());
    	
    	
    	request.setAttribute(Constants.SEARCH_PARAM, string);
    	request.setAttribute(Constants.SEARCHTYPE, action);
       	request.setAttribute(Constants.LIST, list);
    	return mapping.findForward(Constants.LIST);
    }

	
	public ActionForward quicksearch(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionMachineType.quicksearch");
		String action = getParameter(request, Constants.ACTION);
    	String search = getParameter(request, Constants.SEARCH);
    	String searchtype = getParameter(request, Constants.SEARCHTYPE);
    	logger.debug("searchType = " + searchtype);
   	
    	// determine result size
    	
    	
    	// get results
    	List<MachineType> list = DelegateMachineType.search(searchtype, search);
    	logger.debug("ActionMachineType.quicksearch list.size = " + list.size());
    	
    	
       	request.setAttribute(Constants.LIST, list);
    	request.setAttribute(Constants.SEARCH, search);
    	request.setAttribute(Constants.SEARCHTYPE, searchtype);
    	request.setAttribute(Constants.ACTION, action);
    	return mapping.findForward(Constants.SUCCESS);
    }	
	
	public ActionForward search(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionMachineType.search");
    	
    	// cast the form
    	FormMachineTypeSearch searchForm = (FormMachineTypeSearch) form;
    	String searchparam=searchForm.getSearch();
    	String searchtype=searchForm.getType();
    	String action = "List";
    	logger.debug("ActionMachineType.search searchparam=" + searchparam);
   	
    	// validate the form - Not sure why we are validating the form at this point
       	ActionErrors errors = new ActionErrors();
    	logger.debug("ActionMachineType.search about to validate");
    	errors = searchForm.validate(mapping, request);
    	if (! errors.isEmpty()) {
    		logger.debug("ActionMachineType.search Errors" + errors);
    		saveErrors(request, errors);
	    	return mapping.findForward(Constants.ERROR);
    	}
    	
    	// determine result size
    	
    	
    	// get results
    	List<MachineType> list = DelegateMachineType.search(searchForm.getType(), searchForm.getSearch());
    	logger.debug("ActionMachineType.search list.size = " + list.size());
    	
    	
       	request.setAttribute(Constants.LIST, list);
    	request.setAttribute(Constants.SEARCH, searchparam);
    	request.setAttribute(Constants.SEARCHTYPE, searchtype);
    	request.setAttribute(Constants.ACTION,action);
    	return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward create(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionMachineType.create");

    	ActionErrors errors = new ActionErrors();

 
    	//get our main params
		String id = getParameter(request, Constants.ID);
		String searchparam = getParameter(request, Constants.SEARCH);
		String searchtype = getParameter(request, Constants.SEARCHTYPE);
		String context = getParameter(request, Constants.CONTEXT);
    	logger.debug("ActionMachineType.create id= " + id);
    	logger.debug("ActionMachineType.create searchtype= " + searchtype);
    	logger.debug("ActionMachineType.create searchparam= " + searchparam);
    	logger.debug("ActionMachineType.create context= " + context);
    	
    	
    	// cast the action form
    	//MachineType machineType = new MachineType();
    	
    	FormMachineType mtForm = new FormMachineType();
    	errors = mtForm.init();

		// if there are errors, return there
		if (!errors.isEmpty()) {
			saveErrors(request, errors);
			return mapping.findForward(Constants.ERROR);
		}
    	
    	
		// initialize action specific form properties
		String action = Constants.CRUD_CREATE;
		mtForm.setAction(Constants.CRUD_CREATE);
		mtForm.setSearch(searchparam);
		mtForm.setSearchtype(searchtype);
		mtForm.setContext(context);

		request.setAttribute(Constants.MACHINETYPE, mtForm);		
    	request.setAttribute(Constants.SEARCH, searchparam);
    	request.setAttribute(Constants.SEARCHTYPE, searchtype);
    	request.setAttribute(Constants.CONTEXT, context);
    	request.setAttribute(Constants.ACTION,action);
		
		return mapping.findForward(Constants.SUCCESS);

    }    
	
    public ActionForward update(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionMachineType.update");
		
		String id = getParameter(request, Constants.ID);
		String searchparam = getParameter(request, Constants.SEARCH);
		String searchtype = getParameter(request, Constants.SEARCHTYPE);
		String context = getParameter(request, Constants.CONTEXT);
    	logger.debug("ActionMachineType.update id= " + id);
    	logger.debug("ActionMachineType.update searchtype= " + searchtype);
    	logger.debug("ActionMachineType.update searchparam= " + searchparam);
    	logger.debug("ActionMachineType.update context= " + context);
		

		if (! EaUtils.isBlank(id)) {
			//We know we are editing the form
			
			// create the form
			FormMachineType mtForm = new FormMachineType(id);
			mtForm.setAction(Constants.CRUD_UPDATE);
			mtForm.setSearch(searchparam);
			mtForm.setSearchtype(searchtype);
			mtForm.setContext(context);
			
			request.setAttribute(Constants.MACHINETYPE, mtForm);
			ActionErrors errors = mtForm.init();

			// if there are errors, return there
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}
	
	    	// return the form in the request
			// and set our title, buttons, etc...
			request.setAttribute(Constants.SEARCH, searchparam);
			request.setAttribute(Constants.SEARCHTYPE, searchtype);
	    	request.setAttribute(Constants.CONTEXT, context);
	    	request.setAttribute(Constants.ACTION, Constants.CRUD_UPDATE);
			
			
			return mapping.findForward(Constants.SUCCESS);			
		}

		return mapping.findForward(Constants.ERROR);
    	
    }    
	
    public ActionForward cancel_edit(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {

       	logger.debug("ActionMachineType.delete");

       	String searchparam = getParameter(request, Constants.SEARCH);
		String searchtype = getParameter(request, Constants.SEARCHTYPE);
		       	
    	FormMachineType machineTypeForm = (FormMachineType) form;
      	    	
    	//reset the form
    	machineTypeForm.setLocked(Constants.TRUE);
    	machineTypeForm.setFormTitle(Constants.CRUD_VIEW);
    	machineTypeForm.createButtons(Constants.VIEW_BUTTONS);
    	
    	// return the form in the request
		request.setAttribute(Constants.MACHINETYPE, machineTypeForm);
		request.setAttribute(Constants.SEARCH, searchparam);
		request.setAttribute(Constants.SEARCHTYPE, searchtype);
		request.setAttribute(Constants.FORMBUTTONS, machineTypeForm.getFormButtons());
		
    	return mapping.findForward(Constants.SUCCESS);       	
    	
    }
    
    public ActionForward delete(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionMachineType.delete");
		
		String id = getParameter(request, Constants.ID);
		String searchparam = getParameter(request, Constants.SEARCH);
		String searchtype = getParameter(request, Constants.SEARCHTYPE);
		String context = getParameter(request, Constants.CONTEXT);
    	logger.debug("ActionMachineType.update id= " + id);
    	logger.debug("ActionMachineType.update searchtype= " + searchtype);
    	logger.debug("ActionMachineType.update searchparam= " + searchparam);
    	logger.debug("ActionMachineType.update context= " + context);
		

		if (! EaUtils.isBlank(id)) {
			//We know we are editing the form
			
			// create the form
			FormMachineType mtForm = new FormMachineType(id);
			mtForm.setAction(Constants.CRUD_DELETE);
			mtForm.setSearch(searchparam);
			mtForm.setSearchtype(searchtype);
			mtForm.setContext(context);
//			mtForm.getReadOnly().put(Constants.NAME, Constants.TRUE);
//			mtForm.getReadOnly().put(Constants.TYPE, Constants.TRUE);
//			mtForm.getReadOnly().put(Constants.DEFINITION, Constants.TRUE);
			
			
			request.setAttribute(Constants.MACHINETYPE, mtForm);
			ActionErrors errors = mtForm.init();

			// if there are errors, return there
			if (!errors.isEmpty()) {
				saveErrors(request, errors);
				return mapping.findForward(Constants.ERROR);
			}
	
	    	// return the form in the request
			// and set our title, buttons, etc...
			request.setAttribute(Constants.SEARCH, searchparam);
			request.setAttribute(Constants.SEARCHTYPE, searchtype);
	    	request.setAttribute(Constants.CONTEXT, context);
	    	request.setAttribute(Constants.ACTION, Constants.CRUD_DELETE);
			
			
			return mapping.findForward(Constants.SUCCESS);			
		}

		return mapping.findForward(Constants.ERROR);
    	
    	
    }    
	
}

package com.ibm.ea.common.help;

import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.DynaActionForm;
import org.apache.struts.actions.MappingDispatchAction;

public class ActionHelp extends MappingDispatchAction {

	private static final Logger logger = Logger.getLogger(ActionHelp.class);

    public ActionForward help(ActionMapping mapping, ActionForm form,
        HttpServletRequest request, HttpServletResponse response)
        throws Exception {
	logger.debug("ActionHelp.help");

	DynaActionForm helpForm = (DynaActionForm)form;
	helpForm.set( HelpConstants.FORM_FILE, HelpConstants.DEFAULT_FILE );
	request.setAttribute( HelpConstants.ATTR_FILE, HelpConstants.DEFAULT_FILE );
	String lang = (String)request.getSession().getAttribute( HelpConstants.ATTR_LANG );
	if((lang == null) || (lang.equals( "" )))
	{
		lang = HelpConstants.DEFAULT_LANG;
	}
	helpForm.set( HelpConstants.FORM_LANG, lang );
	request.getSession().setAttribute( HelpConstants.ATTR_LANG, lang );

	request.setAttribute( "displayDropdown", new Boolean( true ));
	request.setAttribute( HelpConstants.FORM_BEAN, helpForm );
	this.setLocale( request, new Locale( lang ));
    return( mapping.findForward( HelpConstants.SUCCESS ));
}
public ActionForward form(ActionMapping mapping, ActionForm form,
    HttpServletRequest request, HttpServletResponse response)
    throws Exception {
	logger.debug("ActionHelp.form");
	DynaActionForm helpForm = (DynaActionForm)form;

	String lang = (String)helpForm.get( HelpConstants.FORM_LANG );
	request.getSession().setAttribute( HelpConstants.ATTR_LANG, lang );
	logger.debug( "lang: " + lang );

	String file = (String)helpForm.get( HelpConstants.FORM_FILE );
	int index = file.indexOf( "/" );
	if( index != -1 )
	{
		logger.debug( "replacing '" + file.substring( 0, index ) + "' with '" + lang + "'" );
		file = file.replaceFirst( file.substring( 0, index ), lang );
	}
	logger.debug( "file: " + file );
	request.setAttribute( HelpConstants.ATTR_FILE, file );

	request.setAttribute( "displayDropdown", new Boolean( true ));
	request.setAttribute( HelpConstants.FORM_BEAN, helpForm );
	this.setLocale( request, new Locale( lang ));
    return( mapping.findForward( HelpConstants.SUCCESS ));
}
public ActionForward link(ActionMapping mapping, ActionForm form,
    HttpServletRequest request, HttpServletResponse response)
    throws Exception {
	logger.debug("ActionHelp.link");
	DynaActionForm helpForm = (DynaActionForm)form;

	String file = request.getParameter( HelpConstants.PARM_FILE );
	helpForm.set( HelpConstants.FORM_FILE, file );
	request.setAttribute( HelpConstants.ATTR_FILE, file );

	String lang = request.getParameter( HelpConstants.PARM_LANG );
	helpForm.set( HelpConstants.FORM_LANG, lang );
	request.getSession().setAttribute( HelpConstants.ATTR_LANG, lang );

	request.setAttribute( "displayDropdown", new Boolean( false ));
	request.setAttribute( HelpConstants.FORM_BEAN, helpForm );
	this.setLocale( request, new Locale( lang ));
	return( mapping.findForward( HelpConstants.SUCCESS ));
}
}
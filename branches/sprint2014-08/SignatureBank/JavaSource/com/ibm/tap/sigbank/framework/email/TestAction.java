package com.ibm.tap.sigbank.framework.email;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.Action;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

/**
 * @version 1.0
 * @author
 */
public class TestAction extends Action

{
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger.getLogger(TestAction.class);

	public ActionForward execute(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		String subject = null;
		String content = null;
		TestForm testForm = (TestForm) form;

		logger.debug(testForm.getForm() + "." + testForm.getAction() + "."
				+ testForm.getReceiver() + "." + "subject");
		String[] args = { testForm.getNumber(), testForm.getLink() };

		subject = EmailFactory.getSubject(getResources(request), testForm
				.getForm(), testForm.getAction(), testForm.getReceiver(), args);
		content = EmailFactory.getContent(getResources(request), testForm
				.getForm(), testForm.getAction(), testForm.getReceiver(), args);

		testForm.setSubject(subject);
		testForm.setContent(content);
		request.setAttribute("testForm", testForm);

		return mapping.findForward("success");
	}
}

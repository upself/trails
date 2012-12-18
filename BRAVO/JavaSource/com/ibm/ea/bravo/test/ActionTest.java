package com.ibm.ea.bravo.test;

import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;
import org.hibernate.Hibernate;

import com.ibm.ea.attachment.Attachment;
import com.ibm.ea.attachment.DelegateAttachment;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.upload.FormUpload;
import com.ibm.ea.utils.EaUtils;

public class ActionTest extends ActionBase {

	private static final Logger logger = Logger.getLogger(ActionTest.class);

    public ActionForward home(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionTest.home");
    	
    	List<Attachment> list = DelegateAttachment.list(Constants.ACTIVE);
    	request.setAttribute(Constants.LIST, list);
    	
        return mapping.findForward(Constants.SUCCESS);
    }
       
    public ActionForward upload(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionTest.upload");
    	FormUpload uploadForm = (FormUpload) form;
		FormFile uploadFile = uploadForm.getFile();
		
		Attachment attachment = new Attachment();
		attachment.setName(uploadFile.getFileName());
		attachment.setSize(new Integer(uploadFile.getFileSize()));
		attachment.setData(Hibernate.createBlob(uploadFile.getFileData()));
		attachment.setRemoteUser(request.getRemoteUser());
		
		DelegateAttachment.save(attachment);
		
    	return mapping.findForward(Constants.SUCCESS);
    }

    public ActionForward download(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
    	logger.debug("ActionTest.download");
    	String id = getParameter(request, Constants.ID);
		if (EaUtils.isBlank(id)) {
	    	return mapping.findForward(Constants.SUCCESS);
		}
    	
    	try {
	    	// get the attachment
    		Attachment attachment = DelegateAttachment.get(id);
    		
    		if (attachment == null) {
    			return mapping.findForward(Constants.SUCCESS);
    		}
	    	
    	} catch (Exception e) {
    		logger.debug(e, e);
    	}
    	
    	return mapping.findForward(Constants.SUCCESS);
    }
}
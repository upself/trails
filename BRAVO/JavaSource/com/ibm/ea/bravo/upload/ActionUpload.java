/*
 * Created on Jun 25, 2006
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.ea.bravo.upload;

import java.io.File;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.action.ActionMessage;
import org.apache.struts.upload.FormFile;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

/**
 * @author denglers
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class ActionUpload extends ActionBase {

    private static final Logger logger = Logger.getLogger(ActionUpload.class);

    public ActionForward upload(ActionMapping mapping, ActionForm form,
            HttpServletRequest request, HttpServletResponse response)
            throws Exception {
        logger.debug("ActionUpload.upload");
        ActionErrors errors = new ActionErrors();

        // validate the form exists
        if (form == null) {
            errors.add(Constants.ERROR, new ActionMessage(
                    Constants.UNKNOWN_ERROR));
            saveErrors(request, errors);
            return mapping.findForward(Constants.HOME);
        }

        // cast and validate the form contents
        FormUpload uploadForm = (FormUpload) form;
        errors = uploadForm.validate(mapping, request);
        if (!errors.isEmpty()) {
            saveErrors(request, errors);
            return forwardError(mapping, uploadForm);
        }

        // extract the form properties for convenience
        String uploadType = uploadForm.getUploadType();
        FormFile uploadFile = uploadForm.getFile();
        String accountId = uploadForm.getAccountId();
        request.setAttribute(Constants.ACCOUNT_ID, accountId);

        // determine the filename, directory, and batch type
        UploadBase upload = null;
        String filename = uploadFile.getFileName();
        String dir = Constants.UPLOAD_DIR;

        // preset some date time info
        Date now = new Date();
        String date = EaUtils.yearMonthDay(now);
        String time = EaUtils.hourMinuteSecond(now);

        if (uploadType.equalsIgnoreCase(Constants.TIVOLI)) {
            // upload = new Tivoli(accountId + "." + request.getRemoteUser() +
            // ".tar");
            upload = new Tivoli(accountId + ".tar");
            upload.setRemoteUser(request.getRemoteUser());
            dir = upload.getDir();
            filename = upload.getFilename();

            // validate the file doesn't already exist
            File file = new File(dir + filename);
            if (file.exists()) {
                errors.add(Constants.ERROR, new ActionMessage(
                        Constants.TAR_FILE_EXISTS));
                saveErrors(request, errors);
                return forwardError(mapping, uploadForm);
            }
        }
        if (uploadType.equalsIgnoreCase(Constants.SOFTWARE_DISCREPANCY)) {
            upload = new SoftwareDiscrepancy(request.getRemoteUser(), request
                    .getRemoteUser()
                    + "." + date + "." + time + ".xls", request);
            upload.setRemoteUser(request.getRemoteUser());
            dir = upload.getDir();
            filename = upload.getFilename();
        }
        if (uploadType.equalsIgnoreCase(Constants.SCRT_REPORT)) {
            upload = new SCRTReport(request.getRemoteUser(), request
                    .getRemoteUser()
                    + "." + date + "." + time + ".csv", request);
            upload.setRemoteUser(request.getRemoteUser());
            dir = upload.getDir();
            filename = upload.getFilename();
            request.setAttribute("accountId", accountId);
        }
        if (uploadType.equalsIgnoreCase(Constants.AUTHORIZED_ASSETS)) {
            Account account = DelegateAccount.getAccount(accountId, request);
            String timeStamp = EaUtils.timeStamp(now);
            upload = new AuthorizedAssets(account.getCustomer().getCustomerId()
                    + "_" + request.getRemoteUser() + "_authProd_" + timeStamp);
            upload.setRemoteUser(request.getRemoteUser());
            dir = upload.getDir();
            filename = upload.getFilename();
        }
        logger.debug("upload " + uploadType + " parsing preview: " + " file: "
                + dir + filename + " user: " + upload.getRemoteUser());

        // validate batch
        if (upload == null) {
            errors.add(Constants.ERROR, new ActionMessage(
                    Constants.UNKNOWN_ERROR));
            saveErrors(request, errors);
            return forwardError(mapping, uploadForm);
        }

        // -- From here below just copies the file to a standard location
        InputStream streamIn = uploadFile.getInputStream();
        OutputStream streamOut = new FileOutputStream(dir + filename);

        int bytesRead = 0;
        byte[] buffer = new byte[8192];

        logger.debug("writing to " + dir + filename);
        while ((bytesRead = streamIn.read(buffer, 0, 8192)) != -1) {
            streamOut.write(buffer, 0, bytesRead);
        }

        streamOut.close();
        streamIn.close();
        // -- Stop copying...

        // validate the batch
        if (!upload.validate()) {
            errors.add(Constants.ERROR, new ActionMessage(
                    Constants.BATCH_INVALID));
            saveErrors(request, errors);
            return forwardError(mapping, uploadForm);
        }

        if (uploadType.equalsIgnoreCase(Constants.AUTHORIZED_ASSETS)) {
            File file = new File(dir + filename);
            File newFile = new File(dir + filename + ".csv");
            file.renameTo(newFile);
        } else {
            //TODO Why is this here..are we using the batch
            //If nothing is popping this out of the batch then we are just
            //wasting memory
            addBatch(upload);
            logger.debug("Batch added " + upload.getRemoteUser() + " loaded "
                    + upload.getFilename());
        }

        return forwardSuccess(mapping, uploadForm);
    }

    private ActionForward forwardError(ActionMapping mapping, FormUpload form) {
        return forward(mapping, form, Constants.ERROR);
    }

    private ActionForward forwardSuccess(ActionMapping mapping, FormUpload form) {
        return forward(mapping, form, Constants.SUCCESS);
    }

    private ActionForward forward(ActionMapping mapping, FormUpload form,
            String status) {
        if (form == null)
            return mapping.findForward(Constants.HOME);

        if (status.equalsIgnoreCase(Constants.SUCCESS)) {

            if (form.getUploadType().equalsIgnoreCase(Constants.TIVOLI))
                return mapping.findForward(Constants.TIVOLI_CONFIRM);
            if (form.getUploadType().equalsIgnoreCase(
                    Constants.SOFTWARE_DISCREPANCY))
                return mapping.findForward(Constants.ACCOUNT);
            if (form.getUploadType().equalsIgnoreCase(Constants.SCRT_REPORT))
                return mapping.findForward(Constants.ACCOUNT);
            if (form.getUploadType().equalsIgnoreCase(
                    Constants.AUTHORIZED_ASSETS))
                return mapping.findForward(Constants.ACCOUNT);
        }

        if (status.equalsIgnoreCase(Constants.ERROR)) {
            return mapping.findForward(form.getUploadType());
        }

        return null;
    }
}

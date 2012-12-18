package com.ibm.tap.misld.gui.action;

import java.util.Date;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.ibm.batch.BatchFileLoader;
import com.ibm.batch.IBatch;
import com.ibm.tap.misld.batch.MisldBatchFactory;
import com.ibm.tap.misld.framework.BaseAction;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.UserContainer;
import com.ibm.tap.misld.framework.exceptions.EditNotAllowedException;
import com.ibm.tap.misld.framework.exceptions.InvalidAccessException;
import com.ibm.tap.misld.framework.fileLoader.FileLoaderForm;
import com.ibm.tap.misld.framework.fileLoader.MisldFormFile;

/**
 * @version 1.0
 * @author
 */
public class UploadAction extends BaseAction

{

	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/Upload.do");

		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward priceListUpload(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/Upload.do");

		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward priceListSave(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		FileLoaderForm fileLoaderForm = (FileLoaderForm) form;

		if (fileLoaderForm == null) {
			return mapping.findForward(Constants.ERROR);
		}

		FormFile file = fileLoaderForm.getFile();

		if (file == null) {
			return mapping.findForward(Constants.ERROR);
		}

		String fname = file.getFileName();

		long dateStamp = new Date().getTime();

		fname = dateStamp + "." + request.getRemoteUser() + "." + fname;

		BatchFileLoader batchLoader = new BatchFileLoader();
		batchLoader.loadBatch(fname, file, request);
		String dir = batchLoader.getDir();

		MisldFormFile misldFormFile = new MisldFormFile();
		misldFormFile.setFileName(fname);

		// Init the batch Interface
		IBatch batch = null;

		batch = MisldBatchFactory.getPriceListLoaderBatch(request
				.getRemoteUser(), dir, misldFormFile);

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward mappingUpload(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink("/MsWizard/Administration.do");
		user.setLevelTwoOpenLink("/MsWizard/MappingUpload.do");

		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward mappingSave(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		FileLoaderForm fileLoaderForm = (FileLoaderForm) form;

		if (fileLoaderForm == null) {
			return mapping.findForward(Constants.ERROR);
		}

		FormFile file = fileLoaderForm.getFile();

		if (file == null) {
			return mapping.findForward(Constants.ERROR);
		}

		String fname = file.getFileName();

		long dateStamp = new Date().getTime();

		fname = dateStamp + "." + request.getRemoteUser() + "." + fname;

		BatchFileLoader batchLoader = new BatchFileLoader();
		batchLoader.loadBatch(fname, file, request);
		String dir = batchLoader.getDir();

		MisldFormFile misldFormFile = new MisldFormFile();
		misldFormFile.setFileName(fname);

		// Init the batch Interface
		IBatch batch = null;

		batch = MisldBatchFactory.getMappingLoaderBatch(
				request.getRemoteUser(), dir, misldFormFile);

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward hardwareBaselineUpload(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
		}

		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new InvalidAccessException();
			}
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		FileLoaderForm fileLoaderForm = (FileLoaderForm) form;

		if (fileLoaderForm == null) {
			return mapping.findForward(Constants.ERROR);
		}

		FormFile file = fileLoaderForm.getFile();

		if (file == null) {
			return mapping.findForward(Constants.ERROR);
		}

		String fname = file.getFileName();

		long dateStamp = new Date().getTime();

		fname = dateStamp + "." + request.getRemoteUser() + "." + fname;

		BatchFileLoader batchLoader = new BatchFileLoader();
		batchLoader.loadBatch(fname, file, request);
		String dir = batchLoader.getDir();

		MisldFormFile misldFormFile = new MisldFormFile();
		misldFormFile.setFileName(fname);

		// Init the batch Interface
		IBatch batch = null;

		batch = MisldBatchFactory.getHardwareLoaderBatch(request
				.getRemoteUser(), dir, misldFormFile, user.getCustomer());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward softwareBaselineUpload(ActionMapping mapping,
			ActionForm form, HttpServletRequest request,
			HttpServletResponse response) throws Exception {

		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			return mapping.findForward(Constants.HOME);
		}

		if (!user.isAsset()) {
			throw new InvalidAccessException();
		}

		if (user.getCustomer() == null) {
			return mapping.findForward(Constants.HOME);
		}

		if (user.getCustomer().getMisldAccountSettings() != null) {
			if (user.getCustomer().getMisldAccountSettings().getStatus()
					.equals(Constants.LOCKED)) {
				throw new EditNotAllowedException();
			}
		}

		user.setLevelOneOpenLink("/MsWizard/PodView.do");
		user.setLevelTwoOpenLink("/MsWizard/Pod.do?pod="
				+ user.getCustomer().getPod().getPodId());

		FileLoaderForm fileLoaderForm = (FileLoaderForm) form;

		if (fileLoaderForm == null) {
			return mapping.findForward(Constants.ERROR);
		}

		FormFile file = fileLoaderForm.getFile();

		if (file == null) {
			return mapping.findForward(Constants.ERROR);
		}

		String fname = file.getFileName();

		long dateStamp = new Date().getTime();

		fname = dateStamp + "." + request.getRemoteUser() + "." + fname;

		BatchFileLoader batchLoader = new BatchFileLoader();
		batchLoader.loadBatch(fname, file, request);
		String dir = batchLoader.getDir();

		MisldFormFile misldFormFile = new MisldFormFile();
		misldFormFile.setFileName(fname);

		// Init the batch Interface
		IBatch batch = null;

		batch = MisldBatchFactory.getSoftwareLoaderBatch(request
				.getRemoteUser(), dir, misldFormFile, user.getCustomer());

		if (batch != null) {
			addBatch(batch);
		}

		return mapping.findForward(Constants.SUCCESS);
	}
}
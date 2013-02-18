package com.ibm.tap.sigbank.upload;

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Date;
import java.util.Properties;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;
import org.apache.struts.upload.FormFile;

import com.ibm.tap.sigbank.framework.batch.IBatch;
import com.ibm.tap.sigbank.framework.common.BaseAction;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.exceptions.InvalidAccessException;
import com.ibm.tap.sigbank.framework.navigate.NavigationController;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * 
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

public class ActionAdministrationLoader extends BaseAction {

	public static Properties properties = new Properties();

	static Logger logger = Logger.getLogger(ActionAdministrationLoader.class);

	public static String appPath;

	boolean loaded = false; // Crappy work around for tomcat4 and struts

	public void init() throws ServletException {
		// appPath = servlet.getServletContext().getRealPath("/");

		logger
				.debug("Loading the initialization for ActionAdministrationLoader");

		try {
			properties.load(new FileInputStream(Constants.APP_PROPERTIES));

		} catch (Exception e) {
			logger.error(e, e);
		}
	}

	public ActionForward upload(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.uploadLink);

		return mapping.findForward(Constants.GLOBAL_HOME);
	}

	public ActionForward filters(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.uploadLink);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward signatures(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.uploadLink);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward userSave(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Crappy work around for tomcat 4
		if (!loaded) {
			init();
			loaded = true;
		}

		String dir = properties.getProperty("workingDir") + "/";

		// Get the action form and some basic file checks
		FormUploadFile tff = (FormUploadFile) form;
		if (tff == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		FormFile file = tff.getFile();

		if (file == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		String fname = file.getFileName();
		long dateStamp = new Date().getTime();
		fname = dateStamp + "." + request.getRemoteUser() + "." + fname;

		// -- From here below just copies the file to a standard location
		InputStream streamIn = file.getInputStream();
		OutputStream streamOut = new FileOutputStream(dir + fname);

		int bytesRead = 0;
		byte[] buffer = new byte[8192];

		logger.debug("writing to " + dir + fname);
		while ((bytesRead = streamIn.read(buffer, 0, 8192)) != -1) {
			streamOut.write(buffer, 0, bytesRead);
		}

		streamOut.close();
		streamIn.close();

		// -- Stop copying...

		HolderFormFile holder = new HolderFormFile();
		holder.setFileName(fname);

		// Init the batch Interface
		IBatch batch = null;

		// Get the loader based on the users choice
		logger.debug("getting batch");

		batch = (IBatch) new MassLoadFilterBatch(request.getRemoteUser(), dir
				+ holder.getFileName(), this.getResources(request), dir,
				request);

		logger.debug("batch received for: " + fname);

		// Stick it on the batch and move on...
		if (batch != null) {
			logger.info(request.getRemoteUser() + " loaded " + batch.getName()
					+ "using file: " + fname);
			addBatch(batch);
		}

		// Send back to the loader page.
		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward signatureSave(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Crappy work around for tomcat 4
		if (!loaded) {
			init();
			loaded = true;
		}

		String dir = properties.getProperty("workingDir") + "/";

		// Get the action form and some basic file checks
		FormUploadFile tff = (FormUploadFile) form;
		if (tff == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		FormFile file = tff.getFile();

		if (file == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		String fname = file.getFileName();
		long dateStamp = new Date().getTime();
		fname = dateStamp + "." + request.getRemoteUser() + "." + fname;

		// -- From here below just copies the file to a standard location
		InputStream streamIn = file.getInputStream();
		OutputStream streamOut = new FileOutputStream(dir + fname);

		int bytesRead = 0;
		byte[] buffer = new byte[8192];

		logger.debug("writing to " + dir + fname);
		while ((bytesRead = streamIn.read(buffer, 0, 8192)) != -1) {
			streamOut.write(buffer, 0, bytesRead);
		}

		streamOut.close();
		streamIn.close();

		// -- Stop copying...

		HolderFormFile holder = new HolderFormFile();
		holder.setFileName(fname);

		// Init the batch Interface
		IBatch batch = null;

		// Get the loader based on the users choice
		logger.debug("getting batch");

		batch = (IBatch) new MassLoadSignatureBatch(request.getRemoteUser(),
				dir + holder.getFileName(), this.getResources(request), dir,
				request);

		logger.debug("batch received for: " + fname);

		// Stick it on the batch and move on...
		if (batch != null) {
			logger.info(request.getRemoteUser() + " loaded " + batch.getName()
					+ "using file: " + fname);
			addBatch(batch);
		}

		// Send back to the loader page.
		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward filterSave(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		// Crappy work around for tomcat 4
		if (!loaded) {
			init();
			loaded = true;
		}

		String dir = properties.getProperty("workingDir") + "/";

		// Get the action form and some basic file checks
		FormUploadFile tff = (FormUploadFile) form;
		if (tff == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		FormFile file = tff.getFile();

		if (file == null) {
			return mapping.findForward(Constants.GLOBAL_HOME);
		}

		String fname = file.getFileName();
		long dateStamp = new Date().getTime();
		fname = dateStamp + "." + request.getRemoteUser() + "." + fname;

		// -- From here below just copies the file to a standard location
		InputStream streamIn = file.getInputStream();
		OutputStream streamOut = new FileOutputStream(dir + fname);

		int bytesRead = 0;
		byte[] buffer = new byte[8192];

		logger.debug("writing to " + dir + fname);
		while ((bytesRead = streamIn.read(buffer, 0, 8192)) != -1) {
			streamOut.write(buffer, 0, bytesRead);
		}

		streamOut.close();
		streamIn.close();

		// -- Stop copying...

		HolderFormFile holder = new HolderFormFile();
		holder.setFileName(fname);

		// Init the batch Interface
		IBatch batch = null;

		// Get the loader based on the users choice
		logger.debug("getting batch");

		batch = (IBatch) new MassLoadFilterBatch(request.getRemoteUser(), dir
				+ holder.getFileName(), this.getResources(request), dir,
				request);

		logger.debug("batch received for: " + fname);

		// Stick it on the batch and move on...
		if (batch != null) {
			logger.info(request.getRemoteUser() + " loaded " + batch.getName()
					+ "using file: " + fname);
			addBatch(batch);
		}

		// Send back to the loader page.
		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward templates(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		UserContainer user = loadUser(request);
		if (!user.isAdminAccess()) {
			throw new InvalidAccessException();
		}

		user.setLevelOneOpenLink(NavigationController.uploadLink);

		return mapping.findForward(Constants.SUCCESS);
	}
}
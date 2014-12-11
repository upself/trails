/*
 * Created on Feb 15, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.common;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts.actions.MappingDispatchAction;
import org.hibernate.HibernateException;

import com.ibm.tap.sigbank.framework.batch.BatchPlugin;
import com.ibm.tap.sigbank.framework.batch.IBatch;
import com.ibm.asset.swkbt.domain.Manufacturer;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategory;
import com.ibm.tap.sigbank.usercontainer.UserContainer;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class BaseAction extends MappingDispatchAction {
	protected void addBatch(IBatch batch) {
		BatchPlugin batchFactory = (BatchPlugin) getApplicationObject(Constants.BATCH_FACTORY_KEY);
		batchFactory.addBatch(batch);
	}

	private Object getApplicationObject(String key) {
		return servlet.getServletContext().getAttribute(key);
	}

	protected UserContainer getUserContainer(HttpServletRequest request)
			throws HibernateException, Exception {

		HttpSession session = request.getSession();

		UserContainer existingContainer = (UserContainer) session
				.getAttribute(Constants.USER_CONTAINER);

		if (existingContainer == null) {
			existingContainer = new UserContainer();
			existingContainer.setRemoteUser(request.getRemoteUser());
		}

		return existingContainer;
	}

	protected void setUserContainer(HttpServletRequest request,
			UserContainer userContainer) throws HibernateException, Exception {

		HttpSession session = request.getSession();

		session.setAttribute(Constants.USER_CONTAINER, userContainer);
	}

	protected UserContainer loadUser(HttpServletRequest request)
			throws Exception {
		String remoteUser = request.getRemoteUser();
		UserContainer user = getUserContainer(request);

		if (!user.isLoaded()) {
			user.setAccessLevel();
			user.setRemoteUser(remoteUser);
		}

		setUserContainer(request, user);

		return user;

	}

	protected void setSoftwareCategory(HttpServletRequest request,
			SoftwareCategory softwareCategory) throws Exception {

		UserContainer user = getUserContainer(request);
		user.setSoftwareCategory(softwareCategory);
		setUserContainer(request, user);

	}

	protected SoftwareCategory getSoftwareCategory(HttpServletRequest request)
			throws Exception {
		UserContainer user = getUserContainer(request);
		return user.getSoftwareCategory();
	}

	protected void setManufacturer(HttpServletRequest request,
			Manufacturer manufacturer) throws Exception {

		UserContainer user = getUserContainer(request);
		user.setManufacturer(manufacturer);
		setUserContainer(request, user);

	}

	protected Manufacturer getManufacturer(HttpServletRequest request)
			throws Exception {
		UserContainer user = getUserContainer(request);
		return user.getManufacturer();
	}

	protected void setLastButton(HttpServletRequest request, String lastButton)
			throws Exception {

		UserContainer user = getUserContainer(request);
		user.setLastButton(lastButton);
		setUserContainer(request, user);

	}

	protected String getLastButton(HttpServletRequest request) throws Exception {
		UserContainer user = getUserContainer(request);
		return user.getLastButton();
	}

	protected void setProduct(HttpServletRequest request, Product product)
			throws Exception {

		UserContainer user = getUserContainer(request);
		user.setProduct(product);
		setUserContainer(request, user);

	}

	protected Product getProduct(HttpServletRequest request) throws Exception {
		UserContainer user = getUserContainer(request);
		return user.getProduct();
	}

	public Pagination getPagination(HttpServletRequest request)
			throws HibernateException, Exception {

		UserContainer userContainer = getUserContainer(request);

		Pagination pagination = userContainer.getPagination();

		if (pagination == null) {
			return null;
		}

		return pagination;
	}

	public void setPagination(HttpServletRequest request, Pagination pagination)
			throws HibernateException, Exception {

		UserContainer userContainer = getUserContainer(request);
		userContainer.setPagination(pagination);
		setUserContainer(request, userContainer);
	}

	public void clearPagination(HttpServletRequest request)
			throws HibernateException, Exception {
		UserContainer userContainer = getUserContainer(request);
		userContainer.setPagination(null);
		setUserContainer(request, userContainer);
	}
}
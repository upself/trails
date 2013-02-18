/*
 * Created on Mar 29, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.softwarecategory;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessage;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Delegate;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.software.ProductDelegate;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class SoftwareCategoryDelegate extends Delegate {

	/**
	 * @@return
	 * @@throws Exception
	 * @@throws HibernateException
	 * @@throws NamingException
	 */
	public static List getSoftwareCategorys() throws HibernateException,
			NamingException {

		List softwareCategorys = new Vector();

		Session session = getHibernateSession();

		softwareCategorys = getSoftwareCategorys(softwareCategorys, session);

		session.close();

		return softwareCategorys;
	}

	/**
	 * @@param softwareCategorys
	 * @@return
	 * @@throws Exception
	 * @@throws HibernateException
	 */
	public static List getSoftwareCategorys(List results, Session session) {

		results = session.getNamedQuery("softwareCategories").list();

		return results;
	}

	public static SoftwareCategory getSoftwareCategory(String id)
			throws HibernateException, NamingException {

		SoftwareCategory softwareCategory = null;

		Session session = getHibernateSession();

		softwareCategory = getSoftwareCategory(id, softwareCategory, session);

		session.close();

		return softwareCategory;
	}

	public static SoftwareCategory getSoftwareCategory(String id,
			SoftwareCategory result, Session session) {

		result = (SoftwareCategory) session.getNamedQuery(
				"softwareCategoryById").setLong("softwareCategoryId",
				new Long(id).longValue()).uniqueResult();

		return result;
	}

	public static List getSoftwareCategoryHistory(String id)
			throws HibernateException, NamingException {

		List results = null;

		Session session = getHibernateSession();

		results = getSoftwareCategoryHistory(id, results, session);

		session.close();

		return results;
	}

	public static List getSoftwareCategoryHistory(String id, List results,
			Session session) {

		results = session.getNamedQuery("softwareCategoryHistory").setLong(
				"softwareCategoryId", new Long(id).longValue()).list();

		return results;
	}

	public static ActionErrors addSoftwareCategory(SoftwareCategoryForm scf,
			String remoteUser) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a manufacturer object
		SoftwareCategory softwareCategory = transferAddSoftwareCategoryForm(
				scf, session);

		// Now we need to go through the logic of adding a new manufacturer
		ActionErrors errors = new ActionErrors();

		// Get the manufacturer by name from DB
		SoftwareCategory softwareCategoryByName = null;
		softwareCategoryByName = getSoftwareCategoryByName(softwareCategory
				.getSoftwareCategoryName(), softwareCategoryByName, session);

		// If the manufacturer exists by name
		if (softwareCategoryByName != null) {

			// If the manufacturerByName is active we cannot add this because it
			// exists
			if (softwareCategoryByName.getStatus().equalsIgnoreCase(
					Constants.ACTIVE)) {
				errors.add("softwareCategoryName", new ActionMessage(
						"errors.software.category.duplicate"));
				return errors;
			}

			// Update the manufacturer id to the one that exists, this will
			// activate
			// it
			softwareCategory.setSoftwareCategoryId(softwareCategoryByName
					.getSoftwareCategoryId());
		}

		// Save the software
		save(softwareCategory, remoteUser, session);
		tx.commit();
		session.close();

		// return the errors
		return errors;
	}

	public static SoftwareCategory transferAddSoftwareCategoryForm(
			SoftwareCategoryForm softwareCategoryForm, Session session)
			throws IllegalAccessException, InvocationTargetException {

		// Instantiate a new manufacturer object
		SoftwareCategory softwareCategory = new SoftwareCategory();

		// Set the fields from the software form
		BeanUtils.copyProperties(softwareCategory, softwareCategoryForm);
		softwareCategory.setSoftwareCategoryId(null);
		softwareCategory.setStatus(Constants.ACTIVE);

		// Return the newly created software object
		return softwareCategory;
	}

	private static SoftwareCategory getSoftwareCategoryByName(
			String softwareCategoryName,
			SoftwareCategory softwareCategoryByName, Session session) {

		softwareCategoryByName = (SoftwareCategory) session.getNamedQuery(
				"softwareCategoryByName").setString("name",
				softwareCategoryName).uniqueResult();

		return softwareCategoryByName;
	}

	public static void save(SoftwareCategory softwareCategory,
			String remoteUser, Session session) throws HibernateException,
			NamingException, IllegalAccessException, InvocationTargetException {

		softwareCategory.setRecordTime(new Date());
		softwareCategory.setRemoteUser(remoteUser);

		// We need to move the software to unknown manf if inactive
		if (softwareCategory.getStatus().equals(Constants.INACTIVE)) {
			SoftwareCategory unknownSc = null;
			unknownSc = getSoftwareCategoryByName(Constants.UNKNOWN, unknownSc,
					session);
			ProductDelegate.updateProductSoftwareCategory(softwareCategory,
					unknownSc, remoteUser, session);
		}

		// Create a manufacturer history object
		SoftwareCategoryH softwareCategoryH = new SoftwareCategoryH();

		// Copy over the properties that we can
		BeanUtils.copyProperties(softwareCategoryH, softwareCategory);

		// We want to save or update our manufacturer
		session.saveOrUpdate(softwareCategory);

		// Set our other fields that won't copy
		softwareCategoryH.setSoftwareCategory(softwareCategory);

		// We want a pure save of the history for it will always be new
		session.save(softwareCategoryH);
	}

	public static SoftwareCategoryForm setUpdateForm(String softwareCategoryId)
			throws IllegalAccessException, InvocationTargetException,
			HibernateException, NamingException {

		SoftwareCategory softwareCategory = getSoftwareCategory(softwareCategoryId);

		SoftwareCategoryForm softwareCategoryForm = new SoftwareCategoryForm();

		BeanUtils.copyProperties(softwareCategoryForm, softwareCategory);

		// Set these to null for we don't want them to show up in the form
		softwareCategoryForm.setChangeJustification(null);
		softwareCategoryForm.setComments(null);

		return softwareCategoryForm;
	}

	public static ActionErrors updateSoftwareCategory(
			SoftwareCategoryForm softwareCategoryForm, String remoteUser)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a manufacturer object
		SoftwareCategory softwareCategory = transferUpdateSoftwareCategoryForm(
				softwareCategoryForm, session);

		// Now we need to go through the logic of updating a manufacturer
		ActionErrors errors = new ActionErrors();

		// Grab the manufacturer from the database using the ID
		SoftwareCategory softwareCategoryById = null;
		softwareCategoryById = getSoftwareCategory(softwareCategory
				.getSoftwareCategoryId().toString(), softwareCategoryById,
				session);

		// Grab the manufacturer from the database using the manufacturer name
		SoftwareCategory softwareCategoryByName = null;
		softwareCategoryByName = getSoftwareCategoryByName(softwareCategory
				.getSoftwareCategoryName(), softwareCategoryByName, session);

		// If the manufacturer name exists in the database
		if (softwareCategoryByName != null) {

			// If the IDs of the two from the db are not equal
			if (!softwareCategoryById.getSoftwareCategoryId().equals(
					softwareCategoryByName.getSoftwareCategoryId())) {

				errors.add("softwareCategoryName", new ActionMessage(
						"errors.softwarecategory.duplicate"));
				return errors;
			}

		}

		if (softwareCategory.getSoftwareCategoryName()
				.equals(Constants.UNKNOWN)) {
			errors.add("softwareCategoryName", new ActionMessage(
					"errors.softwarecategory.duplicate"));
			return errors;
		}

		// We need to evict the two manufacturer from this session
		session.evict(softwareCategoryById);
		session.evict(softwareCategoryByName);

		// Save the manufacturer
		save(softwareCategory, remoteUser, session);
		tx.commit();
		session.close();

		// Return the errors
		return errors;
	}

	public static SoftwareCategory transferUpdateSoftwareCategoryForm(
			SoftwareCategoryForm softwareCategoryForm, Session session)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		// Instantiate a new software object
		SoftwareCategory softwareCategory = new SoftwareCategory();

		// Copy the properties over from the form
		softwareCategory.setChangeJustification(softwareCategoryForm
				.getChangeJustification());
		softwareCategory.setSoftwareCategoryId(new Long(softwareCategoryForm
				.getSoftwareCategoryId()));
		softwareCategory.setStatus(softwareCategoryForm.getStatus());
		softwareCategory.setSoftwareCategoryName(softwareCategoryForm
				.getSoftwareCategoryName());

		// If they didn't update these, we want to keep them null in the
		// database
		if (!Util.isBlankString(softwareCategoryForm.getComments())) {
			softwareCategory.setComments(softwareCategoryForm.getComments());
		}

		// Return the software object
		return softwareCategory;
	}

	public static List getSoftwareCategories() throws HibernateException,
			NamingException {

		List softwareCategories = null;

		Session session = getHibernateSession();

		softwareCategories = getSoftwareCategories(softwareCategories, session);

		session.close();

		return softwareCategories;
	}

	/**
	 * @@param manufacturers
	 * @@return
	 * @@throws Exception
	 * @@throws HibernateException
	 */
	public static List getSoftwareCategories(List results, Session session) {

		results = session.getNamedQuery("softwareCategories").list();

		return results;
	}

	public static List getHistoryYears() throws HibernateException,
			NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareCategoryHistoryYears").list();

		session.close();

		return years;
	}

	public static List getHistoryMonths(String year) throws HibernateException,
			NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareCategoryHistoryMonths")
				.setString("year", year).list();

		session.close();

		return years;
	}

	public static List getHistoryByYearByMonth(String year, String month)
			throws HibernateException, NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareCategoryHistoryByYearByMonth")
				.setString("year", year).setString("month", month).list();

		session.close();

		return years;
	}
}
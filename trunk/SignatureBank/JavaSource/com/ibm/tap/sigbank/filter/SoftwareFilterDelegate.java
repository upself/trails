package com.ibm.tap.sigbank.filter;

import java.lang.reflect.InvocationTargetException;
import java.text.MessageFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Vector;

import javax.naming.NamingException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.commons.validator.Field;
import org.apache.commons.validator.Form;
import org.apache.commons.validator.Validator;
import org.apache.commons.validator.ValidatorAction;
import org.apache.commons.validator.ValidatorException;
import org.apache.commons.validator.ValidatorResources;
import org.apache.commons.validator.ValidatorResult;
import org.apache.commons.validator.ValidatorResults;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.sigbank.framework.common.Constants;
import org.apache.struts.action.ActionMessage;
import com.ibm.tap.sigbank.framework.common.Delegate;
import com.ibm.tap.sigbank.framework.common.Pagination;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.software.ProductDelegate;

/**
 * @@author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class SoftwareFilterDelegate extends Delegate {

	static Logger logger = Logger.getLogger(SoftwareFilterDelegate.class);

	public static Long getNewSoftwareFilterCount() throws HibernateException,
			Exception {

		Long count = null;

		Session session = getHibernateSession();

		count = getNewSoftwareFilterCount(count, session);

		session.close();

		return count;

	}

	public static Long getNewSoftwareFilterCount(Long count, Session session) {

		count = (Long) session.getNamedQuery("newSoftwareFilterCount")
				.uniqueResult();

		return count;

	}

	/**
	 * @@param software
	 * @@return
	 * @@throws Exception
	 * @@throws HibernateException
	 * @@throws NamingException
	 */
	public static List getSoftwareFiltersByProduct(Product product)
			throws HibernateException, NamingException {

		List softwareFilters = new Vector();

		Session session = getHibernateSession();

		softwareFilters = getSoftwareFiltersByProduct(product, softwareFilters,
				session);

		session.close();

		return softwareFilters;
	}

	public static List getSoftwareFiltersByProduct(Product product,
			List results, Session session) throws HibernateException,
			NamingException {

		results = session.getNamedQuery("softwareFiltersByProduct").setEntity(
				"product", product).list();

		return results;
	}

	public static ActionErrors moveSoftwareFilters(SoftwareFilterForm sff,
			String remoteUser) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		Session session = getHibernateSession();

		ActionErrors errors = new ActionErrors();
		List<Long> selected = new Vector<Long>();

		for (int i = 0; i < sff.getSelectedItems().length; i++) {
			if (Util.isInt(sff.getSelectedItems()[i])) {
				selected.add(new Long(sff.getSelectedItems()[i]));
			}
		}

		Product to = null;
		to = ProductDelegate.getProduct(sff.getSoftwareId(), to, session);
		if (to.getDeleted()) {
			errors.add("softwareInactive", new ActionMessage(
					"errors.software.software.inactive"));
		} else {
			Transaction tx = session.beginTransaction();
			List softwareFilters = null;
			softwareFilters = getSoftwareFilters(selected, softwareFilters,
					session);

			changeSoftwareFilterAssignment(softwareFilters, to, sff
					.getChangeJustification(), sff.getComments(), remoteUser,
					session);

		tx.commit();
		}
		session.close();

		// Return the errors
		return errors;
	}

	private static List getSoftwareFilters(List selected, List results,
			Session session) {

		results = session.getNamedQuery("softwareFiltersByIdList")
				.setParameterList("ids", selected).list();

		return results;
	}

	public static void changeSoftwareFilterAssignment(List softwareFilters,
			Product to, String changeJustification, String comments,
			String remoteUser, Session session) throws HibernateException,
			NamingException, IllegalAccessException, InvocationTargetException {

		Iterator i = softwareFilters.iterator();
		while (i.hasNext()) {
			SoftwareFilter sf = (SoftwareFilter) i.next();
			if (sf.getProduct().getName().equals(to.getName())) {
				continue;
			}

			if (to.getName().equals(Constants.UNKNOWN)) {
				sf.setStatus(Constants.INACTIVE);
			} else {
				sf.setStatus(Constants.ACTIVE);
			}

			sf.setProduct(to);
			sf.setChangeJustification(changeJustification);
			sf.setComments(comments);
			save(sf, remoteUser, session);
		}
	}

	public static void save(SoftwareFilter sf, String remoteUser,
			Session session) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		sf.setRecordTime(new Date());
		sf.setRemoteUser(remoteUser);

		// Create a software Filter history object
		SoftwareFilterH sfh = new SoftwareFilterH();

		// Copy over the properties that we can
		BeanUtils.copyProperties(sfh, sf);

		// Set our other fields that won't copy
		sfh.setSoftwareFilter(sf);

		// We want to save or update our software
		session.saveOrUpdate(sf);

		// We want a pure save of the history for it will always be new
		session.save(sfh);

		// Evict the software it is holding onto
		session.evict(sf.getProduct());
	}

	public static ActionErrors mapSoftwareFilters(SoftwareFilterForm sff,
			String remoteUser) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		ActionErrors errors = new ActionErrors();
		List<Long> selected = new Vector<Long>();

		for (int i = 0; i < sff.getSelectedItems().length; i++) {
			if (Util.isInt(sff.getSelectedItems()[i])) {
				selected.add(new Long(sff.getSelectedItems()[i]));
			}
		}

		List softwareFilters = null;
		softwareFilters = getSoftwareFilters(selected, softwareFilters, session);

		Iterator i = softwareFilters.iterator();
		while (i.hasNext()) {
			SoftwareFilter sf = (SoftwareFilter) i.next();

			sf.setMapSoftwareVersion(sff.getMapSoftwareVersion());
			sf.setChangeJustification(sff.getChangeJustification());
			sf.setComments(sff.getComments());

			save(sf, remoteUser, session);
		}

		tx.commit();
		session.close();

		// Return the errors
		return errors;
	}

	public static void updateFilters(Product product, Session session)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		// Kind of a pain to do it this way...but quick to code
		// TODO Introduce the history stuff into an interceptor
		List softwareFilters = new Vector();
		softwareFilters = getSoftwareFiltersByProduct(product, softwareFilters,
				session);
		Iterator i = softwareFilters.iterator();

		while (i.hasNext()) {
			SoftwareFilter sf = (SoftwareFilter) i.next();

			sf.setChangeJustification("not determined yet");
			if (product.getDeleted())
				sf.setStatus("INACTIVE");
			else
				sf.setStatus("ACTIVE");
			sf.setChangeJustification(product.getProductInfo().getChangeJustification());
			sf.setComments(product.getProductInfo().getComments());
			sf.setChangeJustification(product.getProductInfo()
					.getChangeJustification());
			save(sf, product.getProductInfo().getRemoteUser(), session);
		}
	}

	public static SoftwareFilterForm setUpdateForm(String softwareFilterId)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		SoftwareFilter sf = getSoftwareFilter(softwareFilterId);

		SoftwareFilterForm softwareFilterForm = new SoftwareFilterForm();

		BeanUtils.copyProperties(softwareFilterForm, sf);

		// Need to set the software as beanutils
		// won't copy correctly
		softwareFilterForm.setSoftwareId(sf.getProduct().getId().toString());

		// Set these to null for we don't want them to show up in the form
		softwareFilterForm.setChangeJustification(null);
		softwareFilterForm.setComments(null);

		return softwareFilterForm;
	}

	public static SoftwareFilter getSoftwareFilter(String id)
			throws HibernateException, NamingException {

		SoftwareFilter softwareFilter = null;

		Session session = getHibernateSession();

		softwareFilter = getSoftwareFilter(id, softwareFilter, session);

		session.close();

		return softwareFilter;
	}

	public static SoftwareFilter getSoftwareFilter(String id,
			SoftwareFilter result, Session session) {

		result = (SoftwareFilter) session.getNamedQuery("softwareFilterById")
				.setLong("softwareFilterId", new Long(id).longValue())
				.uniqueResult();

		return result;
	}

	public static List getSoftwareFilterHistory(String softwareFilterId)
			throws HibernateException, NamingException {

		List softwareFilterHistory = null;

		Session session = getHibernateSession();

		softwareFilterHistory = getSoftwareFilterHistory(softwareFilterId,
				softwareFilterHistory, session);

		return softwareFilterHistory;
	}

	public static List getSoftwareFilterHistory(String softwareFilterId,
			List results, Session session) {

		results = session.getNamedQuery("softwareFilterHistory").setLong(
				"softwareFilter", new Long(softwareFilterId).longValue())
				.list();

		return results;
	}

	public static ActionErrors updateSoftwareFilter(
			SoftwareFilterForm softwareFilterForm, String remoteUser)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a software object
		SoftwareFilter softwareFilter = transferUpdateSoftwareFilterForm(
				softwareFilterForm, softwareFilterForm.getSoftwareId(), session);

		// Now we need to go through the logic of updating a new piece of
		// software
		ActionErrors errors = new ActionErrors();

		// Save the software
		save(softwareFilter, remoteUser, session);
		tx.commit();
		session.close();

		// Return the errors
		return errors;
	}

	private static SoftwareFilter transferUpdateSoftwareFilterForm(
			SoftwareFilterForm sff, String softwareId, Session session)
			throws IllegalAccessException, InvocationTargetException,
			HibernateException, NamingException {

		SoftwareFilter sf = null;
		sf = getSoftwareFilter(sff.getSoftwareFilterId(), sf, session);
		sf.setMapSoftwareVersion(sff.getMapSoftwareVersion().trim());
		sf.setStatus(sff.getStatus());
		sf.setChangeJustification(sff.getChangeJustification());

		if (!Util.isBlankString(sff.getComments())) {
			sf.setComments(sff.getComments());
		}

		return sf;
	}

	public static List searchByFileNameAndStatus(String softwareName,
			String status) throws HibernateException, Exception {

		List softwareFilters = new Vector();

		Session session = getHibernateSession();

		if (status.equals(Constants.ALL)) {
			softwareFilters = session.getNamedQuery("softwareFiltersByName")
					.setString("softwareName",
							"%" + softwareName.toUpperCase() + "%").list();
		} else {
			softwareFilters = session.getNamedQuery(
					"softwareFiltersByNameAndStatus").setString("softwareName",
					"%" + softwareName.toUpperCase() + "%").setString("status",
					status).list();
		}

		session.close();

		return softwareFilters;
	}

	public static ActionErrors addSearchSoftwareFilters(SoftwareFilterForm sff,
			Product to, String remoteUser) throws HibernateException,
			NamingException, IllegalAccessException, InvocationTargetException {

		ActionErrors errors = new ActionErrors();
		if (to.getDeleted()) {
			errors.add("softwareInactive", new ActionMessage(
					"errors.software.software.inactive"));
		} else {
			Session session = getHibernateSession();
			Transaction tx = session.beginTransaction();
		List<Long> selected = new Vector<Long>();

		for (int i = 0; i < sff.getSelectedItems().length; i++) {
			if (Util.isInt(sff.getSelectedItems()[i])) {
				selected.add(new Long(sff.getSelectedItems()[i]));
			}
		}

		List softwareFilters = null;
		softwareFilters = getSoftwareFilters(selected, softwareFilters,
				session);

		changeSoftwareFilterAssignment(softwareFilters, to, sff
				.getChangeJustification(), sff.getComments(), remoteUser,
				session);

		tx.commit();
		session.close();
	}
		// Return the errors
		return errors;
	}

	public static List getNewSoftwareFilters(Pagination pagination)
			throws HibernateException, NamingException {

		List filters = null;

		Session session = getHibernateSession();

		filters = session.getNamedQuery("getNewFilters").setFirstResult(
				pagination.getFirstResult()).setMaxResults(
				pagination.getResultsPerPage()).list();

		session.close();

		return filters;
	}

	public static ActionErrors removeNewSoftwareFilters(SoftwareFilterForm sff,
			String remoteUser) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {
		Session session = getHibernateSession();

		ActionErrors errors = new ActionErrors();
		List<Long> selected = new Vector<Long>();

		for (int i = 0; i < sff.getSelectedItems().length; i++) {
			if (Util.isInt(sff.getSelectedItems()[i])) {
				selected.add(new Long(sff.getSelectedItems()[i]));
			}
		}

		Product to = null;
		to = ProductDelegate.getProductByName(Constants.UNKNOWN, to, session);
		if (to.getDeleted()) {
			errors.add("softwareInactive", new ActionMessage(
					"errors.software.software.inactive"));
		} else {
			Transaction tx = session.beginTransaction();
			List softwareFilters = null;
			softwareFilters = getSoftwareFilters(selected, softwareFilters,
					session);

			changeSoftwareFilterAssignment(softwareFilters, to, sff
					.getChangeJustification(), sff.getComments(), remoteUser,
					session);

			tx.commit();
		}
		session.close();

		// Return the errors
		return errors;
	}

	public static SoftwareFilter getSoftwareFilter(String softwareName,
			String softwareVersion) throws HibernateException, NamingException {

		SoftwareFilter filter = null;

		Session session = getHibernateSession();

		filter = getSoftwareFilter(softwareName, softwareVersion, filter,
				session);

		session.close();

		return filter;
	}

	public static SoftwareFilter getSoftwareFilter(String softwareName,
			String softwareVersion, SoftwareFilter result, Session session) {

		result = (SoftwareFilter) session.getNamedQuery(
				"getFilterByNameByVersion").setString("softwareName",
				softwareName).setString("softwareVersion", softwareVersion)
				.uniqueResult();

		return result;
	}

	public static String massLoadFilters(String str, Validator val,
			ValidatorResources resources, String remoteUser, int i)
			throws ValidatorException, HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		ResourceBundle apps = ResourceBundle.getBundle("ApplicationResources");
		ValidatorResults results = null;
		String patternStr = "	";
		String[] f = str.split(patternStr);

		if (f.length != 8) {
			return "Invalid number of columns on line " + i + "\n";
		}

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		SoftwareFilterForm sff = new SoftwareFilterForm();

		sff.setSoftwareName(f[0].trim());
		sff.setSoftwareVersion(f[1].trim());
		sff.setOsType(Util.isBlankString(f[2]) ? null : f[2]);
		sff.setEndOfSupport(f[3]);
		sff.setMapSoftwareVersion(f[5].trim());
		sff.setComments(f[6]);
		sff.setChangeJustification(f[7]);

		Product product = null;
		String productName = f[4].trim();
		if(productName.contains(",") && productName.startsWith("\"") && productName.endsWith("\""))
			productName = productName.substring(1, productName.lastIndexOf("\""));
		
		product = ProductDelegate.getNonTadzProductByName(productName, product, session);
		if (product != null) {
			if (product.getDeleted()) {
				session.close();
				return "ERROR [" + i + "]: " + "Software Product is inactive: "
				+ product.getName() + " is inactive\n";
			}
			sff.setSoftwareId(product.getId().toString());
		} else {
			session.close();
			return "ERROR [" + i + "]: " + "Software Product Does Not Exist: "
			+ productName + " does not exist\n";
		}

		val.setParameter(Validator.BEAN_PARAM, sff);
		results = val.validate();

		Form form = resources.getForm(Locale.getDefault(),
				"/SoftwareFilterSave");

		Iterator j = results.getPropertyNames().iterator();
		while (j.hasNext()) {
			String propName = (String) j.next();
			Field field = form.getField(propName);

			String pFieldName = field.getArg(0).getKey();
			ValidatorResult result = results.getValidatorResult(propName);

			Iterator k = result.getActions();

			while (k.hasNext()) {
				String name = (String) k.next();

				ValidatorAction action = resources.getValidatorAction(name);

				if (!result.isValid(name)) {
					String err = apps.getString(action.getMsg());

					Object[] args = { pFieldName };
					session.close();
					return "ERROR [" + i + "]: "
							+ MessageFormat.format(err, args) + " \n";
				}
			}
		}

		if (!Util.isBlankString(sff.getOsType())) {
			sff.setOsType(Util.findValue(sff.getOsType(), null,
					Constants.OS_TYPES));

			if (sff.getOsType() == null) {
				session.close();
				return "Invalid OS Type on line " + i + " \n";
			}
		}

		SoftwareFilter softwareFilter = null;

		softwareFilter = SoftwareFilterDelegate.getSoftwareFilter(sff
				.getSoftwareName(), sff.getSoftwareVersion(), softwareFilter,
				session);

		if (softwareFilter == null) {
			softwareFilter = new SoftwareFilter();

		}

		softwareFilter.setProduct(product);
		softwareFilter.setSoftwareName(sff.getSoftwareName());
		softwareFilter.setSoftwareVersion(sff.getSoftwareVersion());
		softwareFilter.setMapSoftwareVersion(sff.getMapSoftwareVersion());
		softwareFilter.setEndOfSupport(Util.parseDayString(sff
				.getEndOfSupport()));
		softwareFilter.setOsType(sff.getOsType());
		softwareFilter.setChangeJustification(sff.getChangeJustification());
		softwareFilter.setComments(sff.getComments());
		softwareFilter.setStatus(Constants.ACTIVE);

		try {
			SoftwareFilterDelegate.save(softwareFilter, remoteUser, session);
			tx.commit();
			session.close();
		} catch (Exception e) {
			session.close();
			logger.error(e, e);
			return "ERROR [" + i + "]: "
					+ "An error occurred when saving the data to the DB "
					+ e.getCause() + "\n";
		}

		return "Successful update line " + i + " \n";
	}

	public static List getHistoryYears() throws HibernateException,
			NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareFilterHistoryYears").list();

		session.close();

		return years;
	}

	public static List getHistoryMonths(String year) throws HibernateException,
			NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareFilterHistoryMonths").setString(
				"year", year).list();

		session.close();

		return years;
	}

	public static List getHistoryByYearByMonth(String year, String month,
			Pagination pagination) throws HibernateException, NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareFilterHistoryByYearByMonth")
				.setString("year", year).setString("month", month)
				.setFirstResult(pagination.getFirstResult()).setMaxResults(
						pagination.getResultsPerPage()).list();

		session.close();

		return years;
	}

	public static Long getHistoryByYearByMonthCount(String year, String month)
			throws HibernateException, NamingException {

		Long count = null;

		Session session = getHibernateSession();

		count = (Long) session.getNamedQuery(
				"softwareFilterHistoryByYearByMonthCount").setString("year",
				year).setString("month", month).uniqueResult();

		session.close();

		return count;
	}
}
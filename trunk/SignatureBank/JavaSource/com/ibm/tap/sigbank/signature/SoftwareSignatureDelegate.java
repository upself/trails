/*
 * Created on Mar 29, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.signature;

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
import org.apache.struts.action.ActionMessage;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import com.ibm.asset.swkbt.domain.Product;
import com.ibm.tap.sigbank.software.ProductDelegate;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Delegate;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.software.Software;


/**
 * @@author Thomas
 * 
 *          TODO To change the template for this generated type comment go to
 *          Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class SoftwareSignatureDelegate extends Delegate {

	static Logger logger = Logger.getLogger(SoftwareSignatureDelegate.class);

	public static void updateSignatures(Product product, Session session)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		List sigs = null;
		sigs = getSoftwareSignaturesByProduct(product, sigs, session);

		if (sigs != null) {
			Iterator i = sigs.iterator();

			while (i.hasNext()) {
				SoftwareSignature ss = (SoftwareSignature) i.next();
				ss.setChangeJustification(product.getProductInfo()
						.getChangeJustification());
				ss.setComments(product.getProductInfo().getComments());
				if (product.getDeleted())
					ss.setStatus("INACTIVE");
				else
					ss.setStatus("ACTIVE");
				save(ss, product.getProductInfo().getRemoteUser(), session);
			}
		}
	}

	/**
	 * @@param software
	 * @@return
	 * @@throws Exception
	 * @@throws HibernateException
	 * @@throws NamingException
	 */
	public static List getSoftwareSignaturesByProduct(Product product)
			throws HibernateException, NamingException {

		List softwareSignatures = new Vector();

		Session session = getHibernateSession();

		softwareSignatures = getSoftwareSignaturesByProduct(product,
				softwareSignatures, session);

		session.close();

		return softwareSignatures;
	}

	public static List getSoftwareSignaturesByProduct(Product product,
			List results, Session session) throws HibernateException,
			NamingException {

		results = session.getNamedQuery("softwareSignaturesByProduct")
				.setEntity("product", product).list();

		return results;
	}

	public static ActionErrors addSoftwareSignature(
			SoftwareSignatureForm softwareSignatureForm, Product product,
			String remoteUser) throws IllegalAccessException,
			InvocationTargetException, HibernateException, NamingException {
		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a software signature object
		SoftwareSignature softwareSignature = transferAddSoftwareSignatureForm(
				softwareSignatureForm, product, session);

		// Now we need to go through the logic of adding a new software
		// signature
		ActionErrors errors = new ActionErrors();

		// Get the software signature by name and size
		SoftwareSignature ssByNameAndSize = null;
		ssByNameAndSize = getSoftwareSignature(softwareSignature.getFileName(),
				softwareSignature.getFileSize().intValue(), ssByNameAndSize,
				session);

		// If the software signature exists by name and size
		if (ssByNameAndSize != null) {

			// If the ssByNameAndSize is active we cannot add this because it
			// exists
			if (!ssByNameAndSize.getProduct().getId().equals(
					softwareSignature.getProduct().getId())) {
				errors.add("fileName", new ActionMessage(
						"errors.software.signature.duplicate"));
			return errors;
			}

			// Update the software signature id to the one that exists, this
			// will activate it
			softwareSignature.setSoftwareSignatureId(ssByNameAndSize
					.getSoftwareSignatureId());
		}

		// evict
		session.evict(ssByNameAndSize);

		// Save the software
		save(softwareSignature, remoteUser, session);
		tx.commit();
		session.close();

		// return the errors
		return errors;
	}

	private static SoftwareSignature transferAddSoftwareSignatureForm(
			SoftwareSignatureForm ssf, Product product, Session session)
			throws IllegalAccessException, InvocationTargetException {

		SoftwareSignature ss = new SoftwareSignature();

		// Set our required fields
		ss.setChangeJustification(ssf.getChangeJustification());
		ss.setFileName(ssf.getFileName().trim());
		ss.setSoftwareVersion(ssf.getSoftwareVersion());
		ss.setStatus(Constants.ACTIVE);
		ss.setProduct(product);

		// We shouldn't need to worry about the integer as it was checked on
		// validation
		ss.setFileSize(new Integer(ssf.getFileSize()));

		// Set our voluntary fields
		if (!Util.isBlankString(ssf.getOsType())) {
			ss.setOsType(ssf.getOsType());
		}
		if (!Util.isBlankString(ssf.getChecksumCrc32())) {
			ss.setChecksumCrc32(ssf.getChecksumCrc32());
		}
		if (!Util.isBlankString(ssf.getChecksumMd5())) {
			ss.setChecksumMd5(ssf.getChecksumMd5());
		}
		if (!Util.isBlankString(ssf.getChecksumQuick())) {
			ss.setChecksumQuick(ssf.getChecksumQuick());
		}
		if (!Util.isBlankString(ssf.getComments())) {
			ss.setComments(ssf.getComments());
		}
		if (!Util.isBlankString(ssf.getSignatureSource())) {
			ss.setSignatureSource(ssf.getSignatureSource());
		}
		if (!Util.isBlankString(ssf.getTcmId())) {
			ss.setTcmId(ssf.getTcmId());
		}

		// We shouldn't need to worry about this as it was checked on validation
		if (!Util.isBlankString(ssf.getEndOfSupport())) {
			ss.setEndOfSupport(Util.parseDayString(ssf.getEndOfSupport()));
		}

		return ss;
	}

	public static SoftwareSignature getSoftwareSignature(String fileName,
			int fileSize) throws HibernateException, NamingException {

		SoftwareSignature softwareSignature = null;

		Session session = getHibernateSession();

		softwareSignature = getSoftwareSignature(fileName, fileSize,
				softwareSignature, session);

		session.close();

		return softwareSignature;
	}

	public static SoftwareSignature getSoftwareSignature(String fileName,
			int fileSize, SoftwareSignature result, Session session)
			throws HibernateException, NamingException {

		result = (SoftwareSignature) session
				.getNamedQuery("softwareSignaturesByFileNameFileSize")
				.setString("fileName", fileName)
				.setInteger("fileSize", fileSize).uniqueResult();

		return result;
	}
	
	public static SoftwareSignature getAllSoftwareSignature(String fileName,
			int fileSize, SoftwareSignature result, Session session)
			throws HibernateException, NamingException {

		result = (SoftwareSignature) session
				.getNamedQuery("allSoftwareSignaturesByFileNameFileSize")
				.setString("fileName", fileName)
				.setInteger("fileSize", fileSize).uniqueResult();

		return result;
	}

	public static void save(SoftwareSignature ss, String remoteUser,
			Session session) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		ss.setRecordTime(new Date());
		ss.setRemoteUser(remoteUser);

		// Create a software Filter history object
		SoftwareSignatureH ssh = new SoftwareSignatureH();

		// Copy over the properties that we can
		BeanUtils.copyProperties(ssh, ss);

		// Set our other fields that won't copy
		ssh.setSoftwareSignature(ss);

		// We want to save or update our software
		session.saveOrUpdate(ss);

		// We want a pure save of the history for it will always be new
		session.save(ssh);

		// Evict the software it is holding onto
		session.evict(ss.getProduct());
	}

	public static SoftwareSignatureForm setUpdateForm(String softwareSignatureId)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		SoftwareSignature ss = getSoftwareSignature(softwareSignatureId);

		SoftwareSignatureForm softwareSignatureForm = new SoftwareSignatureForm();

		BeanUtils.copyProperties(softwareSignatureForm, ss);

		// Need to set the software as beanutils
		// won't copy correctly
		softwareSignatureForm.setSoftwareId(ss.getProduct().getId().toString());
		// Set these to null for we don't want them to show up in the form
		softwareSignatureForm.setChangeJustification(null);
		softwareSignatureForm.setComments(null);

		return softwareSignatureForm;
	}

	public static SoftwareSignature getSoftwareSignature(String id)
			throws HibernateException, NamingException {

		SoftwareSignature softwareSignature = null;

		Session session = getHibernateSession();

		softwareSignature = getSoftwareSignature(id, softwareSignature, session);

		session.close();

		return softwareSignature;
	}

	public static SoftwareSignature getSoftwareSignature(String id,
			SoftwareSignature result, Session session) {

		result = (SoftwareSignature) session
				.getNamedQuery("softwareSignatureById")
				.setLong("softwareSignatureId", new Long(id).longValue())
				.uniqueResult();

		return result;
	}

	public static List getSoftwareSignatureHistory(String softwareSignatureId)
			throws HibernateException, NamingException {

		List softwareSignatureHistory = null;

		Session session = getHibernateSession();

		softwareSignatureHistory = getSoftwareSignatureHistory(
				softwareSignatureId, softwareSignatureHistory, session);

		return softwareSignatureHistory;
	}

	public static List getSoftwareSignatureHistory(String softwareSignatureId,
			List results, Session session) {

		results = session
				.getNamedQuery("softwareSignaturesHistory")
				.setLong("softwareSignature",
						new Long(softwareSignatureId).longValue()).list();

		return results;
	}

	public static ActionErrors updateSoftwareSignature(
			SoftwareSignatureForm softwareSignatureForm, String remoteUser)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a software object
		SoftwareSignature softwareSignature = transferUpdateSoftwareSignatureForm(
				softwareSignatureForm, softwareSignatureForm.getSoftwareId(),
				session);

		// Now we need to go through the logic of updating a new piece of
		// software
		ActionErrors errors = new ActionErrors();

		// Grab the software from the database using the ID
		SoftwareSignature softwareSignatureById = null;
		softwareSignatureById = getSoftwareSignature(softwareSignature
				.getSoftwareSignatureId().toString(), softwareSignatureById,
				session);

		// Grab the software from the database using the software name
		SoftwareSignature ssByNameAndSize = null;
		ssByNameAndSize = getSoftwareSignature(softwareSignature.getFileName(),
				softwareSignature.getFileSize().intValue(), ssByNameAndSize,
				session);

		// If the software name exists in the database
		if (ssByNameAndSize != null) {

			// If the IDs of the two from the db are not equal
			if (!softwareSignatureById.getSoftwareSignatureId().equals(
					ssByNameAndSize.getSoftwareSignatureId())) {

				// If software by name is active, error
				if (ssByNameAndSize.getStatus().equalsIgnoreCase(
						Constants.ACTIVE)) {
					errors.add("softwareName", new ActionMessage(
							"errors.software.duplicate"));
					return errors;
				}

				// Since we are updating a record that exists as inactive
				// We need to inactivate the software by id and activate the
				// software by name

				// Set the comment for the software we are inactivating
				softwareSignatureById.setStatus(Constants.INACTIVE);
				softwareSignatureById.setComments("SOFTWARE SIGNATURE CHANGE: "
						+ softwareSignature.getFileName());
				softwareSignatureById.setChangeJustification(softwareSignature
						.getChangeJustification());

				save(softwareSignatureById, remoteUser, session);

				// Set our id to that of the software by name to do our update
				softwareSignature.setSoftwareSignatureId(ssByNameAndSize
						.getSoftwareSignatureId());
			} else {
				session.evict(softwareSignatureById);
			}

			session.evict(ssByNameAndSize);
		} else {
			session.evict(softwareSignatureById);
		}

		// Save the software
		save(softwareSignature, remoteUser, session);
		tx.commit();
		session.close();

		// Return the errors
		return errors;
	}

	private static SoftwareSignature transferUpdateSoftwareSignatureForm(
			SoftwareSignatureForm ssf, String softwareId, Session session)
			throws IllegalAccessException, InvocationTargetException,
			HibernateException, NamingException {

		SoftwareSignature ss = new SoftwareSignature();

		Product product = null;
		product = ProductDelegate.getProduct(ssf.getSoftwareId(), product,
				session);
		// Set our required fields
		ss.setSoftwareSignatureId(new Long(ssf.getSoftwareSignatureId()));
		ss.setChangeJustification(ssf.getChangeJustification());
		ss.setFileName(ssf.getFileName().trim());
		ss.setOsType(ssf.getOsType());
		ss.setSoftwareVersion(ssf.getSoftwareVersion());
		ss.setStatus(ssf.getStatus());
		ss.setProduct(product);

		// We shouldn't need to worry about the integer as it was checked on
		// validation
		ss.setFileSize(new Integer(ssf.getFileSize()));

		// Set our voluntary fields
		if (!Util.isBlankString(ssf.getChecksumCrc32())) {
			ss.setChecksumCrc32(ssf.getChecksumCrc32());
		}
		if (!Util.isBlankString(ssf.getChecksumMd5())) {
			ss.setChecksumMd5(ssf.getChecksumMd5());
		}
		if (!Util.isBlankString(ssf.getChecksumQuick())) {
			ss.setChecksumQuick(ssf.getChecksumQuick());
		}
		if (!Util.isBlankString(ssf.getComments())) {
			ss.setComments(ssf.getComments());
		}

		// We shouldn't need to worry about this as it was checked on validation
		if (!Util.isBlankString(ssf.getEndOfSupport())) {
			ss.setEndOfSupport(Util.parseDayString(ssf.getEndOfSupport()));
		}

		return ss;
	}

	public static ActionErrors moveSoftwareSignatures(
			SoftwareSignatureForm ssf, String remoteUser)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		ActionErrors errors = new ActionErrors();
		List<Long> selected = new Vector<Long>();

		for (int i = 0; i < ssf.getSelectedItems().length; i++) {
			if (Util.isInt(ssf.getSelectedItems()[i])) {
				selected.add(new Long(ssf.getSelectedItems()[i]));
			}
		}

		Product to = null;
		to = ProductDelegate.getProduct(ssf.getSoftwareId(), to, session);
		if (to.getDeleted()) {
			errors.add("softwareInactive", new ActionMessage(
					"errors.software.software.inactive"));
		} else {
			List<SoftwareSignature> softwareSignatures = null;
			softwareSignatures = getSoftwareSignatures(selected,
					softwareSignatures, session);

			changeSoftwareSignatureAssignment(softwareSignatures, to, ssf
					.getChangeJustification(), ssf.getComments(), remoteUser,
					session);

		tx.commit();
		session.close();
		}
		// Return the errors
		return errors;
	}

	public static void changeSoftwareSignatureAssignment(
			List softwareSignatures, Product to, String changeJustification,
			String comments, String remoteUser, Session session)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		Iterator i = softwareSignatures.iterator();
		while (i.hasNext()) {
			SoftwareSignature ss = (SoftwareSignature) i.next();
			if (ss.getProduct().getId() == to.getId()) {
				continue;
			}

			if (to.getName().equals(Constants.UNKNOWN)) {
				ss.setStatus(Constants.INACTIVE);
			} else {
				ss.setStatus(Constants.ACTIVE);
			}

			ss.setProduct(to);
			ss.setChangeJustification(changeJustification);
			ss.setComments(comments);
			save(ss, remoteUser, session);
		}
	}

	private static List getSoftwareSignatures(List selected, List results,
			Session session) {

		results = session.getNamedQuery("softwareSignaturesByIdList")
				.setParameterList("ids", selected).list();

		return results;
	}

	public static List searchByFileName(String fileName)
			throws HibernateException, Exception {

		List softwareSignatures = new Vector();

		Session session = getHibernateSession();

		softwareSignatures = session
				.getNamedQuery("softwareSignaturesByFileName")
				.setString("fileName", "%" + fileName.toUpperCase() + "%")
				.list();

		session.close();

		return softwareSignatures;
	}

	public static ActionErrors addSearchSoftwareSignatures(
			SoftwareSignatureForm ssf, Product to, String remoteUser)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {
		ActionErrors errors = new ActionErrors();
		if (to.getDeleted()) {
			errors.add("softwareInactive", new ActionMessage(
					"errors.software.software.inactive"));
		} else {
			Session session = getHibernateSession();
			Transaction tx = session.beginTransaction();
		
			List<Long> selected = new Vector<Long>();

			for (int i = 0; i < ssf.getSelectedItems().length; i++) {
				if (Util.isInt(ssf.getSelectedItems()[i])) {
					selected.add(new Long(ssf.getSelectedItems()[i]));
				}
			}

			List softwareSignatures = null;
			softwareSignatures = getSoftwareSignatures(selected,
					softwareSignatures, session);

			changeSoftwareSignatureAssignment(softwareSignatures, to,
					ssf.getChangeJustification(), ssf.getComments(),
					remoteUser, session);

			tx.commit();
			session.close();
		}

		// Return the errors
		return errors;
	}

	public static String massLoadSignatures(String str, Validator val,
			ValidatorResources resources, String remoteUser, int i)
			throws ValidatorException, HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		ResourceBundle apps = ResourceBundle.getBundle("ApplicationResources");
		ValidatorResults results = null;
		String patternStr = "	";
		String[] f = str.split(patternStr);

		if (f.length != 11) {
			return "Invalid number of columns on line " + i + "( " + f.length
					+ " found)\n";
		}

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		SoftwareSignatureForm ssf = new SoftwareSignatureForm();

		ssf.setFileName(f[0].trim());
		ssf.setFileSize(f[1]);
		ssf.setOsType(Util.isBlankString(f[2]) ? null : f[2]);
		ssf.setEndOfSupport(f[3]);
		ssf.setChecksumQuick(f[4]);
		ssf.setChecksumCrc32(f[5]);
		ssf.setChecksumMd5(f[6]);
		ssf.setSoftwareVersion(f[8]);
		ssf.setComments(f[9]);
		ssf.setChangeJustification(f[10]);

		Product product = null;
		String productName = f[7].trim();
		if(productName.contains(",") && productName.startsWith("\"") && productName.endsWith("\""))
			productName = productName.substring(1, productName.lastIndexOf("\""));
		
		product = ProductDelegate.getNonTadzProductByName(productName, product, session);

		if (product != null) {
			if (product.getDeleted()) {
				session.close();
				return "ERROR [" + i + "]: " + "Software Product is inactive: "
						+ product.getName() + " is inactive\n";
			}

			ssf.setSoftwareId(product.getId().toString());
		} else {
			session.close();
			return "ERROR [" + i + "]: " + "Software Product Does Not Exist: "
			        + productName + " does not exist\n";
		}

		val.setParameter(Validator.BEAN_PARAM, ssf);
		results = val.validate();

		Form form = resources.getForm(Locale.getDefault(),
				"/MassSoftwareSignatureSave");

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
					System.out.println("ERROR [" + i + "]: "
							+ MessageFormat.format(err, args) + "\n");
					return "ERROR [" + i + "]: "
							+ MessageFormat.format(err, args) + "\n";
				}
			}
		}

		if (!Util.isBlankString(ssf.getOsType())) {
			ssf.setOsType(Util.findValue(ssf.getOsType(), null,
					Constants.OS_TYPES));

			if (ssf.getOsType() == null) {
				session.close();
				return "Invalid OS Type on line " + i + "\n";
			}
		}

		SoftwareSignature softwareSignature = transferAddSoftwareSignatureForm(
				ssf, product, session);

		SoftwareSignature softwareSignatureExist = null;
		softwareSignatureExist = SoftwareSignatureDelegate
				.getAllSoftwareSignature(ssf.getFileName(),
						new Integer(ssf.getFileSize()).intValue(),
						softwareSignatureExist, session);

		if (softwareSignatureExist != null) {
			softwareSignature.setSoftwareSignatureId(softwareSignatureExist
					.getSoftwareSignatureId());
			session.evict(softwareSignatureExist);
		}
		softwareSignature.setStatus(Constants.ACTIVE);

		try {
			SoftwareSignatureDelegate.save(softwareSignature, remoteUser,
					session);
			tx.commit();
			session.close();
		} catch (Exception e) {
			session.close();
			logger.error(e, e);
			return "ERROR [" + i + "]: "
					+ "An error occurred when saving the data to the DB "
					+ e.getCause() + "\n";
		}

		return "Successful update line " + i + "\n";
	}

	public static List getHistoryYears() throws HibernateException,
			NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareSignatureHistoryYears").list();

		session.close();

		return years;
	}

	public static List getHistoryMonths(String year) throws HibernateException,
			NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareSignatureHistoryMonths")
				.setString("year", year).list();

		session.close();

		return years;
	}

	public static List getHistoryByYearByMonth(String year, String month)
			throws HibernateException, NamingException {

		List years = null;

		Session session = getHibernateSession();

		years = session.getNamedQuery("softwareSignatureHistoryByYearByMonth")
				.setString("year", year).setString("month", month).list();

		session.close();

		return years;
	}
}
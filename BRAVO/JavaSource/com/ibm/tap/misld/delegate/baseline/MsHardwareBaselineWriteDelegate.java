/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.baseline;

import java.util.Date;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.SoftwareLpar;
import com.ibm.tap.misld.delegate.software.SoftwareReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.LoadException;
import com.ibm.tap.misld.om.baseline.MsHardwareBaseline;
import com.ibm.tap.misld.om.baseline.MsInstalledSoftwareBaseline;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MsHardwareBaselineWriteDelegate extends Delegate {

	/**
	 * @param msHardwareBaseline
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveHardwareBaseline(
			SoftwareLpar softwareLparForm, SoftwareLpar softwareLpar, String remoteUser)
			throws HibernateException, NamingException {

		//softwareLpar.
		softwareLpar.setComment(softwareLparForm.getComment());
		softwareLpar.setCountryCodeId(softwareLparForm.getCountryCodeId());
		softwareLpar.setRecordTime(new Date());
		softwareLpar.setRemoteUser(remoteUser);

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(softwareLpar);

		tx.commit();
		session.close();

	}

	/**
	 * @param stringFields
	 * @param remoteUser
	 * @param customer
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void loadHardware(String[] stringFields, String remoteUser,
			Customer customer) throws LoadException, HibernateException,
			NamingException {

		Integer processorCount;

		String accountNumber = ((String) stringFields[0]).toUpperCase();
		String nodeName = ((String) stringFields[1]).toUpperCase();
		String serialNumber = ((String) stringFields[2]).toUpperCase();
		String machineType = ((String) stringFields[3]).toUpperCase();
		String machineModel = ((String) stringFields[4]).toUpperCase();
		String processorCountStr = ((String) stringFields[5]).toUpperCase();
		String nodeOwner = ((String) stringFields[6]).toUpperCase();
		String status = ((String) stringFields[7]).toUpperCase();
		String country = ((String) stringFields[8]).toUpperCase();

		if (Util.isBlankString(accountNumber)) {
			throw new LoadException("Account Id is missing");
		}
		if (Util.isBlankString(nodeName)) {
			throw new LoadException("Server name is missing");
		}
		if (Util.isBlankString(serialNumber)) {
			serialNumber = "UNKNOWN";
		}
		if (Util.isBlankString(processorCountStr)) {
			throw new LoadException("Processor count is blank");
		} else {
			if (!Util.isInt(processorCountStr)) {
				throw new LoadException(
						"Processor count is in incorrect format");
			} else {
				processorCount = new Integer(processorCountStr);
			}
		}
		if (Util.isBlankString(status)) {
			throw new LoadException("Status is blank");
		}
		if (Util.isBlankString(nodeOwner)) {
			throw new LoadException("Machine owner is blank");
		}

		if (customer.getMisldAccountSettings().isUsMachines()) {
			if (!country.equals("US")) {
				throw new LoadException(
						"Country must be set to US for this line item due to account settings constraint");
			}
		}

		//Grab the baseline if already exists
		MsHardwareBaseline msHardwareBaseline = null;
		//	MsHardwareBaselineReadDelegate.getMsHardwareBaselineByNodeName(customer, nodeName);
		MsInstalledSoftwareBaseline msInstalledSoftwareBaseline = null;

		if (msHardwareBaseline == null) {
			msHardwareBaseline = new MsHardwareBaseline();
			msHardwareBaseline.setNodeName(nodeName);
			msHardwareBaseline.setCustomer(customer);
			msHardwareBaseline.setLoader(Constants.MANUAL);
			msHardwareBaseline.setScanTime(new Date());

			msInstalledSoftwareBaseline = new MsInstalledSoftwareBaseline();

		}

		if (!Util.isBlankString(country)) {
			msHardwareBaseline.setCountry(country);
		}

		if (!Util.isBlankString(machineModel)) {
			msHardwareBaseline.setMachineModel(machineModel);
		}

		if (!Util.isBlankString(machineType)) {
			msHardwareBaseline.setMachineType(machineType);
		}

		msHardwareBaseline.setNodeOwner(nodeOwner);
		msHardwareBaseline.setProcessorCount(processorCount);
		msHardwareBaseline.setRecordTime(new Date());
		msHardwareBaseline.setRemoteUser(remoteUser);
		msHardwareBaseline.setSerialNumber(serialNumber);
		msHardwareBaseline.setStatus(status);

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(msHardwareBaseline);
		session.flush();

		if (msInstalledSoftwareBaseline != null) {
			msInstalledSoftwareBaseline
					.setMsHardwareBaseline(msHardwareBaseline);
			msInstalledSoftwareBaseline.setLoader(Constants.MANUAL);
			msInstalledSoftwareBaseline.setRecordTime(new Date());
			msInstalledSoftwareBaseline.setRemoteUser(remoteUser);
			msInstalledSoftwareBaseline.setScanTime(new Date());

			Product software = SoftwareReadDelegate
					.getSoftwareByName(Constants.NO_OPERATING_SYSTEM);

			msInstalledSoftwareBaseline.setSoftware(software);
			msInstalledSoftwareBaseline.setStatus(Constants.ACTIVE);
			session.save(msInstalledSoftwareBaseline);
			session.flush();
		}

		tx.commit();
		session.close();

	}
}
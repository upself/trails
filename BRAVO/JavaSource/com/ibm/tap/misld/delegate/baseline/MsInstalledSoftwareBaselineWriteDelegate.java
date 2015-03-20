/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.baseline;

import java.util.Date;
import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.sigbank.InstalledSoftware;
import com.ibm.ea.sigbank.InstalledSoftwareEff;
//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End
import com.ibm.ea.sigbank.SoftwareLpar;
import com.ibm.tap.misld.delegate.software.SoftwareReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.exceptions.LoadException;
import com.ibm.tap.misld.om.baseline.MsInstalledSoftwareBaseline;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MsInstalledSoftwareBaselineWriteDelegate extends Delegate {

	/**
	 * @param msInstalledSoftwareBaselineForm
	 * @param msInstalledSoftwareBaseline
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveSoftware(
			InstalledSoftwareEff installedSoftwareEffForm,
			InstalledSoftware installedSoftware,
			String remoteUser) throws HibernateException, NamingException {

		InstalledSoftwareEff installedSoftwareEff = new InstalledSoftwareEff();

		installedSoftwareEff.setInstalledSoftware(installedSoftware);

		if (installedSoftwareEffForm.getId() != null &&
				installedSoftwareEffForm.getId() > 0) {
			installedSoftwareEff.setId(installedSoftwareEffForm.getId());
		}
		installedSoftwareEff.setInstalledSoftwareId(installedSoftwareEffForm.getInstalledSoftwareId());
		installedSoftwareEff.setUserCount(installedSoftwareEffForm.getUserCount());
	    installedSoftwareEff.setOwner(installedSoftwareEffForm.getOwner());		
		installedSoftwareEff.setComment(installedSoftwareEffForm.getComment());
		installedSoftwareEff.setRemoteUser(remoteUser);
		installedSoftwareEff.setRecordTime(new Date());

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(installedSoftwareEff);

		tx.commit();
		session.close();

	}

	/**
	 * @param msInstalledSoftwareBaselineForm
	 * @param msInstalledSoftwareBaseline
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveOsSoftware(
			InstalledSoftwareEff installedSoftwareEffForm,
			InstalledSoftware installedSoftware,
			String remoteUser) throws HibernateException, NamingException {

		String authenticated = null;

		InstalledSoftwareEff installedSoftwareEff = new InstalledSoftwareEff();

		installedSoftwareEff.setInstalledSoftware(installedSoftware);

		if (installedSoftwareEffForm.getId() != null &&
			installedSoftwareEffForm.getId() > 0) {
			installedSoftwareEff.setId(installedSoftwareEffForm.getId());
		}
		installedSoftwareEff.setInstalledSoftwareId(installedSoftwareEffForm.getInstalledSoftwareId());
		installedSoftwareEff.setUserCount(installedSoftwareEffForm.getUserCount());
	    installedSoftwareEff.setOwner(installedSoftwareEffForm.getOwner());		
	    installedSoftwareEff.setAuthenticated(installedSoftwareEffForm.getAuthenticated());
		installedSoftwareEff.setComment(installedSoftwareEffForm.getComment());
		installedSoftwareEff.setRemoteUser(remoteUser);
		installedSoftwareEff.setRecordTime(new Date());
		
		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(installedSoftwareEff);

		tx.commit();
		session.close();

	}

	/**
	 * @param msInstalledSoftwareBaselineForm
	 * @param msInstalledSoftwareBaseline
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void addNewSoftware(
			MsInstalledSoftwareBaseline msInstalledSoftwareBaseline,
			String remoteUser) throws HibernateException, NamingException {

		//Change Bravo to use Software View instead of Product Object Start
		//Product software = SoftwareReadDelegate
		//		.getSoftwareByLong(msInstalledSoftwareBaseline
		//				.getSoftwareLong());
		
		Software software = SoftwareReadDelegate
				.getSoftwareByLong(msInstalledSoftwareBaseline
						.getSoftwareLong());
		//Change Bravo to use Software View instead of Product Object End

		//MsHardwareBaseline msHardwareBaseline = MsHardwareBaselineReadDelegate
		//		.getMsHardwareBaseline(msInstalledSoftwareBaseline
		//				.getMsHardwareBaselineId());

		if (msInstalledSoftwareBaseline.getUserCount().intValue() == 0) {
			msInstalledSoftwareBaseline.setUserCount(null);
		}

		msInstalledSoftwareBaseline.setScanTime(new Date());
		msInstalledSoftwareBaseline.setLoader(Constants.MANUAL);
		//msInstalledSoftwareBaseline.setMsHardwareBaseline(msHardwareBaseline);
		msInstalledSoftwareBaseline.setSoftware(software);
		msInstalledSoftwareBaseline.setRemoteUser(remoteUser);
		msInstalledSoftwareBaseline.setRecordTime(new Date());

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(msInstalledSoftwareBaseline);

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
	public static void loadSoftware(String[] stringFields, String remoteUser,
			Customer customer) throws LoadException, HibernateException,
			NamingException {

		Integer userCount = null;

		String accountNumber = ((String) stringFields[0]).toUpperCase();
		String nodeName = ((String) stringFields[1]).toUpperCase();
		String userCountStr = ((String) stringFields[2]);
		String softwareName = ((String) stringFields[3]).toUpperCase();
		String authenticated = ((String) stringFields[4]).toUpperCase();
		String softwareOwner = ((String) stringFields[5]).toUpperCase();

		if (Util.isBlankString(accountNumber)) {
			throw new LoadException("Account Id is missing");
		}
		if (Util.isBlankString(nodeName)) {
			throw new LoadException("Server name is missing");
		}
		if (Util.isBlankString(softwareName)) {
			throw new LoadException("Software name is blank");
		}
		//if (softwareOwner.equals(Constants.IBM)) {
		//	softwareBuyer = Constants.IBM;
		//}
		if (!Util.isBlankString(userCountStr)) {
			if (Util.isInt(userCountStr)) {
				userCount = new Integer(userCountStr);
			} else {
				throw new LoadException("User count is in incorrect format");
			}
		}

		//Get the software object
		//Change Bravo to use Software View instead of Product Object Start
		//Product software = SoftwareReadDelegate
		//		.getSoftwareByName(softwareName);
		
		Software software = SoftwareReadDelegate
				.getSoftwareByName(softwareName);
		//Change Bravo to use Software View instead of Product Object End
		if (software == null) {
			throw new LoadException("Invalid software name");
		}

		if (software.getSoftwareCategory().getSoftwareCategoryName().contains(
				Constants.OPERATING_SYSTEMS)) {
			//Can't set an operating system to inactive
			//if (!status.equals(Constants.ACTIVE)) {
			//	throw new LoadException(
			//			"Operating system status must be active.");
			//}
			if (!Util.isBlankString(authenticated)) {
				if (!authenticated.equals("Y")) {
					if (!authenticated.equals("N")) {
						throw new LoadException(
								"Authenticated is in incorrect format");
					}
				}
			}

		}

		//Grab the hardware baseline
		//MsHardwareBaseline msHardwareBaseline = MsHardwareBaselineReadDelegate
		//		.getMsHardwareBaselineByNodeName(customer, nodeName);
		SoftwareLpar softwareLpar = MsHardwareBaselineReadDelegate
				.getSoftwareLparByNodeName(customer,nodeName);

		if (softwareLpar == null) {
			throw new LoadException("Computer does not exist");
		}

		//MsInstalledSoftwareBaseline msInstalledSoftwareBaseline = null;
		InstalledSoftware installedSoftware = null;

		//Grab the software baseline
		if (software.getSoftwareCategory().getSoftwareCategoryId().intValue() == 1000) {
			installedSoftware = MsInstalledSoftwareBaselineReadDelegate
					.getUnknownInstalledSoftware(softwareLpar,software);
		} else {
			installedSoftware = MsInstalledSoftwareBaselineReadDelegate
					.getInstalledSoftwareBySoftwareName(softwareLpar, software);
					//.getInstalledSoftwareBySoftwareCategory(
					//		softwareLpar, software.getSoftwareCategory());
		}
		if(installedSoftware == null)
			throw new LoadException("Software \""+softwareName +"\" does not exist on server "+nodeName);
		
		InstalledSoftwareEff installedSoftwareEff = installedSoftware.getInstalledSoftwareEff();
		if (installedSoftwareEff == null) {
			installedSoftwareEff = new InstalledSoftwareEff();
			//installedSoftwareEff.setSoftwareLpar(softwareLpar);
			installedSoftwareEff.setLoader(Constants.MANUAL);
			//installedSoftware.setScanTime(new Date());
		}

		installedSoftwareEff.setInstalledSoftwareId(installedSoftware.getId().intValue());
		installedSoftwareEff.setInstalledSoftware(installedSoftware);
		Integer auth = 2;
		if (!Util.isBlankString(authenticated)) {
			//auth = Integer.parseInt(authenticated);
			if (authenticated.equals("Y")) {
				auth = 1;
			}
			if (authenticated.equals("N")) {
				auth = 0;
			}
		}
		installedSoftwareEff.setAuthenticated(auth);
		
		if (userCount != null) {
			installedSoftware.setUserCount(userCount);
		}
		if (!Util.isBlankString(softwareOwner)) {
			installedSoftwareEff.setOwner(softwareOwner);
		}

		installedSoftwareEff.setRecordTime(new Date());
		installedSoftwareEff.setRemoteUser(remoteUser);

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.saveOrUpdate(installedSoftwareEff);
		session.flush();

		tx.commit();
		session.close();

	}

}
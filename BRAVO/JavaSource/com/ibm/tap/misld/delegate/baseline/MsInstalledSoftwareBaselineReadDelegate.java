/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.baseline;

import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.ea.sigbank.InstalledSoftware;
import com.ibm.ea.sigbank.InstalledSoftwareEff;
//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End
import com.ibm.ea.sigbank.SoftwareCategory;
import com.ibm.ea.sigbank.SoftwareLpar;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.baseline.MsInstalledSoftwareBaseline;
import com.ibm.tap.misld.om.cndb.Customer;
/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MsInstalledSoftwareBaselineReadDelegate extends Delegate {

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getMsInstalledSoftwareBaseline(Customer customer)
			throws HibernateException, NamingException {

		List hardwareBaselineList = null;

		Session session = getHibernateSession();

		hardwareBaselineList = session.getNamedQuery(
				"getActiveMsInstalledSoftwareBaseline").setEntity("customer",
				customer).list();

		session.close();

		return hardwareBaselineList;
	}

	/**
	 * @param msHardwareBaseline
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getAllSoftware(int id)
			throws HibernateException, NamingException {

		List softwareList = null;

		Session session = getHibernateSession();

		softwareList = session.getNamedQuery(
				"getMsInstalledSoftwareBaselineByHardware").setInteger(
				"id", id).list();

		session.close();

		return softwareList;
	}

	/**
	 * @param msInstalledSoftwareBaselineId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static InstalledSoftware getInstalledSoftware(
			Long installedSoftwareId) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();

		InstalledSoftware installedSoftware = (InstalledSoftware) session
				.get(com.ibm.ea.sigbank.InstalledSoftware.class, installedSoftwareId);

		session.close();

		return installedSoftware;
	}

	/**
	 * @param installedSoftwareId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static InstalledSoftware getInstalledSoftware(
			int id) throws HibernateException, NamingException {

		Session session = getHibernateSession();

		InstalledSoftware installedSoftware = (InstalledSoftware) session
				.getNamedQuery("getInstalledSoftwareById")
				.setInteger("id", id).uniqueResult();

		session.close();

		return installedSoftware;
	}

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getActiveMsInstalledSoftwareBaseline(Customer customer)
			throws HibernateException, NamingException {

		List softwareList = null;

		Session session = getHibernateSession();

		softwareList = session.getNamedQuery(
				"getActiveMsInstalledSoftwareBaseline").setEntity("customer",
				customer).list();

		session.close();

		return softwareList;
	}

	/**
	 * @param customer
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getBaselineReport(Customer customer, String remoteUser)
			throws HibernateException, NamingException {

		List baseline = null;

		Session session = getHibernateSession();

		baseline = session.getNamedQuery("getInstalledSoftwareReport")
				.setEntity("customer", customer).list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			while (j.hasNext()) {
				InstalledSoftware installedSoftware = (InstalledSoftware) j
						.next();
				InstalledSoftwareEff installedSoftwareEff = installedSoftware.getInstalledSoftwareEff();

				Vector tempList = new Vector();
				tempList.add(new String("" + customer.getAccountNumber()));
				tempList.add(installedSoftware
						.getSoftwareLpar().getName());
				
				if (installedSoftwareEff == null || installedSoftwareEff.getUserCount() == null) {
					if (installedSoftware.getUserCount() == null) {
						tempList.add("");
					} else {
						tempList.add(new String(""
							+ installedSoftware.getUserCount()));
					}
				} else {
					if (installedSoftwareEff.getUserCount() == null) {
						tempList.add("");
					} else {
						tempList.add(new String("" + installedSoftwareEff.getUserCount()));
					}
				}
				//tempList.add(installedSoftware.getStatus());
				tempList.add(installedSoftware.getSoftware().getSoftwareName());
				
				String authenticated = null;
				if (installedSoftwareEff == null || installedSoftwareEff.getAuthenticated() == null) {
					authenticated = installedSoftware.getAuthenticated().toString();
					//tempList.add("" + installedSoftware.getAuthenticated());
				} else {
					if (installedSoftwareEff.getAuthenticated() == null) {
						authenticated = null;
						//tempList.add("");
					} else {
						authenticated = installedSoftwareEff.getAuthenticated().toString();
						//tempList.add(new String("" + installedSoftwareEff.getAuthenticated()));
					}
				}
				if (authenticated.equals("0")) {
					authenticated = "N";
				} else {
					authenticated = "Y";
				}
				tempList.add(authenticated);
				
				if (installedSoftwareEff == null || installedSoftwareEff.getOwner() == null) {
					tempList.add(installedSoftware.getSoftwareOwner());
				} else {
					if (installedSoftwareEff.getOwner() == null ) {
						tempList.add("");
					} else {
						tempList.add(new String("" + installedSoftwareEff.getOwner()));
					}
				}
				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}

	/**
	 * @param msHardwareBaseline
	 * @param softwareCategory
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static InstalledSoftware getInstalledSoftwareBySoftwareCategory(
			SoftwareLpar softwareLpar,
			SoftwareCategory softwareCategory) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();

		InstalledSoftware installedSoftware = (InstalledSoftware) session
				.getNamedQuery(
						"getInstalledSoftwareBySoftwareCategory")
				.setEntity("softwareLpar", softwareLpar).setEntity(
						"softwareCategory", softwareCategory).uniqueResult();

		session.close();

		return installedSoftware;
	}

	/**
	 * @param msHardwareBaseline
	 * @param softwareCategory
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	//Change Bravo to use Software View instead of Product Object Start
	/*public static InstalledSoftware getInstalledSoftwareBySoftwareName(
			SoftwareLpar softwareLpar,
			Product software) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();

		InstalledSoftware installedSoftware = (InstalledSoftware) session
				.getNamedQuery(
						"getInstalledSoftwareBySoftwareName")
				.setEntity("softwareLpar", softwareLpar).setEntity(
						"software", software).uniqueResult();

		session.close();

		return installedSoftware;
	}*/
	
	public static InstalledSoftware getInstalledSoftwareBySoftwareName(
			SoftwareLpar softwareLpar,
			Software software) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();

		InstalledSoftware installedSoftware = (InstalledSoftware) session
				.getNamedQuery(
						"getInstalledSoftwareBySoftwareName")
				.setEntity("softwareLpar", softwareLpar).setEntity(
						"software", software).uniqueResult();

		session.close();

		return installedSoftware;
	}
	//Change Bravo to use Software View instead of Product Object End

	/**
	 * @param podName
	 * @param remoteUser
	 * @return
	 * @throws HibernateException
	 * @throws NamingException
	 */
	public static List getPodBaselineReport(String podName, String remoteUser)
			throws HibernateException, NamingException {

		List baseline = null;

		Session session = getHibernateSession();

		baseline = session.getNamedQuery("getMsInstalledSoftwareBaselineByPod")
				.setString("podName", podName).list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			while (j.hasNext()) {
				MsInstalledSoftwareBaseline msInstalledSoftwareBaseline = (MsInstalledSoftwareBaseline) j
						.next();

				Vector tempList = new Vector();

				tempList.add(msInstalledSoftwareBaseline
						.getMsHardwareBaseline().getCustomer().getPod()
						.getPodName());
				tempList.add(msInstalledSoftwareBaseline
						.getMsHardwareBaseline().getCustomer().getIndustry()
						.getIndustryName());
				tempList.add(msInstalledSoftwareBaseline
						.getMsHardwareBaseline().getCustomer().getSector().getSectorName());
				tempList.add(msInstalledSoftwareBaseline
						.getMsHardwareBaseline().getCustomer()
						.getCustomerType().getCustomerTypeName());

				if (msInstalledSoftwareBaseline.getMsHardwareBaseline()
						.getCustomer().getMisldAccountSettings() != null) {
					if (msInstalledSoftwareBaseline.getMsHardwareBaseline()
							.getCustomer().getMisldAccountSettings()
							.getLicenseAgreementType() == null) {
						tempList.add("");
					} else {
						tempList.add(msInstalledSoftwareBaseline
								.getMsHardwareBaseline().getCustomer()
								.getMisldAccountSettings()
								.getLicenseAgreementType()
								.getLicenseAgreementTypeName());
					}
				} else {
					tempList.add("");
				}

				tempList.add(""
						+ msInstalledSoftwareBaseline.getMsHardwareBaseline()
								.getCustomer().getAccountNumber());
				tempList.add(msInstalledSoftwareBaseline
						.getMsHardwareBaseline().getCustomer()
						.getCustomerName());
				tempList.add(msInstalledSoftwareBaseline
						.getMsHardwareBaseline().getNodeName());
				tempList.add(msInstalledSoftwareBaseline
						.getMsHardwareBaseline().getSerialNumber());

				if (msInstalledSoftwareBaseline.getUserCount() == null) {
					tempList.add("");
				} else {
					tempList.add(new String(""
							+ msInstalledSoftwareBaseline.getUserCount()));
				}

				tempList.add(msInstalledSoftwareBaseline.getStatus());
				tempList.add(msInstalledSoftwareBaseline.getSoftware()
						.getSoftwareName());
				tempList.add(msInstalledSoftwareBaseline.getAuthenticated());
				tempList.add(msInstalledSoftwareBaseline.getSoftwareOwner());
				tempList.add(msInstalledSoftwareBaseline.getSoftwareBuyer());

				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getNoOperatingSystemBaseline()
			throws HibernateException, NamingException {

		List serverList = null;

		Session session = getHibernateSession();
		serverList = session.getNamedQuery("getNoOperatingSystemBaseline")
				.list();
		session.close();

		return serverList;
	}

	//Change Bravo to use Software View instead of Product Object Start
	/**
	 * @param msHardwareBaseline
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	/*public static InstalledSoftware getUnknownInstalledSoftware(SoftwareLpar softwareLpar, Product software)
			throws HibernateException, NamingException {

		InstalledSoftware installedSoftware = null;

		Session session = getHibernateSession();
		installedSoftware = (InstalledSoftware)session.getNamedQuery("getUnknowns").setEntity(
				"softwareLpar", softwareLpar).setEntity("software", software).uniqueResult();
		session.close();

		return installedSoftware;
	}*/
	
	public static InstalledSoftware getUnknownInstalledSoftware(SoftwareLpar softwareLpar, Software software)
			throws HibernateException, NamingException {

		InstalledSoftware installedSoftware = null;

		Session session = getHibernateSession();
		installedSoftware = (InstalledSoftware)session.getNamedQuery("getUnknowns").setEntity(
				"softwareLpar", softwareLpar).setEntity("software", software).uniqueResult();
		session.close();

		return installedSoftware;
	}
	//Change Bravo to use Software View instead of Product Object End
	
	public static List getHigherSoftwareVersion(Customer customer, 
			SoftwareLpar softwareLpar, SoftwareCategory softwareCategory, int priority)
		throws HibernateException, NamingException {

		List software = null;
		
		Session session = getHibernateSession();

		software = session.getNamedQuery("getHigherSoftwareVersion").
					setEntity("customer", customer).
					setEntity("softwareLpar", softwareLpar).
					setEntity("softwareCategory", softwareCategory).
					setInteger("priority", priority).
					list();

		session.close();
		
		return software;
	}
}
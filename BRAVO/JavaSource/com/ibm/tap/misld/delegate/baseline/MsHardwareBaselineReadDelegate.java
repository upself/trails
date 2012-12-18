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
import com.ibm.ea.sigbank.SoftwareLpar;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.baseline.MsHardwareBaseline;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MsHardwareBaselineReadDelegate extends Delegate {

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List<InstalledSoftware> getMsHardwareBaseline(Customer customer)
			throws HibernateException, NamingException {

		List<InstalledSoftware> hardwareBaselineList = null;

		Session session = getHibernateSession();
		
		hardwareBaselineList = session.getNamedQuery(
				"getMsInstalledSoftwareBaselineOS").setEntity("customer",
				customer).list();
		session.close();

		return hardwareBaselineList;
	}

	/**
	 * @param msHardwareBaselineId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static SoftwareLpar getSoftwareLpar(
			int id) throws HibernateException,
			NamingException {

		SoftwareLpar softwareLpar = null;

		Session session = getHibernateSession();

		softwareLpar = (SoftwareLpar) session.getNamedQuery(
				"getSoftwareLpar").setInteger("id",
				id).uniqueResult();

		session.close();

		return softwareLpar;
	}

	/**
	 * @param podName
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getBaselineReport(Customer customer, String remoteUser)
			throws HibernateException, NamingException {
		

		List baseline = null;

		Session session = getHibernateSession();

		baseline = session.getNamedQuery("getMsHardwareBaselineByCustomer")
				.setEntity("customer", customer).list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			while (j.hasNext()) {
				MsHardwareBaseline msHardwareBaseline = (MsHardwareBaseline) j
						.next();

				Vector tempList = new Vector();
				tempList.add(new String("" + customer.getAccountNumber()));
				tempList.add(msHardwareBaseline.getNodeName());
				tempList.add(msHardwareBaseline.getSerialNumber());
				tempList.add(msHardwareBaseline.getMachineType());
				tempList.add(msHardwareBaseline.getMachineModel());
				if (msHardwareBaseline.getProcessorCount() == null) {
					tempList.add("");
				} else {
					tempList.add(new String(""
							+ msHardwareBaseline.getProcessorCount()));
				}
				tempList.add(msHardwareBaseline.getNodeOwner());
				tempList.add(msHardwareBaseline.getStatus());
				tempList.add(msHardwareBaseline.getCountry());

				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}

	/**
	 * @param customer
	 * @param nodeName
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static SoftwareLpar getSoftwareLparByNodeName(
			Customer customer, String name) throws HibernateException,
			NamingException {

		SoftwareLpar softwareLpar = null;

		Session session = getHibernateSession();

		softwareLpar = (SoftwareLpar) session.getNamedQuery(
				"getSoftwareLparByNodeName").setEntity("customer",
				customer).setString("name", name).uniqueResult();

		session.close();

		return softwareLpar;
	}

	/**
	 * @param podName
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getPodBaselineReport(String podName, String remoteUser)
			throws HibernateException, NamingException {

		List baseline = null;

		Session session = getHibernateSession();

		baseline = session.getNamedQuery("getMsHardwareBaselineByPod")
				.setString("podName", podName).list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			while (j.hasNext()) {
				MsHardwareBaseline msHardwareBaseline = (MsHardwareBaseline) j
						.next();

				Vector tempList = new Vector();

				tempList.add(msHardwareBaseline.getCustomer().getPod()
						.getPodName());
				tempList.add(msHardwareBaseline.getCustomer().getIndustry()
						.getIndustryName());
				tempList.add(msHardwareBaseline.getCustomer().getIndustry()
						.getSector().getSectorName());
				tempList.add(msHardwareBaseline.getCustomer().getCustomerType()
						.getCustomerTypeName());

				if (msHardwareBaseline.getCustomer().getMisldAccountSettings() != null) {
					if (msHardwareBaseline.getCustomer()
							.getMisldAccountSettings()
							.getLicenseAgreementType() == null) {
						tempList.add("");
					} else {
						tempList.add(msHardwareBaseline.getCustomer()
								.getMisldAccountSettings()
								.getLicenseAgreementType()
								.getLicenseAgreementTypeName());
					}
				} else {
					tempList.add("");
				}

				tempList.add(new String(""
						+ msHardwareBaseline.getCustomer().getAccountNumber()));
				tempList
						.add(msHardwareBaseline.getCustomer().getCustomerName());
				tempList.add(msHardwareBaseline.getNodeName());
				tempList.add(msHardwareBaseline.getSerialNumber());
				tempList.add(msHardwareBaseline.getMachineType());
				tempList.add(msHardwareBaseline.getMachineModel());
				if (msHardwareBaseline.getProcessorCount() == null) {
					tempList.add("");
				} else {
					tempList.add(new String(""
							+ msHardwareBaseline.getProcessorCount()));
				}
				tempList.add(msHardwareBaseline.getNodeOwner());
				tempList.add(msHardwareBaseline.getStatus());
				tempList.add(msHardwareBaseline.getCountry());

				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}

	/**
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getDuplicateHostnameReport(String remoteUser)
			throws HibernateException, NamingException {
		List baseline = null;

		Session session = getHibernateSession();

		baseline = session.getNamedQuery("getDuplicateHostnames").list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			while (j.hasNext()) {

				Vector tempList = new Vector();

				Object[] pair = (Object[]) j.next();
				tempList.add(pair[0]);
				tempList.add(pair[1]);
				tempList.add(pair[2]);
				tempList.add(pair[3]);
				tempList.add("" + pair[4]);
				tempList.add(pair[5]);
				tempList.add(pair[6]);
				tempList.add(pair[7]);
				tempList.add(pair[8]);
				tempList.add(pair[9]);
				tempList.add(pair[10]);
				tempList.add(pair[11]);

				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}

	/**
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getDuplicatePrefixReport(String remoteUser)
			throws HibernateException, NamingException {
		List baseline = null;

		Session session = getHibernateSession();

		baseline = session.getNamedQuery("getDuplicatePrefixes").list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			while (j.hasNext()) {

				Vector tempList = new Vector();

				Object[] pair = (Object[]) j.next();
				tempList.add(pair[0]);
				tempList.add(pair[1]);
				tempList.add(pair[2]);
				tempList.add(pair[3]);
				tempList.add("" + pair[4]);
				tempList.add(pair[5]);
				tempList.add(pair[6]);
				tempList.add(pair[7]);
				tempList.add(pair[8]);
				tempList.add(pair[9]);
				tempList.add(pair[10]);
				tempList.add(pair[11]);

				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}

	/**
	 * @param customer
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getScanReport(Customer customer)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		List baseline = session
				.getNamedQuery("getMsHardwareBaselineByCustomer").setEntity(
						"customer", customer).list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			while (j.hasNext()) {
				MsHardwareBaseline msHardwareBaseline = (MsHardwareBaseline) j
						.next();

				Vector tempList = new Vector();
				tempList.add(customer.getPod().getPodName());
				tempList.add(customer.getCustomerName());
				tempList.add(customer.getCustomerType().getCustomerTypeName());
				tempList.add(msHardwareBaseline.getNodeName());
				tempList.add(msHardwareBaseline.getSerialNumber());
				tempList.add("" + msHardwareBaseline.getScanTime());

				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}

	/**
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getMissingScanCustomers(String remoteUser)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		List baseline = session.getNamedQuery("getMissingScanCustomers").list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();
			Vector tempList = new Vector();

			tempList.add("ASSET DEPARTMENT");
			tempList.add("ACCOUNT NAME");
			tempList.add("ACCOUNT TYPE");
			tempList.add("CUSTOMER AGREEMENT");

			while (j.hasNext()) {
				Customer customer = (Customer) j.next();

				tempList = new Vector();
				tempList.add(customer.getPod().getPodName());
				tempList.add(customer.getCustomerName());
				tempList.add(customer.getCustomerType().getCustomerTypeName());
				tempList.add(customer.getMisldAccountSettings()
						.getLicenseAgreementType()
						.getLicenseAgreementTypeName());

				baselineVector.add(tempList);
			}
		}
		return baselineVector;
	}
}
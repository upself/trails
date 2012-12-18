/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.customerSettings;

import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.jfree.data.category.DefaultCategoryDataset;

import com.ibm.tap.misld.delegate.cndb.PodReadDelegate;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.exceptions.ApplicationException;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.report.RegistrationStatus;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MisldRegistrationReadDelegate extends Delegate {

	public static DefaultCategoryDataset getRegistrationStatus()
			throws HibernateException, ApplicationException, NamingException {

		DefaultCategoryDataset dataset = new DefaultCategoryDataset();

		List registrationStatusList = PodReadDelegate
				.getPodRegistrationStatus();

		Iterator i = registrationStatusList.iterator();
		while (i.hasNext()) {
			RegistrationStatus registrationStatus = (RegistrationStatus) i
					.next();
			dataset.addValue(registrationStatus.getCount(), registrationStatus
					.getStatus(), registrationStatus.getPodName());
		}

		return dataset;

	}

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getUnlockedAccountReport() throws HibernateException,
			NamingException {

		List baseline = null;

		Session session = getHibernateSession();

		baseline = session.getNamedQuery("getUnlockedReport").list();

		session.close();

		Vector baselineVector = new Vector();

		if (baseline != null) {
			Iterator j = baseline.iterator();

			Vector tempList = new Vector();

			tempList.add("ASSET DEPARTMENT");
			tempList.add("ACCOUNT NAME");
			tempList.add("ACCOUNT TYPE");
			tempList.add("CUSTOMER AGREEMENT TYPE");

			baselineVector.add(tempList);

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
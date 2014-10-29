/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.customerSettings;

import java.util.Iterator;
import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.jfree.data.category.DefaultCategoryDataset;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.report.RegistrationStatus;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MisldAccountSettingsReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static DefaultCategoryDataset getAccountLockStatus()
			throws HibernateException, NamingException {

		DefaultCategoryDataset dataset = new DefaultCategoryDataset();

		Session session = getHibernateSession();

		List registrationStatusList = session.getNamedQuery(
				"getAccountLockStatus").list();

		Iterator i = registrationStatusList.iterator();
		while (i.hasNext()) {
			RegistrationStatus registrationStatus = (RegistrationStatus) i
					.next();
			dataset.addValue(registrationStatus.getCount(), registrationStatus
					.getStatus(), registrationStatus.getPodName());
		}

		return dataset;
	}

}
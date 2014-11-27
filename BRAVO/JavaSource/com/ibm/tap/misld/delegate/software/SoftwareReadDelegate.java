/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.software;

import java.util.ArrayList;
import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

//Change Bravo to use Software View instead of Product Object Start
//import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End
import com.ibm.tap.misld.framework.Delegate;

/**
 * @author alexmois
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public class SoftwareReadDelegate extends Delegate {

	/**
	 * @param msHardwareBaselineId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getSoftwareNotInCategory(int msHardwareBaselineId)
			throws HibernateException, NamingException {

		List software = null;

		Session session = getHibernateSession();

		software = session.getNamedQuery("softwareNotInCategory").setInteger(
				"msHardwareBaselineId", msHardwareBaselineId).list();

		session.close();

		return software;
	}

	
	//Change Bravo to use Software View instead of Product Object Start
	/**
	 * @param softwareLong
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	/*public static Product getSoftwareByLong(Long softwareLong)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		Product software = (Product) session.get(Product.class, softwareLong);

		session.close();

		return software;
	}*/
	
	public static Software getSoftwareByLong(Long softwareLong)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();

		Software software = (Software) session.get(Software.class, softwareLong);

		session.close();

		return software;
	}
	//Change Bravo to use Software View instead of Product Object End

	/**
	 * @param softwareId
	 * @param i
	 * @param softwareCategory
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getSoftwareByCategoryId(int softwareCategoryId,
			int softwareLparId, int softwareId) throws HibernateException,
			NamingException {

		List software = null;

		Session session = getHibernateSession();

		software = session.getNamedQuery("softwareByCategoryId").setInteger(
				"softwareCategoryId", softwareCategoryId).setInteger(
				"softwareLparId", softwareLparId).setInteger("softwareId",
				softwareId).list();

		session.close();

		return software;
	}

	//Change Bravo to use Software View instead of Product Object Start
	/**
	 * @param softwareName
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	/*public static Product getSoftwareByName(String softwareName)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Product software = null;
		ArrayList<Product> products = (ArrayList<Product>) session.getNamedQuery("swByName")
				.setString("softwareName", softwareName).list();

		if (products.size() > 0)
			software = products.get(0);

		session.close();

		return software;
	}*/
	
	public static Software getSoftwareByName(String softwareName)
			throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Software software = null;
		ArrayList<Software> products = (ArrayList<Software>) session.getNamedQuery("swByName")
				.setString("softwareName", softwareName).list();

		if (products.size() > 0)
			software = products.get(0);

		session.close();

		return software;
	}
	//Change Bravo to use Software View instead of Product Object End

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getUnassignedSoftware() throws HibernateException,
			NamingException {

		List software = null;

		Session session = getHibernateSession();

		software = session.getNamedQuery("getUnassignedSoftware").list();

		session.close();

		return software;
	}

}
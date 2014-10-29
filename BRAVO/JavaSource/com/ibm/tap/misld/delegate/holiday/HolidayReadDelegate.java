/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.holiday;

import java.util.Date;
import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.holiday.Holiday;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class HolidayReadDelegate extends Delegate {

	/**
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static List getHolidays() throws HibernateException, NamingException {
		List holidays = null;

		Session session = getHibernateSession();

		holidays = session.getNamedQuery("getHolidays").list();

		session.close();

		return holidays;
	}

	/**
	 * @param podId
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static boolean isHoliday(Date holiday) throws HibernateException,
			NamingException {

		boolean isHoliday = false;
		
		Session session = getHibernateSession();
		Holiday h = (Holiday) session.getNamedQuery("isHoliday").setDate("holiday",
				holiday).uniqueResult();
		session.close();
		
		if (h != null) {
			isHoliday = true;
		}
		return isHoliday;
	}

}
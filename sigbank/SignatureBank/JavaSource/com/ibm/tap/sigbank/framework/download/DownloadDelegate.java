/*
 * Created on Mar 1", 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.download;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.sigbank.framework.common.Delegate;

/**
 * @@author denglers
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class DownloadDelegate extends Delegate {
	// /**
	// * Logger for this class
	// */
	// private static final Logger logger = Logger
	// .getLogger(DownloadDelegate.class);
	//
	public static List signatureDownload() {
		List list = null;

		try {
			Session session = getHibernateSession();

			list = session.getNamedQuery("signatureDownload").list();
			session.close();

		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public static List filterDownload() {
		List list = null;

		try {
			Session session = getHibernateSession();

			list = session.getNamedQuery("filterDownload").list();
			session.close();

		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}

	public static String join(Object[] array, String delimiter) {
		StringBuffer sb = join(array, delimiter, new StringBuffer());
		return sb.toString();
	}

	public static StringBuffer join(Object[] array, String delimiter,
			StringBuffer sb) {
		for (int i = 0; i < array.length; i++) {
			String s;

			if (array[i] == null) {
				s = "";
			} else {
				s = array[i].toString();
			}

			if (i != 0)
				sb.append(delimiter);
			sb.append(s);
		}

		return sb;
	}


	public static List inactiveSignatureDownload() {
		List list = null;

		try {

			Session session = getHibernateSession();

			list = session.getNamedQuery("inactiveSignatureDownload").list();
			session.close();

		} catch (HibernateException e) {
			e.printStackTrace();
		} catch (NamingException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

		return list;
	}
}
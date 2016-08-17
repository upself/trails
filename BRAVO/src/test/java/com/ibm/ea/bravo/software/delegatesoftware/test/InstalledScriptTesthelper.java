package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.InstalledScript;

public class InstalledScriptTesthelper {

	public static InstalledScript createRecord(Long installedSoftwareId) {
		return null;
	}

	public static void deleteRecord(InstalledScript installedScript) {
		
		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(installedScript);
			session.delete(installedScript);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
=======
import com.ibm.ea.bravo.software.InstalledScript;

public class InstalledScriptTesthelper {

	public static InstalledScript createRecord(Long installedSoftwareId) {
		return null;
	}

	public static void deleteRecord(Long installedScriptId) {
		// TODO Auto-generated method stub
		
	}
}

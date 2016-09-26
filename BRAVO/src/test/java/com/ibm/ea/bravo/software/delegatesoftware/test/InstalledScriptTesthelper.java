package com.ibm.ea.bravo.software.delegatesoftware.test;

import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.software.InstalledScript;
import com.ibm.ea.bravo.software.InstalledSoftware;

public class InstalledScriptTesthelper {

	public static InstalledScript createRecord(InstalledSoftware installedSoftware) {
		
		InstalledScript installedScript = new InstalledScript();
		installedScript.setBankAccount(BankAccountTestHelper.getAnyRecord());
		installedScript.setSoftwareScript(SoftwareScriptTestHelper.getAnyRecord());
		installedScript.setInstalledSoftware(installedSoftware);

		// Transaction(the rollback, mainly) is probably not needed for one save
		// operation
		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.save(installedScript);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
		
		return installedScript;
	}

	public static void delete(InstalledScript installedScript) {
		
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
	}

}

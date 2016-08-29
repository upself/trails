package com.ibm.ea.bravo.software.delegatesoftware.test;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import org.hibernate.Query;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.KbDefinition;
import com.ibm.ea.sigbank.Manufacturer;
import com.ibm.ea.sigbank.Software;
import com.ibm.ea.sigbank.SoftwareCategory;

public class SoftwareTestHelper {

	public static Software create() {

		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			
			KbDefinition kbDefinition = KbDefinitionTestHelper.create();
			System.out.println("kbDefinition.getId(): " + kbDefinition.getId());
	
			Manufacturer manufacturer = ManufacturerTestHelper.create();
			ProductTestHelper.create(kbDefinition.getId(), manufacturer);
			
			SoftwareCategory softwareCategory = SoftwareCategoryTestHelper.create();
			ProductInfoTestHelper.create(kbDefinition.getId(), softwareCategory);
			
			SoftwareItemTestHelper.create(kbDefinition.getId());
			
			refreshMQT(session);
			
			session.close();
			return getByKbId(kbDefinition.getId());
			
		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;

	}
	
	

	private static void refreshMQT(Session session) throws SQLException {
		final Connection connection = session.connection();

		Statement stmt = null;
		try {
			stmt = connection.createStatement();
			stmt.executeUpdate("refresh table eaadmin.software");
		} finally {
			if (stmt != null)
				try {
					stmt.close();
				} catch (SQLException e) {
				}
		}
	}

	public static Software getByKbId(Long KbId) {

		Software software = null;

		try {
			Session session = HibernateDelegate.getSession();

			String hqlSelect = "FROM com.ibm.ea.sigbank.Software where KbId = :KbId";
			Query query = session.createQuery(hqlSelect).setLong("KbId", new Long(KbId));
			software = (Software) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return software;
	}

	public static void delete(Software software) {

		Transaction tx = null;
		Session session = null;
		try {
			session = HibernateDelegate.getSession();
			tx = session.beginTransaction();

			session.refresh(software);
			session.delete(software);

			tx.commit();
		} catch (Exception e) {
			if (tx != null)
				tx.rollback();
			e.printStackTrace();
		} finally {
			session.close();
		}
	}
	
	public static Integer validate() {
		Integer result = null;

		try {
			Session session = HibernateDelegate.getSession();

//			String sqlSelect = "" +
//				"SELECT COUNT(*) FROM EAADMIN.SOFTWARE " +
//				"SELECT COUNT(*) FROM EAADMIN.PRODUCT " +
//				"SELECT COUNT(*) FROM EAADMIN.PRODUCT_INFO " +
//				"SELECT COUNT(*) FROM EAADMIN.SOFTWARE_ITEM " +
//				"SELECT COUNT(*) FROM EAADMIN.KB_DEFINITION " +
//				"SELECT COUNT(*) FROM EAADMIN.SOFTWARE_CATEGORY";
			String sqlSelect = "SELECT COUNT(*) FROM EAADMIN.SOFTWARE";
			Query query = session.createSQLQuery(sqlSelect);
			result = (Integer) query.uniqueResult();

			HibernateDelegate.closeSession(session);
		} catch (Exception e) {
			e.printStackTrace();
		}

		return result;
	}

}

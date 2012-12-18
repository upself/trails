package com.ibm.ea.bravo.contact;

import java.util.List;

import org.apache.log4j.Logger;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.utils.EaUtils;

public abstract class DelegateContact extends HibernateDelegate {

	private static final Logger logger = Logger
			.getLogger(DelegateContact.class);

	public static Integer getSupportCount(String email) throws Exception {

		Integer size = null;

		Session session = getSession();

		Long sizeLong = (Long) session.getNamedQuery("contactSupportCount")
				.setString("email", email).uniqueResult();

		closeSession(session);

		size = new Integer(sizeLong.intValue());
		return size;
	}

	public static Integer getAccountCount(long contactid, long customerid)
			throws Exception {

		Integer size = null;

		Session session = getSession();

		Long sizeLong = (Long) session.getNamedQuery("contactAccountCount")
				.setLong("contactid", contactid).setLong("customerid",
						customerid).uniqueResult();

		closeSession(session);

		size = new Integer(sizeLong.intValue());
		return size;
	}

	public static Integer getLparCount(long contactid, long hwlparid)
			throws Exception {

		Integer size = null;

		Session session = getSession();

		Long sizeLong = (Long) session.getNamedQuery("contactLparCount")
				.setLong("contactid", contactid).setLong("hwlparid", hwlparid)
				.uniqueResult();

		closeSession(session);

		size = new Integer(sizeLong.intValue());
		return size;
	}

	public static Integer getHardwareCount(long contactid, long hardwareId)
			throws Exception {

		Integer size = null;

		Session session = getSession();

		Long sizeLong = (Long) session.getNamedQuery("contactHardwareCount")
				.setLong("contactid", contactid).setLong("hardwareId",
						hardwareId).uniqueResult();

		closeSession(session);

		size = new Integer(sizeLong.intValue());
		return size;
	}

	@SuppressWarnings("unchecked")
    public static List<AccountContact> getAccountContacts(long custId) throws Exception {
		List<AccountContact> list = null;

		Session session = getSession();

		list = session.getNamedQuery("accountContactList").setLong(
				"customerId", custId).list();

		closeSession(session);

		return list;
	}

	public static List<HardwareContact> getHardwareContacts(String hardwareId) throws Exception {
		List<HardwareContact> list = null;

		if (EaUtils.isBlank(hardwareId))
			return list;

		return getHardwareContacts(Long.parseLong(hardwareId));
	}

	@SuppressWarnings("unchecked")
    public static List<HardwareContact> getHardwareContacts(long hardwareId) throws Exception {
		List<HardwareContact> list = null;

		Session session = getSession();

		list = session.getNamedQuery("hardwareContactList").setLong(
				"hardwareId", hardwareId).list();

		closeSession(session);

		return list;
	}

	public static List<LparContact> getLparContacts(String hardwareLparId) throws Exception {
		List<LparContact> list = null;

		if (EaUtils.isBlank(hardwareLparId))
			return list;

		return getLparContacts(Long.parseLong(hardwareLparId));
	}

	@SuppressWarnings("unchecked")
    public static List<LparContact> getLparContacts(long hardwareLparId) throws Exception {
		List<LparContact> list = null;

		Session session = getSession();

		list = session.getNamedQuery("lparContactList").setLong("hwlparid",
				hardwareLparId).list();

		closeSession(session);

		return list;
	}

	public static LparContact getLparContact(long contactId, long hwlparid)
			throws Exception {

		Session session = getSession();

		LparContact lpar = (LparContact) session.getNamedQuery("lparContact")
				.setLong("hwlparid", hwlparid).setLong("contactId", contactId)
				.uniqueResult();

		closeSession(session);

		return lpar;
	}

	public static HardwareContact getHardwareContact(long contactId,
			long hardwareId) throws Exception {

		Session session = getSession();

		HardwareContact hw = (HardwareContact) session.getNamedQuery(
				"hardwareContact").setLong("hardwareId", hardwareId).setLong(
				"contactId", contactId).uniqueResult();

		closeSession(session);

		return hw;
	}

	public static AccountContact getAccountContact(long custId, long contactId)
			throws Exception {

		Session session = getSession();

		AccountContact contact = (AccountContact) session.getNamedQuery(
				"accountContact").setLong("customerId", custId).setLong(
				"contactId", contactId).uniqueResult();

		closeSession(session);

		return contact;
	}

	public static ContactSupport getContact(String email) throws Exception {

		Session session = getSession();

		ContactSupport cont = (ContactSupport) session.getNamedQuery(
				"getContact").setString("email", email).uniqueResult();

		closeSession(session);

		return cont;
	}

	public static void refreshContact(ContactSupport supportcontact)
			throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.saveOrUpdate(supportcontact);
			logger.debug("DelegateContact.refreshContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

	public static void saveContact(ContactSupport supportcontact)
			throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.saveOrUpdate(supportcontact);
			logger.debug("DelegateContact.saveContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

	public static void saveLparContact(LparContact contact) throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.saveOrUpdate(contact);
			logger.debug("DelegateContact.saveLparContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

	public static void saveHardwareContact(HardwareContact contact)
			throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.saveOrUpdate(contact);
			logger.debug("DelegateContact.saveHardwareContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

	public static void deleteLparContact(LparContact contact) throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.delete(contact);
			logger.debug("DelegateContact.deleteLparContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

	public static void deleteHardwareContact(HardwareContact contact)
			throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.delete(contact);
			logger.debug("DelegateContact.deleteHardwareContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

	public static void saveAccountContact(AccountContact contact)
			throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the machineType
			session.saveOrUpdate(contact);
			logger.debug("DelegateContact.saveContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

	public static void deleteAccountContact(AccountContact contact)
			throws Exception {

		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();

			// save or update the DelegateContact
			session.delete(contact);
			logger.debug("DelegateContact.deleteContact");

			tx.commit();
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

	}

}
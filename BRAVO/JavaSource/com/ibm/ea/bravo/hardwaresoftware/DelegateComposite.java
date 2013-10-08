package com.ibm.ea.bravo.hardwaresoftware;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.bravo.software.DelegateSoftware;
import com.ibm.ea.bravo.software.SoftwareLpar;

public abstract class DelegateComposite extends HibernateDelegate {

	private static final Logger logger = Logger
			.getLogger(DelegateComposite.class);

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> search(String search, Account account,
			List<String> hardwareStatus, List<String> status) throws Exception {
		logger.debug("DelegateComposite.search");
		List<SoftwareLpar> list = null;

		Session session = getSession();
		if (search.length() >= 3) {
			list = session
					.createCriteria(HardwareLpar.class)
					.createAlias("softwareLpar", "sl")
					.createAlias("hardware", "h")
					.setFetchMode("softwareLpar", FetchMode.JOIN)
					.setFetchMode("hardware", FetchMode.JOIN)
					.setFetchMode("hardware.machineType", FetchMode.JOIN)
					.add(Restrictions.eq("customer", account.getCustomer()))
					.add(Restrictions.in("h.hardwareStatus", hardwareStatus))
					.add(Restrictions.in("status", status))
					.add(Restrictions
							.disjunction()
							.add(Restrictions.like("sl.name", search,
									MatchMode.ANYWHERE).ignoreCase())
							.add(Restrictions.like("name", search,
									MatchMode.ANYWHERE).ignoreCase())
							.add(Restrictions.like("sl.biosSerial", search,
									MatchMode.ANYWHERE).ignoreCase())
							.add(Restrictions.like("h.serial", search,
									MatchMode.ANYWHERE).ignoreCase())).list();
		} else {
			list = session
					.createCriteria(HardwareLpar.class)
					.createAlias("softwareLpar", "sl")
					.createAlias("hardware", "h")
					.setFetchMode("softwareLpar", FetchMode.JOIN)
					.setFetchMode("hardware", FetchMode.JOIN)
					.setFetchMode("hardware.machineType", FetchMode.JOIN)
					.add(Restrictions.eq("customer", account.getCustomer()))
					.add(Restrictions.in("h.hardwareStatus", hardwareStatus))
					.add(Restrictions.in("status", status))
					.add(Restrictions
							.disjunction()
							.add(Restrictions.eq("sl.name", search)
									.ignoreCase())
							.add(Restrictions.eq("name", search).ignoreCase())
							.add(Restrictions.eq("sl.biosSerial", search)
									.ignoreCase())
							.add(Restrictions.eq("h.serial", search)
									.ignoreCase())).list();
		}

		session.close();
		return list;

	}

	public static Integer searchSoftwareLparNameSize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(HardwareLpar.class)
				.setProjection(Projections.rowCount())
				.createAlias("softwareLpar", "sl")
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.eq("sl.name", search)).uniqueResult();

		session.close();

		return count;
	}

	public static Integer searchSoftwareLparNameFuzzySize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(HardwareLpar.class)
				.setProjection(Projections.rowCount())
				.createAlias("softwareLpar", "sl")
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.like("sl.name", search, MatchMode.START))
				.uniqueResult();

		session.close();

		return count;
	}

	public static Integer searchSoftwareLparSerialSize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(HardwareLpar.class)
				.setProjection(Projections.rowCount())
				.createAlias("softwareLpar", "sl")
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.eq("sl.biosSerial", search)).uniqueResult();

		session.close();

		return count;
	}

	/**
	 * @param search
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<HardwareLpar> searchSoftwareLparName(String search)
			throws Exception {
		logger.debug("DelegateComposite.search");
		List<HardwareLpar> list = null;

		Session session = getSession();

		list = session.createCriteria(HardwareLpar.class)
				.createAlias("softwareLpar", "sl")
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.eq("sl.name", search)).list();

		session.close();

		return list;
	}

	/**
	 * @param search
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<HardwareLpar> searchSoftwareLparNameFuzzy(String search)
			throws Exception {
		logger.debug("DelegateComposite.search");
		List<HardwareLpar> list = null;

		Session session = getSession();

		list = session
				.createCriteria(HardwareLpar.class)
				.createAlias("softwareLpar", "sl")
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.disjunction().add(
						Restrictions.like("sl.name", search, MatchMode.START)))
				.list();

		session.close();

		return list;
	}

	/**
	 * @param search
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<HardwareLpar> searchSoftwareLparSerial(String search)
			throws Exception {
		logger.debug("DelegateComposite.search");
		List<HardwareLpar> list = null;

		Session session = getSession();

		list = session.createCriteria(HardwareLpar.class)
				.createAlias("softwareLpar", "sl")
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.eq("sl.biosSerial", search)).list();

		session.close();

		return list;
	}

	/**
	 * @param search
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<HardwareLpar> searchSoftwareLparSerialFuzzy(String search)
			throws Exception {
		logger.debug("DelegateComposite.search");
		List<HardwareLpar> list = null;

		Session session = getSession();

		list = session
				.createCriteria(HardwareLpar.class)
				.createAlias("softwareLpar", "sl")
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.disjunction().add(
						Restrictions.like("sl.biosSerial", search,
								MatchMode.ANYWHERE))).list();

		session.close();

		return list;
	}

	public static Integer searchHardwareLparNameSize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(HardwareLpar.class)
				.setProjection(Projections.rowCount())
				.createAlias("hardware", "h", CriteriaSpecification.LEFT_JOIN)
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNotNull("softwareLpar"))
				.add(Restrictions.eq("name", search)).uniqueResult();

		session.close();

		return count;
	}

	public static Integer searchHardwareLparSerialSize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(HardwareLpar.class)
				.setProjection(Projections.rowCount())
				.createAlias("hardware", "h", CriteriaSpecification.LEFT_JOIN)
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNotNull("softwareLpar"))
				.add(Restrictions.like("h.serial", search)).uniqueResult();

		session.close();

		return count;
	}

	/**
	 * @param search
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<HardwareLpar> searchHardwareLparName(String search)
			throws Exception {
		logger.debug("DelegateComposite.search");
		List<HardwareLpar> list = null;

		Session session = getSession();

		list = session.createCriteria(HardwareLpar.class)
				.createAlias("hardware", "h", CriteriaSpecification.LEFT_JOIN)
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNotNull("softwareLpar"))
				.add(Restrictions.eq("name", search)).list();

		session.close();

		return list;
	}

	/**
	 * @param search
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<HardwareLpar> searchHardwareLparSerial(String search)
			throws Exception {
		logger.debug("DelegateComposite.search");
		List<HardwareLpar> list = null;

		Session session = getSession();

		list = session.createCriteria(HardwareLpar.class)
				.createAlias("hardware", "h", CriteriaSpecification.LEFT_JOIN)
				.setFetchMode("softwareLpar", FetchMode.JOIN)
				.setFetchMode("hardware", FetchMode.JOIN)
				.setFetchMode("hardware.machineType", FetchMode.JOIN)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNotNull("softwareLpar"))
				.add(Restrictions.eq("h.serial", search)).list();

		session.close();

		return list;
	}

	public static void save(HardwareLpar hardwareLpar,
			HttpServletRequest request) throws Exception {
		logger.debug("DelegateComposite.save");

		Session session = getSession();
		SoftwareLpar softwareLpar = hardwareLpar.getSoftwareLpar();

		if (softwareLpar == null) {

			// determine if there is a matching software lpar
			softwareLpar = DelegateSoftware.getSoftwareLpar(
					hardwareLpar.getName(), hardwareLpar.getCustomer()
							.getAccountNumber().toString(), request);

			// if one exists, create a new composite record
			if (softwareLpar != null) {
				logger.debug("DelegateComposite.save.add");

				try {
					Transaction tx = session.beginTransaction();

					hardwareLpar.setSoftwareLpar(softwareLpar);

					// save or update the hardware
					session.saveOrUpdate(hardwareLpar);

					tx.commit();

				} catch (Exception e) {
					logger.error(e, e);
				}
			}
		}

		closeSession(session);
	}

	public static void save(SoftwareLpar softwareLpar,
			HttpServletRequest request) throws Exception {
		logger.debug("DelegateComposite.save");

		Session session = getSession();
		HardwareLpar hardwareLpar = softwareLpar.getHardwareLpar();

		if (hardwareLpar == null) {

			// determine if there is a matching software lpar
			hardwareLpar = DelegateHardware.getHardwareLpar(
					softwareLpar.getName(), softwareLpar.getCustomer()
							.getAccountNumber().toString(), request);

			// if one exists, create a new composite record
			if (hardwareLpar != null) {
				logger.debug("DelegateComposite.save.add");

				try {
					Transaction tx = session.beginTransaction();

					softwareLpar.setHardwareLpar(hardwareLpar);

					// save or update the hardware
					session.saveOrUpdate(softwareLpar);

					tx.commit();

				} catch (Exception e) {
					logger.error(e, e);
				}
			}
		}

		closeSession(session);
	}

	// This gets active software lpars with composite and without
	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> getSoftwareLparAllByCustomer(
			Account account) throws HibernateException, Exception {
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session.getNamedQuery("getSoftwareLparAllByCustomer")
				.setEntity("customer", account.getCustomer()).list();

		session.close();
		return list;
	}

	public static Long getCompositeByCustomerSize(Account account,
			List<String> hwStatus) throws HibernateException, Exception {
		Long count = null;

		Session session = getSession();

		count = (Long) session.getNamedQuery("getCompositeByCustomerSize")
				.setEntity("customer", account.getCustomer())
				.setParameterList("hardwareStatus", hwStatus).uniqueResult();

		session.close();
		return count;
	}

	@SuppressWarnings("unchecked")
	public static List<HardwareLpar> getCompositeByCustomer(Account account,
			List<String> hwStatus) throws HibernateException, Exception {
		List<HardwareLpar> list = null;

		Session session = getSession();

		list = session.getNamedQuery("getCompositeByCustomer")
				.setEntity("customer", account.getCustomer())
				.setParameterList("hardwareStatus", hwStatus).list();

		session.close();
		return list;
	}
}
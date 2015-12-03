package com.ibm.ea.bravo.software;

import java.math.BigInteger;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashSet;
import java.util.List;
import java.util.Set;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.SQLQuery;
import org.hibernate.Session;
import org.hibernate.Transaction;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.ibm.ea.bravo.account.Account;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.hardwaresoftware.DelegateComposite;
import com.ibm.ea.bravo.recon.ReconInstalledSoftware;
import com.ibm.ea.bravo.recon.ReconSoftwareLpar;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.sigbank.BankAccount;
import com.ibm.ea.sigbank.BankAccountInclusion;
//Change Bravo to use Software View instead of Product Object Start
import com.ibm.ea.sigbank.Product;
import com.ibm.ea.sigbank.Software;
//Change Bravo to use Software View instead of Product Object End
import com.ibm.ea.utils.EaUtils;

public abstract class DelegateSoftware extends HibernateDelegate {

	private static final Logger logger = Logger
			.getLogger(DelegateSoftware.class);

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> search(String search, Account account,
			List<String> hardwareStatus, List<String> status) throws Exception {
		logger.debug("DelegateSoftware.search search = " + search);
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session.getNamedQuery("softwareLparsSearch")
				.setEntity("customer", account.getCustomer())
				.setString("name", "%" + search.toUpperCase() + "%")
				.setParameterList("hardwareStatus", hardwareStatus)
				.setParameterList("status", status).list();

		closeSession(session);

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> search(String search) throws Exception {
		logger.debug("DelegateSoftware.search search = " + search);
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session.getNamedQuery("softwareLparsSearchAll")
				.setString("name", "%" + search.toUpperCase() + "%").list();

		closeSession(session);

		return list;
	}

	public static SoftwareLpar getSoftwareLpar(String softwareLparId)
			throws Exception {
		logger.debug("SoftwareLpar.getSoftwareLpar(String) = " + softwareLparId);

		if (EaUtils.isBlank(softwareLparId))
			return null;

		return getSoftwareLpar(Long.parseLong(softwareLparId));
	}

	public static SoftwareLpar getSoftwareLpar(long softwareLparId)
			throws Exception {
		logger.debug("SoftwareLpar.getSoftwareLpar(long) = " + softwareLparId);
		SoftwareLpar softwareLpar = null;

		Session session = getSession();

		softwareLpar = (SoftwareLpar) session.getNamedQuery("softwareLparById")
				.setLong("softwareLparId", softwareLparId).uniqueResult();

		closeSession(session);

		return softwareLpar;
	}

	public static SoftwareLpar getSoftwareLparByIdWithHardwareLparData(
			long softwareLparId) throws Exception {
		logger.debug("SoftwareLpar.getSoftwareLparByIdWithHardwareLparData = "
				+ softwareLparId);
		SoftwareLpar softwareLpar = null;

		Session session = getSession();

		softwareLpar = (SoftwareLpar) session
				.getNamedQuery("softwareLparByIdWithHardwareLparData")
				.setLong("softwareLparId", softwareLparId).uniqueResult();

		closeSession(session);

		return softwareLpar;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> getSoftwareLpars(Account account) {
		logger.debug("SoftwareLpar.getSoftwareLpars(Account) = " + account);
		List<SoftwareLpar> list = null;

		try {
			Session session = getSession();

			list = session.getNamedQuery("softwareLparsByAccount")
					.setEntity("customer", account.getCustomer()).list();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	public static SoftwareLpar getSoftwareLpar(String lparName,
			String accountId, HttpServletRequest request)
			throws ExceptionAccountAccess {

		Account account = DelegateAccount.getAccount(accountId, request);

		return getSoftwareLpar(lparName, account);
	}

	public static SoftwareLpar getSoftwareLpar(String lparName, Account account) {
		SoftwareLpar softwareLpar = null;

		if (account == null)
			return softwareLpar;

		try {
			Session session = getSession();

			softwareLpar = (SoftwareLpar) session
					.getNamedQuery("softwareLparByAccountByName")
					.setEntity("customer", account.getCustomer())
					.setString("name", lparName.toUpperCase()).uniqueResult();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return softwareLpar;
	}

	public static List<InstalledSoftware> getInstalledSoftwares(
			String softwareLparId) throws Exception {

		SoftwareLpar softwareLpar = DelegateSoftware
				.getSoftwareLpar(softwareLparId);

		return getInstalledSoftwares(softwareLpar);
	}

	@SuppressWarnings("unchecked")
	public static List<InstalledSoftware> getInstalledSoftwares(
			SoftwareLpar softwareLpar) throws Exception {
		logger.debug("DelegateSoftware.getInstalledSoftwares");
		List<InstalledSoftware> list = null;

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("installedSoftwaresBySoftwareLpar")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	// This is like above but also tests if it is a manual descripancy
	@SuppressWarnings("unchecked")
	public static List<InstalledSoftware> getTypeAndInstalledSoftwares(
			SoftwareLpar softwareLpar) throws Exception {
		logger.debug("DelegateSoftware.getInstalledSoftwares");
		List<InstalledSoftware> list = null;

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("installedSoftwaresBySoftwareLpar")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	public static InstalledSoftware getInstalledSoftware(String id) {
		logger.debug("DelegateSoftware.getInstalledSoftware (String) " + id);
		InstalledSoftware software = null;

		try {
			Session session = getSession();

			software = (InstalledSoftware) session
					.getNamedQuery("installedSoftwaresById")
					.setLong("id", Long.parseLong(id)).uniqueResult();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return software;
	}

	public static Long searchSigBankCount(String search) throws Exception {
		logger.debug("DelegateSoftware.searchSigBankCount search = " + search);
		Long size = null;

		if (EaUtils.isBlank(search))
			return size;

		Session session = getSession();

		size = (Long) session.getNamedQuery("softwaresSearchCount")
				.setString("name", "%" + search.toUpperCase() + "%")
				.setString("manufacturer", "%" + search.toUpperCase() + "%")
				.uniqueResult();

		closeSession(session);

		return size;
	}


	
	public static Software getSoftware(String softwareName) {
		logger.debug("DelegateSoftware.getSoftware");
		Software software = null;
		try {
			Session session = getSession();
			
			ArrayList<Software> products = (ArrayList<Software>) session
					.getNamedQuery("softwareByNameCaseSensitive")
					.setString("name", softwareName).list();
			if (products.size() > 0)
				software = products.get(0);
			else {
				products = (ArrayList<Software>) session
						.getNamedQuery("softwareByName")
						.setString("name", softwareName).list();
				if (products.size() > 0)
					software = products.get(0);
			}
			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return software;
	}
	

	
	@SuppressWarnings("unchecked")
	public static List<Software> searchSoftware(String search) throws Exception {
		logger.debug("DelegateSoftware.searchSigBank search = " + search);
		List<Software> list = null;

		if (EaUtils.isBlank(search))
			return list;

		Session session = getSession();

		list = session.getNamedQuery("softwaresSearch")
				.setString("name", "%" + search.toUpperCase() + "%")
				.setString("manufacturer", "%" + search.toUpperCase() + "%")
				.list();

		closeSession(session);

		logger.debug("About ready to return list of " + list.size());

		return list;
	}
	//Change Bravo to use Software View instead of Product Object End

	public static void saveAccountBankInclusion(String customerId,
			String bankAccountId) throws Exception {
		logger.debug("DelegateSoftware.saveAccountBankInclusion");
		logger.debug("Customer ID: " + customerId);
		logger.debug("Bank Account ID: " + bankAccountId);
		BankAccountInclusion bankAccountInclusion = new BankAccountInclusion();
		bankAccountInclusion.setBankAccountId(new Long(bankAccountId));
		bankAccountInclusion.setCustomerId(new Long(customerId));
		try {
			Session session = getSession();
			Transaction tx = session.beginTransaction();
			session.saveOrUpdate(bankAccountInclusion);
			tx.commit();
			closeSession(session);
		} catch (Exception e) {
			logger.error("Error saving bank account inclusion");
			throw e;
		}

	}

	public static void deleteAccountBankInclusion(String customerId,
			String bankAccountId) {
		logger.debug("DelegateSoftware.deleteAccountBankInclusion");
		logger.debug("Customer ID: " + customerId);
		logger.debug("Bank Account ID: " + bankAccountId);
		try {
			Session session = getSession();
			String hqlDelete = "delete BankAccountInclusion where customerId = :customerId and bankAccountId = :bankAccountId";
			Transaction tx = session.beginTransaction();
			int deletedEntities = session.createQuery(hqlDelete)
					.setLong("customerId", new Long(customerId))
					.setLong("bankAccountId", new Long(bankAccountId))
					.executeUpdate();

			tx.commit();
			closeSession(session);
			logger.debug("deleted bankAccountId " + bankAccountId
					+ " number of deletes: " + deletedEntities);

		} catch (Exception e) {
			logger.error(e, e);
		}
	}

	@SuppressWarnings("unchecked")
	public static List<BankAccount> getCustomerBank(String search)
			throws Exception {
		logger.debug("DelegateSoftware.getCustomerBank customerId = " + search);
		List<BankAccount> list = null;

		if (EaUtils.isBlank(search))
			return list;

		Session session = getSession();

		list = session.getNamedQuery("customerBankAccount")
				.setLong("customerId", new Long(search)).list();

		logger.debug("found " + list.size());

		closeSession(session);

		return list;
	}

	public static List<BankAccountInclusion> getBankInclusion(String search)
			throws Exception {
		logger.debug("DelegateSoftware.getBankInclusion customerId = " + search);
		List<BankAccountInclusion> list = null;

		if (EaUtils.isBlank(search))
			return list;

		Session session = getSession();
		Customer customer = (Customer) session
				.getNamedQuery("customerByAccountId")
				.setLong("accountId", Long.parseLong(search)).uniqueResult();
		Set<BankAccountInclusion> bankInclusionSet = customer
				.getBankInclusions();
		list = new ArrayList<BankAccountInclusion>(bankInclusionSet);

		// list = session.getNamedQuery("BankAccountExceptionByCustomer")
		// .setLong("customerId", new Long(search)).list();

		logger.debug("found " + list.size());

		closeSession(session);

		return list;
	}
	
	public static Software getSigBank(String id) {
		logger.debug("DelegateSoftware.getSigBank(String) id = " + id);
		if (EaUtils.isBlank(id))
			return null;

		return getSigBank(Long.parseLong(id));
	}

	public static Software getSigBank(long id) {
		logger.debug("DelegateSoftware.getSigBank(long) id = " + id);
		Software software = null;

		try {
			Session session = getSession();

			software = (Software) session.getNamedQuery("softwareById")
					.setLong("id", id).uniqueResult();

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}

		return software;
	}
	//Change Bravo to use Software View instead of Product Object End
	 
	
	public static FormSoftware saveSoftwareForm(FormSoftware software,
			HttpServletRequest request) throws Exception {
		logger.debug("DelegateSoftware.save");
		FormSoftware dbSoftware = null;

		try {
			// create the lpar if necessary
			if (software.getSoftwareLpar() == null) {
				Account account = DelegateAccount.getAccount(
						software.getAccountId(), request);

				SoftwareLpar softwareLpar = new SoftwareLpar();
				softwareLpar.setCustomer(account.getCustomer());
				softwareLpar.setName(software.getLparName());
				softwareLpar.setRemoteUser(software.getRemoteUser());
				softwareLpar.setRecordTime(new Date());
				if (!EaUtils.isBlank(software.getProcessorCount())) {
					softwareLpar.setProcessorCount(new Integer(software
							.getProcessorCount()));
				} else {
					softwareLpar.setProcessorCount(new Integer(0));
				}

				Session session = getSession();
				Transaction tx = session.beginTransaction();
				session.saveOrUpdate(softwareLpar);
				tx.commit();
				closeSession(session);

				software.setSoftwareLpar(softwareLpar);

				// save the composite record for this softwareLpar
				DelegateComposite.save(softwareLpar, request);
			}

			InstalledSoftware installedSoftware = new InstalledSoftware();

			installedSoftware.setSoftwareLpar(software.getSoftwareLpar());
			installedSoftware.setSoftware(software.getSoftware());
			installedSoftware.setVersion(software.getVersion());
			installedSoftware.setInvalidCategory(software.getInvalidCategory());
			installedSoftware.setDiscrepancyType(software.getDiscrepancyType());
			installedSoftware.setRemoteUser(software.getRemoteUser());
			installedSoftware.setRecordTime(new Date());
			installedSoftware.setAuthenticated(new Integer(2));
			installedSoftware.setProcessorCount(new Integer(0));
			if (!EaUtils.isBlank(software.getUsers())) {
				installedSoftware.setUsers(new Integer(software.getUsers()));
			} else {
				installedSoftware.setUsers(new Integer(0));
			}

			if (!EaUtils.isBlank(software.getId()))
				installedSoftware.setId(new Long(software.getId()));

			// save or update the hardware
			Session session = getSession();
			Transaction tx = session.beginTransaction();
			session.saveOrUpdate(installedSoftware);
			tx.commit();
			closeSession(session);

			// create a software discrepancy history record
			SoftwareDiscrepancyH history = new SoftwareDiscrepancyH();
			history.setInstalledSoftware(installedSoftware);
			history.setComment(software.getComment());
			history.setRemoteUser(software.getRemoteUser());
			history.setRecordTime(new Date());
			history.setAction(software.getAction() + " "
					+ software.getInvalidCategory() + " "
					+ software.getDiscrepancyType().getName());

			// save or update the hardware
			session = getSession();
			tx = session.beginTransaction();
			session.saveOrUpdate(history);
			tx.commit();
			closeSession(session);

			// pull the saved record from the database
			dbSoftware = new FormSoftware(installedSoftware.getId().toString(),
					installedSoftware.getSoftwareLpar().getId().toString());
			// if (!installedSoftware.getDiscrepancyType().getName().equals(
			// "VALID")) {
			// Donnie: took out above test because the recon engine needs some
			// valid items if they went from INVALID to VALID
			logger.debug("Starting to save recon item");
			ReconInstalledSoftware reconInstalledSoftware = new ReconInstalledSoftware();
			reconInstalledSoftware.setAction(Constants.RECON_INSTALLED_SW);
			reconInstalledSoftware.setInstalledSoftwareId(installedSoftware
					.getId());
			reconInstalledSoftware.setRemoteUser(software.getRemoteUser());
			reconInstalledSoftware.setRecordTime(new Date());
			// Donnie: removed setting customer id via software.getCustomer
			// and going to set it
			// using the installedSoftware softwareLpar object which is
			// guaranteed
			// valid due to the safe softwareLpar routines above
			// reconInstalledSoftware.setCustomerId(software.getCustomer().getCustomerId());
			reconInstalledSoftware.setCustomerId(installedSoftware
					.getSoftwareLpar().getCustomer().getCustomerId());
			session = getSession();
			tx = session.beginTransaction();
			session.saveOrUpdate(reconInstalledSoftware);
			tx.commit();
			closeSession(session);
			logger.debug("Saved recon action item");
		} catch (Exception e) {
			throw e;
		}

		return dbSoftware;
	}

	public static FormSoftware saveUploadSoftwareForm(FormSoftware software,
			HttpServletRequest request, InstalledSoftware installedSoftware)
			throws Exception {
		logger.debug("DelegateSoftware.save");
		FormSoftware dbSoftware = null;

		try {
			// create the lpar if necessary
			if (software.getSoftwareLpar() == null) {
				Account account = DelegateAccount.getAccount(
						software.getAccountId(), request);

				SoftwareLpar softwareLpar = new SoftwareLpar();
				softwareLpar.setCustomer(account.getCustomer());
				softwareLpar.setName(software.getLparName());
				softwareLpar.setStatus(Constants.ACTIVE);
				softwareLpar.setRecordTime(new Date());
				softwareLpar.setRemoteUser(software.getRemoteUser());
				if (!EaUtils.isBlank(software.getProcessorCount()))
					softwareLpar.setProcessorCount(new Integer(software
							.getProcessorCount()));

				Session session = getSession();
				Transaction tx = session.beginTransaction();
				session.saveOrUpdate(softwareLpar);
				tx.commit();
				closeSession(session);

				software.setSoftwareLpar(softwareLpar);

				// save the composite record for this softwareLpar
				DelegateComposite.save(softwareLpar, request);
			} else {
				SoftwareLpar softwareLpar = software.getSoftwareLpar();
				softwareLpar.setStatus(Constants.ACTIVE);
				softwareLpar.setRecordTime(new Date());

				Session session = getSession();
				Transaction tx = session.beginTransaction();
				session.saveOrUpdate(softwareLpar);
				tx.commit();
				closeSession(session);

				software.setSoftwareLpar(softwareLpar);

				// save the composite record for this softwareLpar
				DelegateComposite.save(softwareLpar, request);
			}

			if (installedSoftware == null) {
				installedSoftware = new InstalledSoftware();
			}

			installedSoftware.setSoftwareLpar(software.getSoftwareLpar());
			installedSoftware.setSoftware(software.getSoftware());
			installedSoftware.setVersion(software.getVersion());
			installedSoftware.setInvalidCategory(software.getInvalidCategory());
			installedSoftware.setDiscrepancyType(software.getDiscrepancyType());
			installedSoftware.setRemoteUser(software.getRemoteUser());
			installedSoftware.setStatus(Constants.ACTIVE);
			installedSoftware.setRecordTime(new Date());
			if (!EaUtils.isBlank(software.getUsers()))
				installedSoftware.setUsers(new Integer(software.getUsers()));

			if (!EaUtils.isBlank(software.getId()))
				installedSoftware.setId(new Long(software.getId()));

			// save or update the hardware
			Session session = getSession();
			Transaction tx = session.beginTransaction();
			session.saveOrUpdate(installedSoftware);
			tx.commit();
			closeSession(session);

			// create a software discrepancy history record
			SoftwareDiscrepancyH history = new SoftwareDiscrepancyH();
			history.setInstalledSoftware(installedSoftware);
			history.setComment(software.getComment());
			history.setRecordTime(new Date());
			history.setRemoteUser(software.getRemoteUser());
			history.setAction(software.getAction() + " "
					+ software.getInvalidCategory() + " "
					+ software.getDiscrepancyType().getName());

			// save or update the hardware
			session = getSession();
			tx = session.beginTransaction();
			session.saveOrUpdate(history);
			tx.commit();
			closeSession(session);

			// pull the saved record from the database
			dbSoftware = new FormSoftware(installedSoftware.getId().toString(),
					installedSoftware.getSoftwareLpar().getId().toString());

		} catch (Exception e) {
			throw e;
		}

		return dbSoftware;
	}

	public static void copySoftware(SoftwareLpar software,
			InstalledSoftware source, InstalledSoftware target,
			String remoteUser) throws HibernateException, Exception {
		logger.debug("DelegateSoftware.copySoftware");

		Session session = getSession();
		Transaction tx = session.beginTransaction();

		target.setInvalidCategory(source.getInvalidCategory());
		target.setDiscrepancyType(source.getDiscrepancyType());
		target.setRecordTime(new Date());
		target.setRemoteUser(remoteUser);

		logger.debug("saving target now: "
				+ target.getSoftware().getSoftwareName());
		logger.debug("target id: " + target.getId());
		logger.debug("source id: " + source.getId());

		session.saveOrUpdate(target);

		// create a software discrepancy history record
		SoftwareDiscrepancyH history = new SoftwareDiscrepancyH();
		history.setInstalledSoftware(target);

		String standardMessage = "Copied action from: " + software.getName()
				+ "";
		if (source.getLastDiscrepancy() != null) {
			history.setComment(standardMessage + " ("
					+ source.getLastDiscrepancy().getComment() + ") ");
			history.setAction(source.getLastDiscrepancy().getAction());
		} else {
			history.setComment(standardMessage);
			history.setAction("Update NONE");
		}

		history.setRemoteUser(remoteUser);

		// logger.debug("Action: " + history.getAction());
		// logger.debug("Comment: " + history.getComment());
		// logger.debug("Remote User: " + history.getRemoteUser());
		session.saveOrUpdate(history);

		ReconInstalledSoftware reconInstalledSoftware = new ReconInstalledSoftware();
		reconInstalledSoftware.setAction(Constants.RECON_INSTALLED_SW);
		reconInstalledSoftware.setInstalledSoftwareId(target.getId());
		reconInstalledSoftware.setRemoteUser(remoteUser);
		reconInstalledSoftware.setRecordTime(new Date());
		reconInstalledSoftware.setCustomerId(target.getSoftwareLpar()
				.getCustomer().getCustomerId());
		session.saveOrUpdate(reconInstalledSoftware);

		tx.commit();
		closeSession(session);

	}

	public static InstalledSoftware getInstalledSoftware(String softwareId,
			String lparId) throws Exception {
		InstalledSoftware installedSoftware = null;
 
		//Change Bravo to use Software View instead of Product Object Start
		//Product software = getSigBank(softwareId);
		Software software = getSigBank(softwareId);
		//Change Bravo to use Software View instead of Product Object End
		SoftwareLpar softwareLpar = getSoftwareLpar(lparId);

		if (software != null && softwareLpar != null) {
			Session session = getSession();

			installedSoftware = (InstalledSoftware) session
					.getNamedQuery("installedSoftwareBySoftwareBySoftwareLpar")
					.setEntity("software", software)
					.setEntity("softwareLpar", softwareLpar).uniqueResult();

			closeSession(session);
		}

		return installedSoftware;
	}

	@SuppressWarnings("unchecked")
	public static List<InstalledSignature> getSignatures(
			String installedSoftwareId) {
		List<InstalledSignature> list = new ArrayList<InstalledSignature>();

		InstalledSoftware installedSoftware = DelegateSoftware
				.getInstalledSoftware(installedSoftwareId);
		if (installedSoftware == null)
			return list;

		try {

			Session session = getSession();

			list = session
					.getNamedQuery("installedSignaturesByInstalledSoftware")
					.setEntity("installedSoftware", installedSoftware).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<InstalledFilter> getFilters(String installedSoftwareId) {
		List<InstalledFilter> list = new ArrayList<InstalledFilter>();

		InstalledSoftware installedSoftware = DelegateSoftware
				.getInstalledSoftware(installedSoftwareId);
		if (installedSoftware == null)
			return list;

		try {

			Session session = getSession();

			list = session.getNamedQuery("installedFiltersByInstalledSoftware")
					.setEntity("installedSoftware", installedSoftware).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<InstalledSaProduct> getSoftAudits(
			String installedSoftwareId) {
		List<InstalledSaProduct> list = new ArrayList<InstalledSaProduct>();

		InstalledSoftware installedSoftware = DelegateSoftware
				.getInstalledSoftware(installedSoftwareId);
		if (installedSoftware == null)
			return list;

		try {

			Session session = getSession();

			list = session
					.getNamedQuery("installedSaProductsByInstalledSoftware")
					.setEntity("installedSoftware", installedSoftware).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<InstalledDoranaProduct> getDoranas(
			String installedSoftwareId) {
		List<InstalledDoranaProduct> list = new ArrayList<InstalledDoranaProduct>();

		InstalledSoftware installedSoftware = DelegateSoftware
				.getInstalledSoftware(installedSoftwareId);
		if (installedSoftware == null)
			return list;

		try {

			Session session = getSession();

			list = session
					.getNamedQuery("installedDoranaProductsByInstalledSoftware")
					.setEntity("installedSoftware", installedSoftware).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	public static boolean getManualStatus(String installedSoftwareId) {
		BigInteger count = new BigInteger("0");

		try {

			Session session = getSession();

			SQLQuery query = (SQLQuery) session.getNamedQuery(
					"checkManualRecord").setLong("installedSoftwareId",
					Long.parseLong(installedSoftwareId));
			count = (BigInteger) query.uniqueResult();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		if (count.intValue() == 0) {
			return true;
		} else {
			return false;
		}

	}

	@SuppressWarnings("unchecked")
	public static List<InstalledVmProduct> getVmProducts(
			String installedSoftwareId) {
		List<InstalledVmProduct> list = new ArrayList<InstalledVmProduct>();

		InstalledSoftware installedSoftware = DelegateSoftware
				.getInstalledSoftware(installedSoftwareId);
		if (installedSoftware == null)
			return list;

		try {

			Session session = getSession();

			list = session
					.getNamedQuery("installedVmProductsByInstalledSoftware")
					.setEntity("installedSoftware", installedSoftware).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<InstalledTadz> getTadzProducts(String installedSoftwareId) {
		List<InstalledTadz> tadzlist = new ArrayList<InstalledTadz>();
		List<InstalledTadz> mvlist = new ArrayList<InstalledTadz>();
		List<InstalledTadz> mflist = new ArrayList<InstalledTadz>();

		InstalledSoftware installedSoftware = DelegateSoftware
				.getInstalledSoftware(installedSoftwareId);
		if (installedSoftware == null)
			return tadzlist;

		try {

			Session session = getSession();

			mvlist = session
					.getNamedQuery("installedTadzMvProductsByInstalledSoftware")
					.setEntity("installedSoftware", installedSoftware).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		tadzlist.addAll(mvlist);

		try {

			Session session = getSession();

			mflist = session
					.getNamedQuery("installedTadzMfProductsByInstalledSoftware")
					.setEntity("installedSoftware", installedSoftware).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		tadzlist.addAll(mflist);

		return tadzlist;
	}

	public static SoftwareStatistics getSoftwareStatistics(
			SoftwareLpar softwareLpar) {
		SoftwareStatistics softwareStatistics = new SoftwareStatistics();
		Long count = null;

		if (softwareLpar == null)
			return softwareStatistics;

		try {

			Session session = getSession();

			count = (Long) session
					.getNamedQuery("softwareStatisticsBySoftwareLpar")
					.setEntity("softwareLpar", softwareLpar).uniqueResult();

			softwareStatistics.setInstalledSoftwareCount(new Integer(count
					.intValue()));

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return softwareStatistics;
	}

	public static List<InvalidCategory> getInvalidCategoryList(String changeJustification) {
		List<InvalidCategory> list = new ArrayList<InvalidCategory>();
		logger.debug("DelegateSoftware.getInvalidCategoryList "+changeJustification);

		list.add(new InvalidCategory(""));
		list.add(new InvalidCategory("Blocked in IFAPRD"));
		list.add(new InvalidCategory("Duplicate product - In Use"));
		list.add(new InvalidCategory("Shared DASD (not used in this LPAR)"));
		list.add(new InvalidCategory("Complex discovery"));
		if (changeJustification!= null && changeJustification.equals("TADZ")) {
			list.add(new InvalidCategory("IBM SW GSD Build"));
		}
		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareDiscrepancyH> getCommentHistory(String softwareId) {
		List<SoftwareDiscrepancyH> list = null;

		try {

			long id = Long.parseLong(softwareId);

			Session session = getSession();

			list = session.getNamedQuery("softwareHistoryBySoftwareId")
					.setLong("softwareId", id).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	/**
	 * @param request
	 * @param softwareLparEff
	 * @return
	 * @throws Exception
	 */
	public static void saveSoftwareLparEffForm(
			FormSoftwareLparEff softwareLparEffForm, HttpServletRequest request)
			throws Exception {
		logger.debug("DelegateSoftware.saveSoftwareLparEffForm");

		Set<SoftwareLparEffH> set = new HashSet<SoftwareLparEffH>();

		SoftwareLpar softwareLpar = DelegateSoftware
				.getSoftwareLparWithHistory(softwareLparEffForm.getLparId());

		Session session = getSession();
		Transaction tx = session.beginTransaction();

		SoftwareLparEff softwareLparEff = new SoftwareLparEff();
		softwareLparEff.setProcessorCount(Integer.valueOf(softwareLparEffForm
				.getProcessorCount()));
		softwareLparEff.setRemoteUser(request.getRemoteUser());
		softwareLparEff.setSoftwareLpar(softwareLpar);
		softwareLparEff.setStatus(softwareLparEffForm.getStatus());

		if (!EaUtils.isBlank(softwareLparEffForm.getId())) {
			softwareLparEff.setId(new Long(softwareLparEffForm.getId()));
		}

		if (softwareLparEffForm.getAction().equalsIgnoreCase(
				Constants.CRUD_UPDATE)) {
			set = softwareLpar.getSoftwareLparEff().getSoftwareLparEffHs();
		}

		SoftwareLparEffH softwareLparEffH = new SoftwareLparEffH();
		softwareLparEffH.setAction(softwareLparEffForm.getAction());
		softwareLparEffH.setProcessorCount(Integer.valueOf(softwareLparEffForm
				.getProcessorCount()));
		softwareLparEffH.setRemoteUser(request.getRemoteUser());
		softwareLparEffH.setStatus(softwareLparEffForm.getStatus());
		softwareLparEffH.setSoftwareLparEff(softwareLparEff);

		set.add(softwareLparEffH);
		softwareLparEff.setSoftwareLparEffHs(set);

		// save or update the hardware
		session.saveOrUpdate(softwareLparEff);
		ReconSoftwareLpar reconSoftwareLpar = new ReconSoftwareLpar();
		reconSoftwareLpar.setAction(Constants.RECON_EFF_PROC);
		reconSoftwareLpar.setCustomerId(softwareLpar.getCustomer()
				.getCustomerId());
		reconSoftwareLpar.setSoftwareLparId(softwareLpar.getId());
		reconSoftwareLpar.setRemoteUser(request.getRemoteUser());
		reconSoftwareLpar.setRecordTime(new Date());
		session.saveOrUpdate(reconSoftwareLpar);
		session.flush();

		tx.commit();
		closeSession(session);
	}

	/**
	 * @param lparId
	 * @return
	 * @throws Exception
	 * @throws NumberFormatException
	 */
	public static SoftwareLpar getSoftwareLparWithHistory(String softwareLparId)
			throws Exception {
		logger.debug("SoftwareLpar.getSoftwareLparWithHistory(String) = "
				+ softwareLparId);

		if (EaUtils.isBlank(softwareLparId))
			return null;

		return getSoftwareLparWithHistory(Long.parseLong(softwareLparId));
	}

	/**
	 * @param l
	 * @return
	 * @throws Exception
	 * @throws HibernateException
	 */
	private static SoftwareLpar getSoftwareLparWithHistory(long softwareLparId)
			throws Exception {
		logger.debug("SoftwareLpar.getSoftwareLparWithHistory(long) = "
				+ softwareLparId);
		SoftwareLpar softwareLpar = null;

		Session session = getSession();

		softwareLpar = (SoftwareLpar) session
				.getNamedQuery("softwareLparWithHistoryById")
				.setLong("softwareLparId", softwareLparId).uniqueResult();

		closeSession(session);

		return softwareLpar;
	}

	/**
	 * @param softwareLpar
	 * @return
	 */
	@SuppressWarnings("unchecked")
	public static List<BankAccount> getSoftwareBankAccounts(
			SoftwareLpar softwareLpar) {
		List<BankAccount> list = new ArrayList<BankAccount>();

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("lparBankAccounts")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	public static Integer searchLparNameNoCompositeSize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(SoftwareLpar.class)
				.setProjection(Projections.rowCount())
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNull("hardwareLpar"))
				.add(Restrictions.eq("name", search)).uniqueResult();

		session.close();

		return count;
	}

	public static Integer searchLparNameFuzzyNoCompositeSize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(SoftwareLpar.class)
				.setProjection(Projections.rowCount())
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNull("hardwareLpar"))
				.add(Restrictions.like("name", search, MatchMode.START))
				.uniqueResult();

		session.close();

		return count;
	}

	public static Integer searchLparSerialNoCompositeSize(String search)
			throws HibernateException, Exception {
		Integer count = null;

		Session session = getSession();

		count = (Integer) session.createCriteria(SoftwareLpar.class)
				.setProjection(Projections.rowCount())
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNull("hardwareLpar"))
				.add(Restrictions.eq("biosSerial", search)).uniqueResult();

		session.close();

		return count;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> searchLparNameNoComposite(String search)
			throws HibernateException, Exception {
		logger.debug("DelegateComposite.search");
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session.createCriteria(SoftwareLpar.class)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNull("hardwareLpar"))
				.add(Restrictions.eq("name", search)).list();

		session.close();

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> searchLparNameFuzzyNoComposite(
			String search) throws HibernateException, Exception {
		logger.debug("DelegateComposite.search");
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session
				.createCriteria(SoftwareLpar.class)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNull("hardwareLpar"))
				.add(Restrictions.disjunction().add(
						Restrictions.like("name", search, MatchMode.START)))
				.list();

		session.close();

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> searchLparSerialNoComposite(String search)
			throws HibernateException, Exception {
		logger.debug("DelegateComposite.search");
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session.createCriteria(SoftwareLpar.class)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNull("hardwareLpar"))
				.add(Restrictions.eq("biosSerial", search)).list();

		session.close();

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> searchLparSerialFuzzyNoComposite(
			String search) throws HibernateException, Exception {
		logger.debug("DelegateComposite.search");
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session
				.createCriteria(SoftwareLpar.class)
				.setFetchMode("customer", FetchMode.JOIN)
				.add(Restrictions.isNull("hardwareLpar"))
				.add(Restrictions.disjunction().add(
						Restrictions.like("biosSerial", search,
								MatchMode.ANYWHERE))).list();

		session.close();

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> searchLparNoComposite(String search,
			Account account, List<String> status) throws HibernateException,
			Exception {
		List<SoftwareLpar> list = null;

		Session session = getSession();
		if (search.length() >= 3) {
			list = session
					.createCriteria(SoftwareLpar.class)
					.add(Restrictions.isNull("hardwareLpar"))
					.add(Restrictions.eq("customer", account.getCustomer()))
					.add(Restrictions.in("status", status))
					.add(Restrictions
							.disjunction()
							.add(Restrictions.like("name", search,
									MatchMode.ANYWHERE).ignoreCase())
							.add(Restrictions.like("biosSerial", search,
									MatchMode.ANYWHERE).ignoreCase())).list();
		} else {
			list = session
					.createCriteria(SoftwareLpar.class)
					.add(Restrictions.isNull("hardwareLpar"))
					.add(Restrictions.eq("customer", account.getCustomer()))
					.add(Restrictions.in("status", status))
					.add(Restrictions
							.disjunction()
							.add(Restrictions.eq("name", search).ignoreCase())
							.add(Restrictions.eq("biosSerial", search)
									.ignoreCase())).list();
		}
		session.close();

		return list;
	}

	public static Long getLparNoCompositeByCustomerByStatusSize(
			Account account, List<String> status) throws HibernateException,
			Exception {
		Long count = null;

		Session session = getSession();

		count = (Long) session.getNamedQuery("getLparNoCompByCustByStatusSize")
				.setEntity("customer", account.getCustomer())
				.setParameterList("status", status).uniqueResult();

		closeSession(session);

		return count;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLpar> getLparNoCompositeByCustomerByStatus(
			Account account, List<String> status) throws HibernateException,
			Exception {
		List<SoftwareLpar> list = null;

		Session session = getSession();

		list = session.getNamedQuery("getLparNoCompByCustByStatus")
				.setEntity("customer", account.getCustomer())
				.setParameterList("status", status).list();

		closeSession(session);

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLparIPAddress> getSoftwareLparIPAddress(
			SoftwareLpar softwareLpar) {
		List<SoftwareLparIPAddress> list = new ArrayList<SoftwareLparIPAddress>();

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("getSoftwareLparIPAddress")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLparHDisk> getSoftwareLparHDisk(
			SoftwareLpar softwareLpar) {
		List<SoftwareLparHDisk> list = new ArrayList<SoftwareLparHDisk>();

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("getSoftwareLparHDisk")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLparMemMod> getSoftwareLparMemMod(
			SoftwareLpar softwareLpar) {
		List<SoftwareLparMemMod> list = new ArrayList<SoftwareLparMemMod>();

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("getSoftwareLparMemMod")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLparADC> getSoftwareLparADC(
			SoftwareLpar softwareLpar) {
		List<SoftwareLparADC> list = new ArrayList<SoftwareLparADC>();

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("getSoftwareLparADC")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	@SuppressWarnings("unchecked")
	public static List<SoftwareLparProcessor> getSoftwareLparProcessor(
			SoftwareLpar softwareLpar) {
		List<SoftwareLparProcessor> list = new ArrayList<SoftwareLparProcessor>();

		if (softwareLpar == null)
			return list;

		try {
			Session session = getSession();

			list = session.getNamedQuery("getSoftwareLparProcessor")
					.setEntity("softwareLpar", softwareLpar).list();

			closeSession(session);

		} catch (Exception e) {
			logger.error(e, e);
		}

		return list;
	}

	public static void saveManualQueue(ManualQueue queue) throws Exception {

		logger.debug("DelegateSoftware.saveManualQueue");

		Session session = getSession();
		Transaction tx = session.beginTransaction();

		try {
			// save or update the manual queue
			session.saveOrUpdate(queue);
			tx.commit();
			closeSession(session);
		} catch (Exception e) {
			logger.error("Error inserting into manual_queue table", e);
			tx.rollback();
			closeSession(session);
			throw e;
		}
	}

	public static Integer checkManualQueue(Long softwareLparId, Long softwareId) {
		Integer exists = new Integer(0);

		try {
			Session session = getSession();

			SQLQuery query = (SQLQuery) session
					.getNamedQuery("checkManualQueue");
			query.setLong("softwareLparId", softwareLparId);
			query.setLong("softwareId", softwareId);

			exists = (Integer) query.uniqueResult();
			if (exists == null) {
				exists = new Integer(0);
			}
			logger.debug("Exists: " + exists);

			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}
		return exists;

	}

	public static ManualQueue getManualQueue(Long softwareLparId,
			Long softwareId) {
		ManualQueue maualQueue = null;

		try {
			Session session = getSession();
			maualQueue = (ManualQueue) session
					.createCriteria(ManualQueue.class)
					.add(Restrictions.eq("softwareLparId", softwareLparId))
					.add(Restrictions.eq("softwareId", softwareId))
					.uniqueResult();
			closeSession(session);
		} catch (Exception e) {
			logger.error(e, e);
		}
		return maualQueue;

	}

}
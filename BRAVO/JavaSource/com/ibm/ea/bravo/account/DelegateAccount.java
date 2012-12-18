package com.ibm.ea.bravo.account;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.net.URL;
import java.net.URLConnection;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.apache.log4j.Logger;
import org.hibernate.FetchMode;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.criterion.MatchMode;
import org.hibernate.criterion.Projections;
import org.hibernate.criterion.Restrictions;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.bravo.secure.Bluegroup;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.utils.EaUtils;

public abstract class DelegateAccount extends HibernateDelegate {
	/**
	 * Logger for this class
	 */
	private static final Logger logger = Logger
			.getLogger(DelegateAccount.class);

	public static Integer searchSize(String search) throws Exception {
		logger.debug("DelegateAccount.searchSize");
		Integer size = null;

		Session session = getSession();

		size = (Integer) session.createCriteria(Customer.class).createAlias(
				"pod", "p").add(
				Restrictions.disjunction().add(
						Restrictions.like("customerName", search,
								MatchMode.ANYWHERE).ignoreCase()).add(
						Restrictions.like("accountNumberStr", search,
								MatchMode.ANYWHERE).ignoreCase()).add(
						Restrictions.like("p.podName", search,
								MatchMode.ANYWHERE).ignoreCase()))
				.setProjection(Projections.rowCount()).uniqueResult();

		closeSession(session);

		return size;
	}

	@SuppressWarnings("unchecked")
    public static List<Account> search(String search) throws Exception {
		logger.debug("DelegateAccount.search " + search);
		List<Account> list = null;

		Session session = getSession();

		list = session.createCriteria(Customer.class).setFetchMode(
				"customerType", FetchMode.JOIN).setFetchMode("pod",
				FetchMode.JOIN).setFetchMode("bluegroups", FetchMode.JOIN)
				.createAlias("pod", "p").add(
						Restrictions.disjunction().add(
								Restrictions.like("customerName", search,
										MatchMode.ANYWHERE)).add(
								Restrictions.like("accountNumberStr", search,
										MatchMode.ANYWHERE)).add(
								Restrictions.like("p.podName", search,
										MatchMode.ANYWHERE))).list();

		closeSession(session);

		return list;
	}

	public static Account getAccount(String accountId,
			HttpServletRequest request) throws ExceptionAccountAccess {
		Account account = null;
		if (EaUtils.isBlank(accountId))
			return account;

		try {
			// go get the customer
			Customer customer = getCustomer(accountId);

			// initialize account
			if (customer != null) {
				account = new Account();
				account.setCustomer(customer);
			}
		} catch (Exception e) {
			logger.error(e, e);
		}

		if (account == null) {
			return account;
		}

		if (!account.getCustomer().isRestricted()) {
			return account;
		}

		if ((request.isUserInRole(Constants.ASSET_ADMIN_GROUP))
				|| (request.isUserInRole(Constants.EA_ADMIN_GROUP))
				|| (request.isUserInRole(Constants.TOOL_ADMIN_GROUP))
				|| (request.isUserInRole(Constants.TAP_ADMIN_GROUP))) {
			return account;
		}

		Iterator<Bluegroup> i = account.getCustomer().getBluegroups().iterator();

		while (i.hasNext()) {
			Bluegroup bluegroup = (Bluegroup) i.next();

			if (request.isUserInRole(bluegroup.getName())) {
				return account;
			}
		}

		throw new ExceptionAccountAccess();
	}

	private static Customer getCustomer(String accountId) throws Exception {
		Customer customer = null;

		Session session = getSession();
		customer = (Customer) session.getNamedQuery("customerByAccountId")
				.setLong("accountId", Long.parseLong(accountId)).uniqueResult();

		closeSession(session);

		return customer;
	}

	public static boolean isAPMMAccount(String customerName) throws Exception {
		if (customerName != null) {
			String[] apmmAccounts = Constants.APMM_ACCOUNT_LIST.split(",");
			if (apmmAccounts != null && apmmAccounts.length > 0) {
				for (int i = 0; i < apmmAccounts.length; i++) {
				     if(customerName.matches("(?i).*"+apmmAccounts[i]+".*")){
				    	 return true;
				     }
				}
			}
		}
		return false;
	}

	public static AccountStatistics getStatistics(Account account)
			throws HibernateException, Exception {
		AccountStatistics accountStatistics = new AccountStatistics();
		Object[] counts;
		Long count;

		if (account == null)
			return accountStatistics;

		Session session = getSession();

		// get the hardware statistics
		count = (Long) session.getNamedQuery(
				"accountStatisticsHardwareByCustomerId").setLong("customerId",
				account.getCustomer().getCustomerId().longValue())
				.uniqueResult();

		accountStatistics.setHardwareLpars(new Integer(count.intValue()));

		// get the software statistics
		counts = (Object[]) session.getNamedQuery(
				"accountStatisticsSoftwareByCustomerId").setLong("customerId",
				account.getCustomer().getCustomerId().longValue())
				.uniqueResult();

		accountStatistics.setSoftwareDiscrepancies((Integer) counts[0]);
		accountStatistics.setSoftwares((Integer) counts[1]);

		// Get the hardware total with a scan
		count = (Long) session.getNamedQuery(
				"hardwareLparsWithCompositeByCustomerId").setEntity(
				"customerId", account.getCustomer()).uniqueResult();

		accountStatistics
				.setHardwareLparsWithScan(new Integer(count.intValue()));
		accountStatistics.setHardwareLparsWithoutScan(new Integer(
				accountStatistics.getHardwareLpars().intValue()
						- accountStatistics.getHardwareLparsWithScan()
								.intValue()));
		if (accountStatistics.getHardwareLpars().intValue() == 0
				|| accountStatistics.getHardwareLparsWithScan().intValue() == 0) {
			accountStatistics.setHardwareLparWithScanPercentage(new Integer(0));
		} else {
			accountStatistics
					.setHardwareLparWithScanPercentage(new Integer(
							(accountStatistics.getHardwareLparsWithScan()
									.intValue() * 100 / accountStatistics
									.getHardwareLpars().intValue())));
		}

		// Get the hardware total with a scan
		count = (Long) session.getNamedQuery(
				"softwareLparsWithNoCompositeByCustomerId").setEntity(
				"customer", account.getCustomer()).uniqueResult();

		accountStatistics.setSoftwareLparsWithoutHardwareLpar(new Integer(count
				.intValue()));

		closeSession(session);

		return accountStatistics;
	}

	public static boolean getMultiReport(Account account) {
		// String filename = Constants.REPORT_DIR + "/MULTI."
		// + account.getCustomer().getAccountNumber() + ".zip";
		String urlString = "http://tap.raleigh.ibm.com/sam/report/MULTI."
				+ account.getCustomer().getAccountNumber() + ".zip";
		URL url;
		int response = 0;
		try {
			url = new URL(urlString);
			URLConnection connection = url.openConnection();
			if (connection instanceof HttpURLConnection) {
				HttpURLConnection httpConnection = (HttpURLConnection) connection;
				httpConnection.connect();
				response = httpConnection.getResponseCode();
			}
		} catch (IOException e) {
			return false;
		}

		if (response == 200) {
			return true;
		}

		return false;
	}

}
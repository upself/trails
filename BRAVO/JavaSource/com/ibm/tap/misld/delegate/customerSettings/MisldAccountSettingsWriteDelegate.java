/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.customerSettings;

import java.sql.SQLException;
import java.util.Date;
import java.util.Vector;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.misld.delegate.cndb.LpidReadDelegate;
import com.ibm.tap.misld.delegate.consent.ConsentLetterWriteDelegate;
import com.ibm.tap.misld.delegate.licenseAgreementType.LicenseAgreementTypeReadDelegate;
import com.ibm.tap.misld.delegate.qualifiedDiscount.QualifiedDiscountReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.customerSettings.CustomerAgreement;
import com.ibm.tap.misld.om.customerSettings.CustomerAgreementType;
import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class MisldAccountSettingsWriteDelegate extends Delegate {

	/**
	 * @param misldAccountSettings
	 * @param customer
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveMisldAccountSettings(
			MisldAccountSettings misldAccountSettings, Customer customer,
			String remoteUser) throws HibernateException, NamingException {

		boolean select = false;
		boolean enterprise = false;

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		clearForms(customer);

		if (customer.getMisldAccountSettings() != null) {
			misldAccountSettings.setMisldAccountSettingsId(customer
					.getMisldAccountSettings().getMisldAccountSettingsId());
		}

		if (misldAccountSettings.getMicrosoftSoftwareOwner().equals("IBM")) {
			misldAccountSettings = computeLicenseAgreement(
					misldAccountSettings, customer, session, remoteUser);
		} else {

			for (int i = 0; i < misldAccountSettings
					.getCustomerAgreementLongs().length; i++) {

				CustomerAgreementType customerAgreementType = CustomerAgreementTypeReadDelegate
						.getCustomerAgreementTypeByLong(misldAccountSettings
								.getCustomerAgreementLongs()[i]);

				CustomerAgreement customerAgreement = new CustomerAgreement();
				customerAgreement
						.setCustomerAgreementType(customerAgreementType);
				customerAgreement.setCustomer(customer);
				customerAgreement.setRecordTime(new Date());
				customerAgreement.setRemoteUser(remoteUser);
				customerAgreement.setStatus(Constants.ACTIVE);

				session.save(customerAgreement);

				if (!misldAccountSettings.getMicrosoftSoftwareOwner().equals(
						Constants.IBM)) {

					if (customerAgreementType.getCustomerAgreementType()
							.equals(Constants.SELECT)) {

						ConsentLetterWriteDelegate.addConsentLetter(
								Constants.SELECT_HOSTING, customer, session,
								remoteUser);

						select = true;
					}
					if (customerAgreementType.getCustomerAgreementType()
							.equals(Constants.ENTERPRISE)) {

						ConsentLetterWriteDelegate.addConsentLetter(
								Constants.ENTERPRISE_HOSTING, customer,
								session, remoteUser);

						enterprise = true;
					}
					if (customerAgreementType.getCustomerAgreementType()
							.equals(Constants.PRELOAD)) {

						ConsentLetterWriteDelegate.addConsentLetter(
								Constants.PRO_FORMA, customer, session,
								remoteUser);
					}
				}
			}

			if (!misldAccountSettings.getMicrosoftSoftwareBuyer().equals(
					Constants.CUSTOMER)) {

				if (select) {

					ConsentLetterWriteDelegate.addConsentLetter(
							Constants.SELECT_OUTSOURCER, customer, session,
							remoteUser);
				}
				if (enterprise) {

					ConsentLetterWriteDelegate.addConsentLetter(
							Constants.ENTERPRISE_OUTSOURCER, customer, session,
							remoteUser);
				}
			}

			if (misldAccountSettings.getMicrosoftSoftwareOwner().equals(
					Constants.CUSTOMER)) {

				misldAccountSettings.setLicenseAgreementType(null);
			}
			if (misldAccountSettings.getMicrosoftSoftwareOwner().equals(
					Constants.BOTH)) {

				misldAccountSettings = computeLicenseAgreement(
						misldAccountSettings, customer, session, remoteUser);
			}
		}

		misldAccountSettings.setQualifiedDiscount(QualifiedDiscountReadDelegate
				.getQualifiedDiscountByLong(misldAccountSettings
						.getQualifiedDiscountLong()));

		misldAccountSettings.setDefaultLpid(LpidReadDelegate
				.getLpidByLong(misldAccountSettings.getDefaultLpidLong()));

		misldAccountSettings.setStatus(Constants.COMPLETE);
		if ((misldAccountSettings.getPriceReportStatus() == null) ||
			(misldAccountSettings.getPriceReportStatus().trim().equals("")))
		{
			misldAccountSettings.setPriceReportStatus(Constants.REGISTERED);
			misldAccountSettings.setPriceReportStatusUser(remoteUser);
			misldAccountSettings.setPriceReportTimestamp(new Date());
		}
		misldAccountSettings.setCustomer(customer);
		misldAccountSettings.setRemoteUser(remoteUser);
		misldAccountSettings.setRecordTime(new Date());	
		session.saveOrUpdate(misldAccountSettings);

		tx.commit();
		session.close();
	}

	/**
	 * @param misldAccountSettings
	 * @param customer
	 * @param session
	 * @param remoteUser
	 * @return
	 * @throws NamingException
	 * @throws HibernateException
	 */
	private static MisldAccountSettings computeLicenseAgreement(
			MisldAccountSettings misldAccountSettings, Customer customer,
			Session session, String remoteUser) throws HibernateException,
			NamingException {

		if (!misldAccountSettings.isReleaseInformation()) {

			misldAccountSettings
					.setLicenseAgreementType(LicenseAgreementTypeReadDelegate
							.getLicenseAgreementTypeByName(Constants.SPLA));
		} else {
			if (misldAccountSettings.isContractEnd()) {

				misldAccountSettings
						.setLicenseAgreementType(LicenseAgreementTypeReadDelegate
								.getLicenseAgreementTypeByName(Constants.SPLA));
			} else {

				misldAccountSettings
						.setLicenseAgreementType(LicenseAgreementTypeReadDelegate
								.getLicenseAgreementTypeByName(Constants.ESPLA));

				ConsentLetterWriteDelegate.addConsentLetter(
						Constants.ESPLA_ENROLLMENT_FORM, customer, session,
						remoteUser);
			}
		}

		return misldAccountSettings;
	}

	/**
	 * @param customer
	 * @throws HibernateException
	 * @throws NamingException
	 */
	public static void clearForms(Customer customer) throws HibernateException,
			NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		ConsentLetterWriteDelegate.deleteConsentLetters(customer, session);

		CustomerAgreementWriteDelegate.deleteCustomerAgreements(customer,
				session);

		tx.commit();
		session.close();
	}

	/**
	 * @param misldAccountSettings
	 * @param accountSettingsForm
	 * @param string
	 * @param customer
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveFinalMisldAccountSettings(
			MisldAccountSettings misldAccountSettings,
			MisldAccountSettings accountSettingsForm, Customer customer,
			String remoteUser) throws HibernateException, NamingException {

		accountSettingsForm.setMicrosoftSoftwareBuyer(misldAccountSettings
				.getMicrosoftSoftwareBuyer());

		accountSettingsForm.setCustomerAgreementLongs(misldAccountSettings
				.getCustomerAgreementLongs());

		saveMisldAccountSettings(accountSettingsForm, customer, remoteUser);

	}

	/**
	 * @param customer
	 * @param session
	 * @throws HibernateException
	 */
	public static void deleteMisldAccountSettings(Customer customer,
			Session session) throws HibernateException {

		if (customer.getMisldAccountSettings() != null) {
			session.delete(customer.getMisldAccountSettings());
		}

	}

	/**
	 * @param misldAccountSettings
	 * @param customer
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveDraftMisldAccountSettings(
			MisldAccountSettings misldAccountSettings, Customer customer,
			String remoteUser) throws HibernateException, NamingException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		if (customer.getMisldAccountSettings() != null) {
			misldAccountSettings.setMisldAccountSettingsId(customer
					.getMisldAccountSettings().getMisldAccountSettingsId());
		}

		misldAccountSettings.setQualifiedDiscount(QualifiedDiscountReadDelegate
				.getQualifiedDiscountByLong(misldAccountSettings
						.getQualifiedDiscountLong()));

		misldAccountSettings.setDefaultLpid(LpidReadDelegate
				.getLpidByLong(misldAccountSettings.getDefaultLpidLong()));

		misldAccountSettings.setStatus(Constants.DRAFT);
		misldAccountSettings.setCustomer(customer);
		misldAccountSettings.setRemoteUser(remoteUser);
		misldAccountSettings.setRecordTime(new Date());
		session.saveOrUpdate(misldAccountSettings);

		tx.commit();
		session.close();

	}

	/**
	 * @param customers
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 * @throws SQLException
	 *  
	 */
	public static String unlockAccounts(Vector unlockCustomers)
			throws NamingException, HibernateException, SQLException {

		String pod = null;

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();
		
		Vector unlockCustomerIds = new Vector();
		Customer customer = new Customer();

		for (int i = 0; i < unlockCustomers.size(); i++) {
				customer = (Customer)unlockCustomers.get(i);
				unlockCustomerIds.add(customer.getCustomerId());
		}
		if (!unlockCustomers.isEmpty()) {
			session.getNamedQuery("unlockAccountSettings").setParameterList(
					"customers", unlockCustomerIds).executeUpdate();
			session.getNamedQuery("inactivatePriceReportCycle")
					.setParameterList("customers", unlockCustomers)
					.executeUpdate();
			session.getNamedQuery("inactivateNotifications")
			.setParameterList("customers", unlockCustomers)
			.executeUpdate();
		}

		tx.commit();

		session.close();

		return pod;
	}

	/**
	 * @param customers
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 * @throws SQLException
	 *  
	 */
	public static String lockAccounts(Vector lockCustomers)
			throws NamingException, HibernateException, SQLException {

		String pod = null;

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		if (!lockCustomers.isEmpty()) {
			session.getNamedQuery("lockAccountSettings").setParameterList(
					"customers", lockCustomers).executeUpdate();
			session.getNamedQuery("inactivatePriceReportCycle")
					.setParameterList("customers", lockCustomers)
					.executeUpdate();
		}

		tx.commit();

		session.close();

		return pod;
	}
	
	/**
	 * @throws NamingException
	 * @throws HibernateException
	 * @throws SQLException
	 *  
	 */
	public static void unlockAllAccounts() throws NamingException,
			HibernateException, SQLException {

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		session.getNamedQuery("unlockAllAccountSettings").executeUpdate();

		tx.commit();
		session.close();
	}
}
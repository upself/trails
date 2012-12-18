/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.consent;

import java.util.Date;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.misld.delegate.priceLevel.PriceLevelReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.consent.ConsentLetter;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ConsentLetterWriteDelegate extends Delegate {

	/**
	 * @param customer
	 * @param session
	 * @throws HibernateException
	 */
	public static void deleteConsentLetters(Customer customer, Session session)
			throws HibernateException {

		session.getNamedQuery("deleteConsentLettersByCustomer").setEntity(
				"customer", customer).executeUpdate();

	}

	/**
	 * @param consentTypeName
	 * @param customer
	 * @param session
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void addConsentLetter(String consentTypeName,
			Customer customer, Session session, String remoteUser)
			throws HibernateException, NamingException {

		ConsentLetter consentLetter = new ConsentLetter();
		consentLetter.setConsentType(ConsentTypeReadDelegate
				.getConsentTypeByName(consentTypeName));
		consentLetter.setPriceLevel(PriceLevelReadDelegate
				.getPriceLevelByName(""));
		consentLetter.setCustomer(customer);
		consentLetter.setRecordTime(new Date());
		consentLetter.setRemoteUser(remoteUser);
		consentLetter.setStatus(Constants.ACTIVE);
		session.save(consentLetter);

	}

	/**
	 * @param consentLetter
	 * @param consentLetterForm
	 * @param customerMisld
	 * @param remoteUser
	 * @throws NamingException
	 * @throws HibernateException
	 */
	public static void saveConsentLetterQuestion(ConsentLetter consentLetter,
			ConsentLetter consentLetterForm, Customer customer,
			String remoteUser) throws HibernateException, NamingException {

		consentLetter.setRespondDate(Util.parseDayString(consentLetterForm
				.getRespondDateStr()));
		consentLetter.setAccountStatus(consentLetterForm.getAccountStatus());
		consentLetter.setAssetStatus(consentLetterForm.getAssetStatus());
		consentLetter
				.setMicrosoftStatus(consentLetterForm.getMicrosoftStatus());
		consentLetter.setEsplaEnrollmentNumber(consentLetterForm
				.getEsplaEnrollmentNumber());

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		consentLetter.setRecordTime(new Date());
		consentLetter.setRemoteUser(remoteUser);
		consentLetter.setStatus(Constants.ACTIVE);
		session.update(consentLetter);

		tx.commit();
		session.close();
	}

}
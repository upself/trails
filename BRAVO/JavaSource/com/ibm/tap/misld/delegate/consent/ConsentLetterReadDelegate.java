/*
 * Created on May 6, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.delegate.consent;

import java.util.List;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.misld.framework.Delegate;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.consent.ConsentLetter;
import com.ibm.tap.misld.om.consent.ConsentType;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class ConsentLetterReadDelegate
        extends Delegate {

    /**
     * @param consentTypeName
     * @throws NamingException
     * @throws HibernateException
     */
    public static ConsentType getConsentTypeByName(String consentTypeName)
            throws HibernateException, NamingException {

        ConsentType consentType = null;

        Session session = getHibernateSession();

        consentType = (ConsentType) session.getNamedQuery(
                "getConsentTypeByName").setString("consentTypeName",
                consentTypeName).uniqueResult();

        session.close();

        return consentType;

    }

    /**
     * @param customerMisld
     * @return
     * @throws NamingException
     * @throws HibernateException
     */
    public static List getConsentLettersByCustomer(Customer customerMisld)
            throws HibernateException, NamingException {

        List consentLetters = null;

        Session session = getHibernateSession();

        consentLetters = session.getNamedQuery("getConsentLettersByCustomer")
                .setEntity("customer", customerMisld).list();

        session.close();

        return consentLetters;
    }

    /**
     * @param consentLetterId
     * @return
     * @throws NamingException
     * @throws HibernateException
     */
    public static ConsentLetter getConsentLetterByLong(long consentLetterId)
            throws HibernateException, NamingException {

        ConsentLetter consentLetter = null;

        Session session = getHibernateSession();

        consentLetter = (ConsentLetter) session.getNamedQuery(
                "getConsentLetterByLong").setLong("consentLetterId",
                consentLetterId).uniqueResult();

        session.close();

        return consentLetter;
    }

    /**
     * @param consentType
     * @param customer
     * @return
     * @throws NamingException
     * @throws HibernateException
     */
    public static ConsentLetter getConsentLetter(ConsentType consentType,
            Customer customer) throws HibernateException, NamingException {

        ConsentLetter consentLetter = null;

        Session session = getHibernateSession();

        consentLetter = (ConsentLetter) session.getNamedQuery(
                "getConsentLetter").setEntity("consentType", consentType)
                .setEntity("customer", customer).uniqueResult();

        session.close();

        return consentLetter;
    }

}
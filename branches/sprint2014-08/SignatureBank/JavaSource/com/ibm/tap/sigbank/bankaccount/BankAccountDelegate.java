/*
 * Created on Mar 29, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.bankaccount;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import javax.naming.NamingException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessage;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Delegate;
import com.ibm.tap.sigbank.framework.common.Util;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public abstract class BankAccountDelegate extends Delegate {

	public static ActionErrors addConnected(BankAccountForm baf,
			String remoteUser) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		ActionErrors errors = new ActionErrors();

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a software signature object
		BankAccount bankAccount = transferAddConnectedBankAccountForm(baf,
				session);

		// We need to check and see if this bank account already exists
		BankAccount ba = null;
		ba = getBankAccountByName(bankAccount.getName(), ba, session);

		if (ba != null) {
			errors.add("bankAccountName", new ActionMessage(
					"errors.software.signature.duplicate"));
			session.close();
			return errors;
		}

		save(bankAccount, remoteUser, session);

		tx.commit();
		session.close();

		return errors;
	}

	private static BankAccount transferAddConnectedBankAccountForm(
			BankAccountForm baf, Session session) {

		BankAccount ba = new BankAccount();

		// Set our required fields
		ba.setName(baf.getName().toUpperCase());
		ba.setDescription(baf.getDescription());
		ba.setType(baf.getType());
		ba.setVersion(baf.getVersion());
		ba.setConnectionType(Constants.CONNECTED);
		ba.setDataType(baf.getDataType());
		ba.setDatabaseType(baf.getDatabaseType());
		ba.setDatabaseVersion(baf.getDatabaseVersion());
		ba.setDatabaseName(baf.getDatabaseName().toUpperCase());
		ba.setDatabaseIp(baf.getDatabaseIp());
		ba.setDatabasePort(baf.getDatabasePort());
		ba.setDatabaseUser(baf.getDatabaseUser());
		ba.setDatabasePassword(baf.getDatabasePassword());
		ba.setSocks(baf.getSocks());
		ba.setTunnel(baf.getTunnel());
		ba.setTunnelPort(baf.getTunnelPort());
		ba.setAuthenticatedData(baf.getAuthenticatedData());
		ba.setSyncSig(baf.getSyncSig());
		ba.setStatus(Constants.ACTIVE);
		ba.setConnectionStatus(Constants.SUCCESS.toUpperCase());

		// Our non required fields
		if (!Util.isBlankString(baf.getDatabaseSchema())) {
			ba.setDatabaseSchema(baf.getDatabaseSchema().toUpperCase());
		}

		return ba;
	}

	private static BankAccount getBankAccountByName(String name,
			BankAccount ba, Session session) {

		ba = (BankAccount) session.getNamedQuery("bankAccountByName")
				.setString("name", name).uniqueResult();

		return ba;
	}

	public static void save(BankAccount ba, String remoteUser, Session session)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		ba.setRecordTime(new Date());
		ba.setRemoteUser(remoteUser);

		// We want to save or update our software
		session.saveOrUpdate(ba);
	}

	public static List getBankAccounts(String connectionType)
			throws HibernateException, NamingException {

		List bankAccounts = null;

		Session session = getHibernateSession();

		bankAccounts = getBankAccounts(connectionType, bankAccounts, session);

		session.close();

		return bankAccounts;
	}

	public static List getBankAccounts(String connectionType, List results,
			Session session) {

		results = session.getNamedQuery("getBankAccounts").setString(
				"connectionType", connectionType).list();

		return results;
	}

	public static BankAccountForm setUpdateForm(String id)
			throws HibernateException, NamingException, IllegalAccessException,
			InvocationTargetException {

		BankAccount ba = getBankAccount(id);

		BankAccountForm baf = new BankAccountForm();

		BeanUtils.copyProperties(baf, ba);

		return baf;
	}

	public static BankAccount getBankAccount(String id)
			throws HibernateException, NamingException {
		BankAccount bankAccount = null;

		Session session = getHibernateSession();

		bankAccount = getBankAccount(id, bankAccount, session);

		session.close();

		return bankAccount;
	}

	public static BankAccount getBankAccount(String id, BankAccount result,
			Session session) {

		result = (BankAccount) session.getNamedQuery("bankAccountById")
				.setLong("id", new Long(id).longValue()).uniqueResult();

		return result;
	}

	public static ActionErrors updateConnectedBankAccount(BankAccountForm baf,
			String remoteUser) throws HibernateException,
			IllegalAccessException, InvocationTargetException, NamingException {
		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a software object
		BankAccount bankAccount = transferUpdateConnectedBankAccountForm(baf,
				session);

		// Now we need to go through the logic of updating a new piece of
		// software
		ActionErrors errors = new ActionErrors();

		// Grab the software from the database using the ID
		BankAccount bankAccountById = null;
		bankAccountById = getBankAccount(bankAccount.getId().toString(),
				bankAccountById, session);

		// Grab the software from the database using the software name
		BankAccount baByName = null;
		baByName = getBankAccountByName(bankAccount.getName(), baByName,
				session);

		// If the software name exists in the database
		if (baByName != null) {
			// If the IDs of the two from the db are not equal
			if (!bankAccountById.getId().equals(baByName.getId())) {

				errors.add("bankAccountName", new ActionMessage(
						"errors.bankaccount.duplicate"));
				session.close();
				return errors;
			}

			session.evict(baByName);
		}

		session.evict(bankAccountById);

		// Save the software
		save(bankAccount, remoteUser, session);
		tx.commit();
		session.close();

		// Return the errors
		return errors;
	}

	private static BankAccount transferUpdateConnectedBankAccountForm(
			BankAccountForm baf, Session session)
			throws IllegalAccessException, InvocationTargetException,
			HibernateException, NamingException {

		BankAccount ba = new BankAccount();

		// Set our required fields
		ba.setId(new Long(baf.getId()));
		ba.setName(baf.getName().toUpperCase());
		ba.setDescription(baf.getDescription());
		ba.setType(baf.getType());
		ba.setVersion(baf.getVersion());
		ba.setConnectionType(Constants.CONNECTED);
		ba.setDataType(baf.getDataType());
		ba.setDatabaseType(baf.getDatabaseType());
		ba.setDatabaseVersion(baf.getDatabaseVersion());
		ba.setDatabaseName(baf.getDatabaseName().toUpperCase());
		ba.setDatabaseIp(baf.getDatabaseIp());
		ba.setDatabasePort(baf.getDatabasePort());
		ba.setDatabaseUser(baf.getDatabaseUser());
		ba.setDatabasePassword(baf.getDatabasePassword());
		ba.setSocks(baf.getSocks());
		ba.setTunnel(baf.getTunnel());
		ba.setTunnelPort(baf.getTunnelPort());
		ba.setAuthenticatedData(baf.getAuthenticatedData());
		ba.setSyncSig(baf.getSyncSig());
		ba.setStatus(baf.getStatus());
		ba.setConnectionStatus(baf.getConnectionStatus());

		// Our non required fields
		if (!Util.isBlankString(baf.getDatabaseSchema())) {
			ba.setDatabaseSchema(baf.getDatabaseSchema().toUpperCase());
		}

		return ba;
	}

	public static ActionErrors addDisconnected(BankAccountForm baf,
			String remoteUser) throws HibernateException, NamingException,
			IllegalAccessException, InvocationTargetException {

		ActionErrors errors = new ActionErrors();

		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a software signature object
		BankAccount bankAccount = transferAddDisconnectedBankAccountForm(baf,
				session);

		// We need to check and see if this bank account already exists
		BankAccount ba = null;
		ba = getBankAccountByName(bankAccount.getName(), ba, session);

		if (ba != null) {
			errors.add("bankAccountName", new ActionMessage(
					"errors.software.signature.duplicate"));
			session.close();
			return errors;
		}

		save(bankAccount, remoteUser, session);

		tx.commit();
		session.close();

		return errors;
	}

	private static BankAccount transferAddDisconnectedBankAccountForm(
			BankAccountForm baf, Session session) {

		BankAccount ba = new BankAccount();

		// Set our required fields
		ba.setName(baf.getName().toUpperCase());
		ba.setDescription(baf.getDescription());
		ba.setType(baf.getType());
		ba.setVersion(baf.getVersion());
		ba.setConnectionType(Constants.DISCONNECTED);
		ba.setDataType(baf.getDataType());
		ba.setAuthenticatedData(baf.getAuthenticatedData());
		ba.setStatus(Constants.ACTIVE);
		ba.setConnectionStatus(Constants.SUCCESS.toUpperCase());

		return ba;
	}

	public static ActionErrors updateDisconnectedBankAccount(
			BankAccountForm baf, String remoteUser) throws HibernateException,
			IllegalAccessException, InvocationTargetException, NamingException {
		Session session = getHibernateSession();
		Transaction tx = session.beginTransaction();

		// Transfer our form to a software object
		BankAccount bankAccount = transferUpdateDisconnectedBankAccountForm(
				baf, session);

		// Now we need to go through the logic of updating a new piece of
		// software
		ActionErrors errors = new ActionErrors();

		// Grab the software from the database using the ID
		BankAccount bankAccountById = null;
		bankAccountById = getBankAccount(bankAccount.getId().toString(),
				bankAccountById, session);

		// Grab the software from the database using the software name
		BankAccount baByName = null;
		baByName = getBankAccountByName(bankAccount.getName(), baByName,
				session);

		// If the software name exists in the database
		if (baByName != null) {
			// If the IDs of the two from the db are not equal
			if (!bankAccountById.getId().equals(baByName.getId())) {

				errors.add("bankAccountName", new ActionMessage(
						"errors.bankaccount.duplicate"));
				session.close();
				return errors;
			}

			session.evict(baByName);
		}

		session.evict(bankAccountById);

		// Save the software
		save(bankAccount, remoteUser, session);
		tx.commit();
		session.close();

		// Return the errors
		return errors;
	}

	private static BankAccount transferUpdateDisconnectedBankAccountForm(
			BankAccountForm baf, Session session)
			throws IllegalAccessException, InvocationTargetException,
			HibernateException, NamingException {

		BankAccount ba = new BankAccount();

		// Set our required fields
		ba.setId(new Long(baf.getId()));
		ba.setName(baf.getName().toUpperCase());
		ba.setDescription(baf.getDescription());
		ba.setType(baf.getType());
		ba.setVersion(baf.getVersion());
		ba.setConnectionType(Constants.DISCONNECTED);
		ba.setDataType(baf.getDataType());
		ba.setAuthenticatedData(baf.getAuthenticatedData());
		ba.setStatus(baf.getStatus());
		ba.setConnectionStatus(Constants.SUCCESS.toUpperCase());

		return ba;
	}
}
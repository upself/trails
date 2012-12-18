package com.ibm.ea.bravo.bankaccount;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.List;

import javax.naming.NamingException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessage;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.BankAccount;
import com.ibm.ea.utils.EaUtils;
import com.ibm.ea.bravo.bankaccount.bankAccountException;

public class DelegateBankAccount extends HibernateDelegate {
	private static final Logger logger = Logger
			.getLogger(DelegateBankAccount.class);

	public static ActionErrors saveBankAccount(FormBankAccount pFormBankAccount,
			String psRemoteUser) throws Exception {
		logger.debug("DelegateBankAccount.saveBankAccount");

		ActionErrors lActionErrors = new ActionErrors();
		Session lSession = getSession();
		Transaction lTransaction = null;
		BankAccount lBankAccount = createBankAccount(pFormBankAccount, false);

		lActionErrors = validateBankAccount(lBankAccount, lSession);

		// Ensure that there is only one BankAccount with the given name
		if (lActionErrors.isEmpty()) {
			lTransaction = lSession.beginTransaction();
			saveBankAccount(lBankAccount, psRemoteUser, lSession);
			lTransaction.commit();
		}
		lSession.close();

		return lActionErrors;
	}

	public static BankAccount selectBankAccountDetails(Long plId)
			throws Exception {
		logger.debug("DelegateBankAccount.selectBankAccountDetails");
		BankAccount lBankAccount = null;
		Session lSession = getSession();

		lBankAccount = (BankAccount) lSession.getNamedQuery(
				"selectBankAccountDetails").setLong("id", plId).uniqueResult();
		closeSession(lSession);

		return lBankAccount;
	}

	public static List<BankAccount> selectConnectedBankAccountList()
			throws Exception {
		logger.debug("DelegateBankAccount.selectConnectedBankAccountList");
		return selectBankAccountList("CONNECTED");
	}

	public static List<BankAccount> selectDisconnectedBankAccountList()
			throws Exception {
		logger.debug("DelegateBankAccount.selectDisconnectedBankAccountList");
		return selectBankAccountList("DISCONNECTED");
	}

	private static BankAccount createBankAccount(
			FormBankAccount pFormBankAccount, boolean pbUpdateConnectionType) {
		BankAccount lBankAccount = new BankAccount();

		// Set the common, required fields
		lBankAccount.setId(pFormBankAccount.getId());
		lBankAccount.setConnectionStatus(Constants.SUCCESS.toUpperCase());
		lBankAccount.setName(pFormBankAccount.getName().toUpperCase());
		lBankAccount.setDescription(pFormBankAccount.getDescription());
		lBankAccount.setType(pFormBankAccount.getType());
		lBankAccount.setVersion(pFormBankAccount.getVersion());
		lBankAccount.setDataType(pFormBankAccount.getDataType());
		lBankAccount.setAuthenticatedData(pFormBankAccount.getAuthenticatedData());
		lBankAccount.setStatus(pFormBankAccount.getStatus());

		if ((pFormBankAccount.getConnectionType().equalsIgnoreCase(
				Constants.CONNECTED) && !pbUpdateConnectionType)
				|| (pFormBankAccount.getConnectionType().equalsIgnoreCase(
						Constants.DISCONNECTED) && pbUpdateConnectionType)) {
			// Set the required fields for a connected BankAccount
			lBankAccount.setDatabaseType(pFormBankAccount.getDatabaseType());
			lBankAccount.setDatabaseVersion(pFormBankAccount.getDatabaseVersion());
			lBankAccount.setDatabaseName(pFormBankAccount.getDatabaseName()
					.toUpperCase());
			lBankAccount.setDatabaseIp(pFormBankAccount.getDatabaseIp());
			lBankAccount.setDatabasePort(pFormBankAccount.getDatabasePort());
			lBankAccount.setDatabaseUser(pFormBankAccount.getDatabaseUser());
			lBankAccount.setDatabasePassword(pFormBankAccount.getDatabasePassword());
			lBankAccount.setSocks(pFormBankAccount.getSocks());
			lBankAccount.setTunnel(pFormBankAccount.getTunnel());
			lBankAccount.setSyncSig(pFormBankAccount.getSyncSig());
			lBankAccount.setConnectionType(Constants.CONNECTED);

			// Set the non-required fields
			if (!EaUtils.isEmpty(pFormBankAccount.getDatabaseSchema())) {
				lBankAccount.setDatabaseSchema(pFormBankAccount.getDatabaseSchema()
						.toUpperCase());
			}
			if (!EaUtils.isEmpty(pFormBankAccount.getTunnelPort())) {
				lBankAccount.setTunnelPort(pFormBankAccount.getTunnelPort());
			}
		} else {
			// Set the required fields for a disconnected BankAccount
			lBankAccount.setConnectionType(Constants.DISCONNECTED);
		}

		return lBankAccount;
	}

	private static void saveBankAccount(BankAccount pBankAccount,
			String psRemoteUser, Session pSession) throws HibernateException,
			NamingException, IllegalAccessException, InvocationTargetException, bankAccountException {
		// Set the BankAccount object with the default values
		pBankAccount.setRemoteUser(psRemoteUser);
		pBankAccount.setRecordTime(new Date());

		// Add or update the BankAccount object in the database
		String[] pBankAccountTypes = Constants.PROHIBIT_BANK_ACCOUNT_LIST.split(",");
		if (pBankAccountTypes != null && pBankAccountTypes.length > 0) {
			for (int i = 0; i < pBankAccountTypes.length; i++) {
			     if(pBankAccount.getType().toString().matches(pBankAccountTypes[i]) && pBankAccount.getConnectionType().equalsIgnoreCase(Constants.DISCONNECTED)){
			    	 throw new bankAccountException("error.bankAccount.prohibition");
			     } else {
			    	 pSession.saveOrUpdate(pBankAccount);
			     }
			}
		} else{
		pSession.saveOrUpdate(pBankAccount);
	          }
	}

	private static Long selectBankAccountCountByIdAndName(Long plId,
			String psName, Session pSession) throws Exception {
		return (Long) pSession
				.getNamedQuery("selectBankAccountCountByIdAndName").setLong("id", plId)
				.setString("name", psName.toUpperCase()).uniqueResult();
	}

	private static Long selectBankAccountCountByName(String psName,
			Session pSession) throws Exception {
		return (Long) pSession.getNamedQuery("selectBankAccountCountByName")
				.setString("name", psName.toUpperCase()).uniqueResult();
	}

	@SuppressWarnings("unchecked")
	private static List<BankAccount> selectBankAccountList(String psConnectionType)
			throws Exception {
		List<BankAccount> llBankAccount = null;
		Session lSession = getSession();

		llBankAccount = lSession.getNamedQuery("selectBankAccountList").setString(
				"connectionType", psConnectionType).list();
		closeSession(lSession);

		return llBankAccount;
	}

	private static ActionErrors validateBankAccount(BankAccount pBankAccount,
			Session pSession) throws Exception {
		ActionErrors lActionErrors = new ActionErrors();
		Long llBankAccountCount = null;

		if (pBankAccount.getId() == null) {
			llBankAccountCount = selectBankAccountCountByName(pBankAccount.getName(),
					pSession);
		} else {
			llBankAccountCount = selectBankAccountCountByIdAndName(pBankAccount
					.getId(), pBankAccount.getName(), pSession);
		}

		// Ensure that there is only one BankAccount with the given name
		if (llBankAccountCount > 0) {
			pSession.evict(llBankAccountCount);
			lActionErrors.add("name",
					new ActionMessage("error.bankAccount.duplicate"));
		} else if(pBankAccount.getId() == null && pBankAccount.getConnectionType().equalsIgnoreCase(Constants.DISCONNECTED)) {
			String[] pBankAccountTypes = Constants.PROHIBIT_BANK_ACCOUNT_LIST.split(",");
			if (pBankAccountTypes != null && pBankAccountTypes.length > 0) {
				for (int i = 0; i < pBankAccountTypes.length; i++) {
				     if(pBankAccount.getType().toString().matches(pBankAccountTypes[i])){
				    	 lActionErrors.add("type",
									new ActionMessage("error.bankAccount.prohibition"));
				     }
				}
			}
		}


		return lActionErrors;
	}
}

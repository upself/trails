package com.ibm.ea.bravo.systemstatus;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.apache.log4j.Logger;
import org.hibernate.Query;
import org.hibernate.Session;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.BankAccount;
import com.ibm.ea.sigbank.SystemScheduleStatus;

public class DelegateSystemStatus extends HibernateDelegate {
	private static final Logger logger = Logger
			.getLogger(DelegateSystemStatus.class);

	@SuppressWarnings("unchecked")
	public static List<SystemScheduleStatus> selectSystemScheduleStatusList(
			FormSubmit fs) throws Exception {

		boolean systemStatus_checkbox = fs.isSystemStatus_checkbox();
		List<SystemScheduleStatus> llSystemScheduleStatus = null;

		if (systemStatus_checkbox) {
			try {
				Session lSession = getSession();

				llSystemScheduleStatus = lSession.getNamedQuery(
						"selectSystemScheduleStatusList").list();
				closeSession(lSession);
			} catch (Exception e) {
				e.printStackTrace();
			}
		} else {
		}

		return llSystemScheduleStatus;
	}

	// function to get all active BankAccounts for Bank Account combobox
	@SuppressWarnings({ "unchecked" })
	public static List<BankAccount> getBankAccountNames() {

		List<BankAccount> bankAccountList = null;

		try {
			Session lSession = getSession();

			Query query = lSession.getNamedQuery("selectBankAccountNames");
			bankAccountList = query.list();

			closeSession(lSession);

		} catch (Exception e) {
			logger.debug("Trace: " + e.getStackTrace());
			logger.debug("Cause: " + e.getCause());
			logger.debug("Message: " + e.getMessage());
		}
		return bankAccountList;
	}

	// function to create a list fo BankAccountJobs to feed a data into Bank
	// Account Job
	// table in home.jsp SystemStatusPage based on user selections from the form
	// in that page
	@SuppressWarnings("unchecked")
	public static List<BankAccountJob> getSelectedBankAccountJobs(FormSubmit fs)
			throws Exception {

		List<BankAccountJob> bankAccountJobsSelected = null;

		try {
			String bankAcc = fs.getBankAccount().trim();
			String bankAccountHQL = "";

			String moduleLoad = fs.getModuleLoader().trim();
			String moduleLoadHQL = "";

			String loaderStat = fs.getLoaderStatus().trim();
			String loaderStatHQL = "";

			String bankAccountType = fs.getType().trim();
			String bankAccountTypeHQL = "";

			String connectionType = fs.getConnectionType().trim();
			String connectionTypeHQL = "";

			boolean delta_check = fs.isDelta_checkbox();
			String deltaStringHQL = "";

			SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd",
					Locale.ENGLISH);
			String date_f = fs.getDate_from().trim();
			String dateFromActual = "";
			Date date_f_asDate = null;

			String date_t = fs.getDate_to().trim();
			String dateToActual = "";
			Date date_t_asDate = null;

			if (!bankAcc.equals("0")) {
				bankAccountHQL = " and BAJ.bankAccount.id = :bankAccountId";
			}

			if (!moduleLoad.equals("Show All")) {
				moduleLoadHQL = " and BAJ.name like :moduleLoader";
			}

			if (!loaderStat.equals("Show All")) {
				loaderStatHQL = " and BAJ.status like :loaderStatus";
			}

			if (!bankAccountType.equals("Show All")) {
				bankAccountTypeHQL = " and BA.type like :B_A_Type";
			}

			if (!connectionType.equals("Show All")) {
				connectionTypeHQL = " and BA.connectionType = :connType";
			}

			if (date_f.length() > 0) {
				dateFromActual = " and BAJ.startTime >= :start_time";
				date_f_asDate = sdf.parse(date_f);
			}

			if (date_t.length() > 0) {
				dateToActual = " and BAJ.endTime <= :end_time";
				date_t_asDate = sdf.parse(date_t);
			}

			if (!delta_check) {
				deltaStringHQL = " and BAJ.name not like :deltaLoadsCheck";
			}

			String hqlQuery = "FROM BankAccountJob BAJ JOIN FETCH BAJ.bankAccount BA where BA.status ='ACTIVE'"
					+ bankAccountHQL
					+ moduleLoadHQL
					+ loaderStatHQL
					+ bankAccountTypeHQL
					+ connectionTypeHQL
					+ deltaStringHQL
					+ dateFromActual + dateToActual;

			logger.info("hqlQuery: " + hqlQuery);

			Session lSession = getSession();

			Query query = lSession.createQuery(hqlQuery);

			if (!bankAcc.equals("0")) {
				query.setString("bankAccountId", bankAcc);
			}

			if (moduleLoadHQL.length() > 0) {
				query.setString("moduleLoader", "%" + moduleLoad + "%");
			}
			if (loaderStatHQL.length() > 0) {
				query.setString("loaderStatus", "%" + loaderStat + "%");
			}
			if (bankAccountTypeHQL.length() > 0) {
				query.setString("B_A_Type", "%" + bankAccountType + "%");
			}
			if (connectionTypeHQL.length() > 0) {
				query.setString("connType", connectionType);
			}
			if (deltaStringHQL.length() > 0) {
				query.setString("deltaLoadsCheck", "%(DELTA)%");
			}
			if (dateFromActual.length() > 0) {
				query.setTimestamp("start_time", date_f_asDate);
			}
			if (dateToActual.length() > 0) {
				query.setTimestamp("end_time", date_t_asDate);
			}

			bankAccountJobsSelected = query.list();

			closeSession(lSession);

		} catch (Exception e) {
			e.printStackTrace();
		}

		return bankAccountJobsSelected;
	}
}
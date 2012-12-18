package com.ibm.ea.bravo.systemstatus;

import java.util.List;

import org.hibernate.Session;

import com.ibm.ea.bravo.framework.hibernate.HibernateDelegate;
import com.ibm.ea.sigbank.SystemScheduleStatus;

public class DelegateSystemStatus extends HibernateDelegate {

	@SuppressWarnings("unchecked")
	public static List<SystemScheduleStatus> selectSystemScheduleStatusList()
			throws Exception {
		List<SystemScheduleStatus> llSystemScheduleStatus = null;
		Session lSession = getSession();

		llSystemScheduleStatus = lSession.getNamedQuery(
				"selectSystemScheduleStatusList").list();
		closeSession(lSession);

		return llSystemScheduleStatus;
	}

	@SuppressWarnings("unchecked")
	public static List<BankAccountJob> selectBankAccountJobList()
			throws Exception {
		List<BankAccountJob> llBankAccountJob = null;
		Session lSession = getSession();

		llBankAccountJob = lSession.getNamedQuery("selectBankAccountJobList")
				.list();
		closeSession(lSession);

		return llBankAccountJob;
	}
}

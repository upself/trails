package com.ibm.asset.trails.util;

import javax.servlet.http.HttpSession;

import com.ibm.asset.trails.domain.Account;
import com.ibm.tap.trails.framework.UserSession;

public class TrailsUtility {
	public static boolean isSwTrackingAccount(HttpSession session) {
		boolean swTrackingAccountFlag = false;

		if (session != null 
		 && session.getAttribute(UserSession.USER_SESSION) != null
		 && ((UserSession) session.getAttribute(UserSession.USER_SESSION)).getAccount() != null
		 && ((UserSession) session.getAttribute(UserSession.USER_SESSION)).getAccount().getSoftwareTracking() != null
		 && ((UserSession) session.getAttribute(UserSession.USER_SESSION)).getAccount().getSoftwareTracking().trim().equalsIgnoreCase("YES")
		 && (((UserSession) session.getAttribute(UserSession.USER_SESSION)).getAccount().getSwlm() == null
	         ||!((UserSession) session.getAttribute(UserSession.USER_SESSION)).getAccount().getSwlm().trim().equalsIgnoreCase("YES") 
		    )
		) {
			swTrackingAccountFlag = true;
		}

		return swTrackingAccountFlag;
	}
	
	public static boolean isSwTrackingAccount(Account account) {
		boolean swTrackingAccountFlag = false;

		if (account != null
		 && account.getSoftwareTracking() != null
		 && account.getSoftwareTracking().trim().equalsIgnoreCase("YES")
		 && (account.getSwlm() == null
	         ||!account.getSwlm().trim().equalsIgnoreCase("YES") 
		    )
		){
			swTrackingAccountFlag = true;
		}

		return swTrackingAccountFlag;
	}
}

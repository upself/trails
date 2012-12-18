package com.ibm.tap.common;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

public abstract class SecurityLogger {

	public static void logEvent(String psLoginUserName, String psModifiedUserName,
			String psAccessAttemptType) {
		Log lLog = LogFactory.getLog(SecurityLogger.class);

		lLog.info(new StringBuffer("User '").append(psLoginUserName).append(
				"' attempting to change access type for '").append(psModifiedUserName)
				.append("' to ").append(psAccessAttemptType).append("."));
	}
}

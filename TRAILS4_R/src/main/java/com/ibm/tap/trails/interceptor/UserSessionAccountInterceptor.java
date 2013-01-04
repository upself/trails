package com.ibm.tap.trails.interceptor;

import java.util.Date;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.struts2.StrutsStatics;

import com.ibm.tap.trails.framework.UserSession;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

public class UserSessionAccountInterceptor extends AbstractInterceptor
		implements StrutsStatics {

	private static final long serialVersionUID = 1L;

	private static final String ACCOUNT_ID_PARAM = "accountId";

	private static final long sessionRefreshTime = 300000;

	private static final Log log = LogFactory
			.getLog(UserSessionAccountInterceptor.class);

	public void destroy() {
	}

	public void init() {
	}

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {

		ActionContext context = invocation.getInvocationContext();
		HttpServletRequest request = (HttpServletRequest) context
				.get(HTTP_REQUEST);
		HttpSession session = request.getSession(true);
		final long curEpochTime = new Date().getTime();
		final long curSessionTime = session.getLastAccessedTime();

		UserSession user = (UserSession) session
				.getAttribute(UserSession.USER_SESSION);

		String accountId = request.getParameter(ACCOUNT_ID_PARAM);
		log.debug("Account ID param:" + accountId);

		if (!StringUtils.isBlank(accountId)) {
			log.debug("Setting account id on action");
			request.setAttribute(ACCOUNT_ID_PARAM, accountId);
		} else {
			log.debug("Account ID param:" + user.getAccount().getId());

			Map<String, Object> parameters = context.getParameters();
			parameters.put(ACCOUNT_ID_PARAM, user.getAccount().getId()
					.toString());
			context.setParameters(parameters);
		}

		boolean refresh = isRefreshNeeded(curEpochTime, curSessionTime);

		if (isValidAccount(user, accountId, refresh, request, context)) {
			return invocation.invoke();
		}

		return "global_home";
	}

	private boolean isRefreshNeeded(long curEpochTime, long curSessionTime) {

		if ((curEpochTime - curSessionTime) > sessionRefreshTime) {
			return true;
		}

		return false;
	}

	private boolean isValidAccount(UserSession user, String accountId,
			boolean refresh, HttpServletRequest request, ActionContext context) {

		if (StringUtils.isBlank(accountId)) {
			// No account id passed

			if (user.getAccount() == null) {
				// No account in session

				return false;
			} else {
				// We have an account

				if (refresh) {
					// We want to refresh the account
					user.setAccount(null);
					return true;
				} else {
					return true;
				}
			}

		} else {
			// We have a passed account id

			if (user.getAccount() == null) {
				// No account in session
				return true;
			} else {
				// We have an account in session

				if (!accountId.equals(user.getAccount().getId().toString())) {
					// account ids are not equal
					user.setAccount(null);
					return true;
				} else {
					// account ids are equal

					if (refresh) {
						// We want to refresh the account
						user.setAccount(null);
						return true;
					} else {
						return true;
					}
				}
			}
		}
	}

}

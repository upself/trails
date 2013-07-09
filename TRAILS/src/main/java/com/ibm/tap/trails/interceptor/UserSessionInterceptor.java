package com.ibm.tap.trails.interceptor;

import java.util.Map;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.apache.struts2.StrutsStatics;

import com.ibm.tap.trails.framework.UserSession;
import com.opensymphony.xwork2.ActionContext;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.AbstractInterceptor;

public class UserSessionInterceptor extends AbstractInterceptor implements
		StrutsStatics {

	private static final long serialVersionUID = 1L;

	public void destroy() {
	}

	public void init() {
	}

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {
		final ActionContext context = invocation.getInvocationContext();
		HttpServletRequest request = (HttpServletRequest) context
				.get(HTTP_REQUEST);
		HttpSession session = request.getSession(false);
		UserSession user = null;

		if (session == null) {
			session = request.getSession(true);
			user = new UserSession(request.getRemoteUser());
			session.setAttribute(UserSession.USER_SESSION, user);
			if (request.getRequestURI().equals(
					"/TRAILS/account/trailsreports/home.htm")) {
				Map userSession = context.getSession();
				userSession.put(UserSession.USER_SESSION, user);
				return invocation.invoke();
			}
			return "global_home";

		} else {
			user = (UserSession) session.getAttribute(UserSession.USER_SESSION);
			if (user == null) {
				user = new UserSession(request.getRemoteUser());
				session.setAttribute(UserSession.USER_SESSION, user);
			}
			return invocation.invoke();
		}

	}
}

package com.ibm.tap.trails.interceptor;

import java.lang.reflect.Method;

import org.apache.struts2.interceptor.RolesInterceptor;

import com.ibm.tap.trails.annotation.UserRole;
import com.opensymphony.xwork2.ActionInvocation;
import com.opensymphony.xwork2.interceptor.PrefixMethodInvocationUtil;

public class UserRolesInterceptor extends RolesInterceptor {

	private static final long serialVersionUID = 1L;

	public static final String[] prefixes = { "do", "get" };

	public void destroy() {
	}

	public void init() {
	}

	@Override
	public String intercept(ActionInvocation invocation) throws Exception {

		// Map session = invocation.getInvocationContext().getSession();
		// Map request = invocation.getInvocationContext().getParameters();

		// Get the current method string out of the action
		String curMethod = invocation.getProxy().getMethod();

		// Capitalize the first letter of the method string
		// curMethod = PrefixMethodInvocationUtil.capitalizeMethodName(curMethod);

		// Loop through the prefixes and find the first matching method
		Method m = PrefixMethodInvocationUtil.getPrefixedMethod(prefixes,
				PrefixMethodInvocationUtil.capitalizeMethodName(curMethod),
				invocation.getAction());

		if (m == null) {
			try {
				m = invocation.getAction().getClass().getMethod(curMethod, new Class[0]);
			} catch (NoSuchMethodException nsme) {
				return invocation.invoke();
			}
		}

		// Grab the userRole annotation off the method
		UserRole userRole = m.getAnnotation(UserRole.class);

		// If userRole is defined then set the allowable roles, else let it pass
		// through
		if (userRole != null) {
			setAllowedRoles(userRole.userRole().getRoleName());
			return super.intercept(invocation);
		}

		return invocation.invoke();

	}

}

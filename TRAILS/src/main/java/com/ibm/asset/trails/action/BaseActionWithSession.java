package com.ibm.asset.trails.action;

import java.util.Map;

import org.apache.struts2.interceptor.SessionAware;

import com.ibm.tap.trails.framework.UserSession;

public class BaseActionWithSession extends BaseAction implements SessionAware {

    private static final long serialVersionUID = 1L;

    protected Map<String, Object> session;

    public Map<String, Object> getSession() {
        return session;
    }

    public void setSession(Map<String, Object> session) {
        this.session = session;
    }

    public UserSession getUserSession() {
        return (UserSession) getSession().get(UserSession.USER_SESSION);
    }

    public void setUserSession(UserSession userSession) {
        getSession().put(UserSession.USER_SESSION, userSession);
    }

}

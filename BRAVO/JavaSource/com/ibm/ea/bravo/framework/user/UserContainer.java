package com.ibm.ea.bravo.framework.user;

import javax.servlet.http.HttpSessionBindingEvent;
import javax.servlet.http.HttpSessionBindingListener;

/**
 * @author Thomas Newton
 * 
 * This object is used to hold all the information a user needs while navigating
 * TAP.
 */
public class UserContainer implements HttpSessionBindingListener {

    private boolean admin;
    private boolean authorized;
    private String remoteUser;

    public void init() {
    }

    /**
     * @return Returns the authorized.
     */
    public boolean isAuthorized() {
        return this.authorized;
    }
    /**
     * @param authorized The authorized to set.
     */
    public void setAuthorized(boolean authorized) {
        this.authorized = authorized;
    }
    /**
     * @return Returns the remoteUser.
     */
    public String getRemoteUser() {
        return this.remoteUser;
    }
    /**
     * @param remoteUser
     *            The remoteUser to set.
     */
    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }

    /**
     * @return Returns the admin.
     */
    public boolean isAdmin() {
        return this.admin;
    }
    /**
     * @param admin
     *            The admin to set.
     */
    public void setAdmin(boolean admin) {
        this.admin = admin;
    }

    public void valueBound(HttpSessionBindingEvent arg0) {
    }

    public void valueUnbound(HttpSessionBindingEvent arg0) {
        cleanUp();
    }

    public void cleanUp() {
    }
}
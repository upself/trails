/*
 * Created on Feb 15, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.framework;

import java.io.IOException;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.hibernate.HibernateException;

import com.ibm.batch.BatchPlugin;
import com.ibm.batch.IBatch;
import com.ibm.tap.delegate.acl.BluegroupsDelegate;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;

/**
 * @author alexmois
 *  
 */
public class CommandBaseAction
        extends CommandDispatchAction {

    protected UserContainer loadUser(HttpServletRequest request)
            throws HibernateException, NamingException {

        UserContainer user = getUserContainer(request);

        if (!user.isLoaded()) {

            String remoteUser = request.getRemoteUser();

            user.setAdmin(BluegroupsDelegate.isMember(remoteUser,
                    Constants.GROUP_ADMIN));
            user.setMisldAdmin(BluegroupsDelegate.isMember(remoteUser,
                    Constants.GROUP_MISLD_ADMIN));
            user.setAsset(BluegroupsDelegate.isMember(remoteUser,
                    Constants.GROUP_ASSET));

            if (user.isAdmin() || user.isMisldAdmin()) {
                user.setAdminAccess(true);
                user.setAsset(true);
            }

            if (user.isAsset()) {
                user.setAsset(true);
            }

            user.setRecordsPerPage(25);
            user.setRemoteUser(remoteUser);
            user.setLoaded(true);
        }

        setUserContainer(request, user);

        return user;
    }

    protected UserContainer getUserContainer(HttpServletRequest request) {

        HttpSession session = request.getSession();

        UserContainer existingContainer = (UserContainer) session
                .getAttribute(Constants.USER_CONTAINER);

        if (existingContainer == null) {
            existingContainer = new UserContainer();
        }

        return existingContainer;
    }

    protected void setUserContainer(HttpServletRequest request,
            UserContainer userContainer) {

        HttpSession session = request.getSession();

        session.setAttribute(Constants.USER_CONTAINER, userContainer);
    }

    public void setCustomer(HttpServletRequest request, Customer customer) {
        UserContainer userContainer = getUserContainer(request);
        userContainer.setCustomer(customer);
        setUserContainer(request, userContainer);
    }

    protected void addBatch(IBatch batch) throws HibernateException,
            SQLException, IOException, NamingException {
        BatchPlugin batchFactory = (BatchPlugin) getApplicationObject(Constants.BATCH_FACTORY_KEY);
        batchFactory.addBatch(batch);
    }

    /**
     * @param batch_factory_key
     * @return
     */
    private Object getApplicationObject(String key) {
        return servlet.getServletContext().getAttribute(key);
    }

    public void setAccountSettingsForm(HttpServletRequest request,
            MisldAccountSettings misldAccountSettings) {
        UserContainer userContainer = getUserContainer(request);
        userContainer.setAccountSettingsForm(misldAccountSettings);
        setUserContainer(request, userContainer);
    }

    public void clearMisldAccountSettings(HttpServletRequest request) {

        HttpSession session = request.getSession();

        session.setAttribute("misldAccountSettings", null);
    }
}
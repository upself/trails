/*
 * Created on Mar 29, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.software;

import java.lang.reflect.InvocationTargetException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Vector;

import javax.naming.NamingException;

import org.apache.commons.beanutils.BeanUtils;
import org.apache.log4j.Logger;
import org.apache.struts.action.ActionErrors;
import org.apache.struts.action.ActionMessage;
import org.hibernate.HibernateException;
import org.hibernate.Session;
import org.hibernate.Transaction;

import com.ibm.tap.sigbank.filter.SoftwareFilterDelegate;
import com.ibm.tap.sigbank.framework.common.Constants;
import com.ibm.tap.sigbank.framework.common.Delegate;
import com.ibm.tap.sigbank.framework.common.Util;
import com.ibm.tap.sigbank.framework.navigate.SearchForm;
import com.ibm.asset.swkbt.domain.Manufacturer;
import com.ibm.tap.sigbank.manufacturer.ManufacturerDelegate;
import com.ibm.tap.sigbank.signature.SoftwareSignatureDelegate;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategory;
import com.ibm.tap.sigbank.softwarecategory.SoftwareCategoryDelegate;

/**
 * @@author Thomas
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class SoftwareDelegate extends Delegate {

    static Logger logger = Logger.getLogger(SoftwareDelegate.class);

    public static ActionErrors validateSoftwareSearch(SearchForm ssf) {
        ActionErrors errors = new ActionErrors();

        if (Util.isBlankString(ssf.getSoftwareName())
                && Util.isBlankString(ssf.getManufacturerId())
                && Util.isBlankString(ssf.getSoftwareCategoryId())) {
            errors.add("softwareName", new ActionMessage("search.required"));
        }

        return errors;
    }

    public static List getSoftwareSearchResults(SearchForm ssf)
            throws HibernateException, NamingException {

        List results = null;

        Session session = getHibernateSession();

        if (Util.isBlankString(ssf.getManufacturerId())
                && Util.isBlankString(ssf.getSoftwareCategoryId())) {
            results = searchSoftwareByName(ssf.getSoftwareName().toUpperCase(),
                    results, session);
        } else if (Util.isBlankString(ssf.getManufacturerId())) {
            results = searchSoftwareByNameAndCategory(ssf.getSoftwareName()
                    .toUpperCase(), ssf.getSoftwareCategoryId(), results,
                    session);
        } else if (Util.isBlankString(ssf.getSoftwareCategoryId())) {
            results = searchSoftwareByNameAndManufacturer(ssf.getSoftwareName()
                    .toUpperCase(), ssf.getManufacturerId(), results, session);
        } else {
            results = searchSwByNameManfCat(
                    ssf.getSoftwareName().toUpperCase(), ssf
                            .getSoftwareCategoryId(), ssf.getManufacturerId(),
                    results, session);
        }

        session.close();

        return results;
    }

    private static List searchSwByNameManfCat(String search,
            String softwareCategoryId, String manufacturerId, List results,
            Session session) {

        search = "%" + search + "%";

        results = session.getNamedQuery("searchSwByNameManfCat").setString(
                "search", search).setLong("manufacturerId",
                new Long(manufacturerId).longValue()).setLong(
                "softwareCategoryId", new Long(softwareCategoryId).longValue())
                .list();

        return results;
    }

    private static List searchSoftwareByNameAndManufacturer(String search,
            String manufacturerId, List results, Session session) {

        search = "%" + search + "%";

        results = session.getNamedQuery("searchSwByNameAndManufacturer")
                .setString("search", search).setLong("manufacturerId",
                        new Long(manufacturerId).longValue()).list();

        return results;
    }

    private static List searchSoftwareByNameAndCategory(String search,
            String softwareCategoryId, List results, Session session) {

        search = "%" + search + "%";

        results = session.getNamedQuery("searchSwByNameAndCategory").setString(
                "search", search).setLong("softwareCategoryId",
                new Long(softwareCategoryId).longValue()).list();

        return results;
    }

    public static List searchSoftwareByName(String search)
            throws HibernateException, NamingException {

        List softwares = null;

        Session session = getHibernateSession();

        softwares = searchSoftwareByName(search, softwares, session);

        session.close();

        return softwares;
    }

    public static List searchSoftwareByName(String search, List results,
            Session session) {

        search = "%" + search + "%";

        results = session.getNamedQuery("searchSoftwareByName").setString(
                "search", search).list();

        return results;
    }

    public static List getSoftwareHistory(String softwareId)
            throws HibernateException, NamingException {

        List softwareHistory = null;

        Session session = getHibernateSession();

        softwareHistory = getSoftwareHistory(softwareId, softwareHistory,
                session);

        session.close();

        return softwareHistory;
    }

    public static List getSoftwareHistory(String softwareId, List results,
            Session session) {

        results = session.getNamedQuery("softwareHistoryBySoftwareId").setLong(
                "softwareId", new Long(softwareId).longValue()).list();

        return results;
    }

    public static ActionErrors addSoftware(SoftwareForm softwareForm,
            String remoteUser) throws HibernateException, NamingException,
            IllegalAccessException, InvocationTargetException {

        Session session = getHibernateSession();
        Transaction tx = session.beginTransaction();

        // Transfer our form to a software object
        Software software = transferAddSoftwareForm(softwareForm, session);

        // Now we need to go through the logic of adding a new piece of software
        ActionErrors errors = new ActionErrors();

        // Get the software by name from DB
        Software softwareByName = null;
        softwareByName = getSoftwareByName(software.getSoftwareName(),
                softwareByName, session);

        // If the software exists by name
        if (softwareByName != null) {

            // If the softwareByName is active we cannot add this because it
            // exists
            if (softwareByName.getStatus().equalsIgnoreCase(Constants.ACTIVE)) {
                errors.add("softwareName", new ActionMessage(
                        "errors.software.duplicate"));
                return errors;
            }

            // Update the software id to the one that exists, this will activate
            // it
            software.setSoftwareId(softwareByName.getSoftwareId());
        }

        session.evict(softwareByName);

        // Save the software
        save(software, remoteUser, session);
        tx.commit();
        session.close();

        // return the errors
        return errors;
    }

    public static Software transferAddSoftwareForm(SoftwareForm softwareForm,
            Session session) throws HibernateException, NamingException,
            IllegalAccessException, InvocationTargetException {

        // Instantiate a new software object
        Software software = new Software();

        // Set the fields from the software form
        software.setComments(softwareForm.getComments());
        software.setLevel(softwareForm.getLevel());
        software.setChangeJustification(softwareForm.getChangeJustification());
        software.setType(softwareForm.getType());
        software.setVendorManaged(new Boolean(softwareForm.getVendorManaged()));
        software.setStatus(Constants.ACTIVE);

        // Need to ensure the software name is upper case
        // TODO should we move this to a more generic place
        software.setSoftwareName(softwareForm.getSoftwareName().toUpperCase()
                .trim());

        // Need to set these from db calls
        Manufacturer manufacturer = null;
        SoftwareCategory softwareCategory = null;
        software.setManufacturer(ManufacturerDelegate.getManufacturer(
                softwareForm.getManufacturer(), manufacturer, session));
        software.setSoftwareCategory(SoftwareCategoryDelegate
                .getSoftwareCategory(softwareForm.getSoftwareCategory(),
                        softwareCategory, session));

        // We are going to wipe out the trigger
        Integer priority = null;
        priority = getPriority(software.getSoftwareCategory(), priority,
                session);
        software.setPriority(priority);

        // Return the newly created software object
        return software;
    }

    private static Integer getPriority(SoftwareCategory softwareCategory,
            Integer priority, Session session) {
        priority = (Integer) session.getNamedQuery("getMaxCategoryPriority")
                .setEntity("softwareCategory", softwareCategory).uniqueResult();

        if (priority == null) {
            priority = new Integer("1");
        }

        return priority;
    }

    public static Software getSoftwareByName(String softwareName)
            throws HibernateException, NamingException {

        Software software = null;

        Session session = getHibernateSession();

        software = getSoftwareByName(softwareName, software, session);

        session.close();

        return software;
    }

    public static Software getSoftwareByName(String softwareName,
            Software result, Session session) {

        softwareName = softwareName.toUpperCase();

        result = (Software) session.getNamedQuery("softwareByName").setString(
                "softwareName", softwareName).uniqueResult();

        return result;
    }

    public static SoftwareForm setUpdateForm(String softwareId)
            throws IllegalAccessException, InvocationTargetException,
            HibernateException, NamingException {

        Software software = getSoftware(softwareId);

        SoftwareForm softwareForm = new SoftwareForm();

        BeanUtils.copyProperties(softwareForm, software);

        // Need to set the manufacturerId and softwarecategoryid as beanutils
        // won't copy these correctly
        softwareForm.setManufacturer(software.getManufacturer()
                .getManufacturerId().toString());
        softwareForm.setSoftwareCategory(software.getSoftwareCategory()
                .getSoftwareCategoryId().toString());

        // Set these to null for we don't want them to show up in the form
        softwareForm.setChangeJustification(null);
        softwareForm.setComments(null);

        return softwareForm;
    }

    public static ActionErrors updateSoftware(SoftwareForm softwareForm,
            String remoteUser) throws HibernateException, NamingException,
            IllegalAccessException, InvocationTargetException {

        Session session = getHibernateSession();
        Transaction tx = session.beginTransaction();

        // Transfer our form to a software object
        Software software = transferUpdateSoftwareForm(softwareForm, session);

        // Now we need to go through the logic of updating a new piece of
        // software
        ActionErrors errors = new ActionErrors();

        // Grab the software from the database using the ID
        Software softwareById = null;
        softwareById = getSoftware(software.getSoftwareId().toString(),
                softwareById, session);

        // Grab the software from the database using the software name
        Software softwareByName = null;
        softwareByName = getSoftwareByName(software.getSoftwareName(),
                softwareByName, session);

        // If the software name exists in the database
        if (softwareByName != null) {

            // If the IDs of the two from the db are not equal
            if (!softwareById.getSoftwareId().equals(
                    softwareByName.getSoftwareId())) {

                // If software by name is active, error
                if (softwareByName.getStatus().equalsIgnoreCase(
                        Constants.ACTIVE)) {
                    errors.add("softwareName", new ActionMessage(
                            "errors.software.duplicate"));
                    return errors;
                } else {
                    Integer priority = null;
                    priority = getPriority(software.getSoftwareCategory(),
                            priority, session);
                    software.setPriority(priority);
                }

                // Since we are updating a record that exists as inactive
                // We need to inactivate the software by id and activate the
                // software by name

                // Setup the software we are inactivating
                softwareById.setStatus(Constants.INACTIVE);
                softwareById.setComments("SOFTWARE NAME CHANGE: "
                        + software.getSoftwareName());
                softwareById.setChangeJustification(software
                        .getChangeJustification());
                // Put the priority at 0
                softwareById.setPriority(new Integer("0"));

                save(softwareById, remoteUser, session);

                // Set our id to that of the software by name to do our update
                software.setSoftwareId(softwareByName.getSoftwareId());
            } else {
                // We know we are talking about the same record here so do
                // nothing
                if (!softwareById.getSoftwareCategory()
                        .getSoftwareCategoryName().equals(
                                software.getSoftwareCategory()
                                        .getSoftwareCategoryName())) {
                    // We changed the category so lets update the priority
                    Integer priority = null;
                    priority = getPriority(software.getSoftwareCategory(),
                            priority, session);
                    software.setPriority(priority);
                }

                session.evict(softwareById);
            }
        } else {
            // We know we are talking about the same record
            if (!softwareById.getSoftwareCategory().getSoftwareCategoryName()
                    .equals(
                            software.getSoftwareCategory()
                                    .getSoftwareCategoryName())) {
                // We changed the category so lets update the priority
                Integer priority = null;
                priority = getPriority(software.getSoftwareCategory(),
                        priority, session);
                software.setPriority(priority);
            }

            session.evict(softwareById);
        }

        session.evict(softwareByName);

        // Save the software
        save(software, remoteUser, session);
        tx.commit();
        session.close();

        // Return the errors
        return errors;
    }

    public static Software transferUpdateSoftwareForm(
            SoftwareForm softwareForm, Session session)
            throws HibernateException, NamingException, IllegalAccessException,
            InvocationTargetException {

        // Instantiate a new software object
        Software software = new Software();

        // Copy the properties over from the form
        software.setChangeJustification(softwareForm.getChangeJustification());
        software.setSoftwareId(new Long(softwareForm.getSoftwareId()));
        software.setPriority(new Integer(softwareForm.getPriority()));
        software.setLevel(softwareForm.getLevel());
        software.setType(softwareForm.getType());
        software.setVendorManaged(new Boolean(softwareForm.getVendorManaged()));
        software.setStatus(softwareForm.getStatus());

        // Need to ensure the software name is uppercase
        // TODO should we move this to a more generic place
        software.setSoftwareName(softwareForm.getSoftwareName().toUpperCase()
                .trim());

        // If they didn't update these, we want to keep them null in the
        // database
        if (!Util.isBlankString(softwareForm.getComments())) {
            software.setComments(softwareForm.getComments());
        }

        // Need to set these from db calls
        Manufacturer manufacturer = null;
        SoftwareCategory softwareCategory = null;
        software.setManufacturer(ManufacturerDelegate.getManufacturer(
                softwareForm.getManufacturer(), manufacturer, session));
        software.setSoftwareCategory(SoftwareCategoryDelegate
                .getSoftwareCategory(softwareForm.getSoftwareCategory(),
                        softwareCategory, session));

        // Return the software object
        return software;
    }

    public static Software getSoftware(String id) throws HibernateException,
            NamingException {

        Software software = null;

        Session session = getHibernateSession();

        software = getSoftware(id, software, session);

        session.close();

        return software;
    }

    public static Software getSoftware(String id, Software software,
            Session session) {

        software = (Software) session.getNamedQuery("softwareById").setLong(
                "softwareId", new Long(id).longValue()).uniqueResult();

        return software;
    }

    public static void save(Software software, String remoteUser,
            Session session) throws HibernateException, NamingException,
            IllegalAccessException, InvocationTargetException {

    }

    public static void changeSoftwareManufacturer(List softwares,
            Manufacturer to, String changeJustification, String comments,
            String remoteUser, Session session) throws HibernateException,
            NamingException, IllegalAccessException, InvocationTargetException {

        Iterator i = softwares.iterator();
        while (i.hasNext()) {
            Software software = (Software) i.next();
            if (software.getManufacturer().getManufacturerName().equals(
                    to.getManufacturerName())) {
                continue;
            }
            session.evict(software.getManufacturer());

            software.setManufacturer(to);
            software.setChangeJustification(changeJustification);
            software.setComments(comments);
            save(software, remoteUser, session);
        }

    }

    private static List getSoftwareByManufacturer(Manufacturer manufacturer,
            List results, Session session) {

        results = session.getNamedQuery("softwareByManufacturer").setEntity(
                "manufacturer", manufacturer).list();

        return results;
    }

    public static ActionErrors updateSoftwareManufacturer(
            SoftwareForm softwareForm, String remoteUser)
            throws HibernateException, NamingException, IllegalAccessException,
            InvocationTargetException {

        Session session = getHibernateSession();
        Transaction tx = session.beginTransaction();

        ActionErrors errors = new ActionErrors();
        List<Long> selected = new Vector<Long>();

        for (int i = 0; i < softwareForm.getSelectedItems().length; i++) {
            if (Util.isInt(softwareForm.getSelectedItems()[i])) {
                selected.add(new Long(softwareForm.getSelectedItems()[i]));
            }
        }

        Manufacturer to = null;
        to = ManufacturerDelegate.getManufacturer(softwareForm
                .getManufacturer(), to, session);

        List softwares = null;
        softwares = getSoftwares(selected, softwares, session);

        changeSoftwareManufacturer(softwares, to, softwareForm
                .getChangeJustification(), softwareForm.getComments(),
                remoteUser, session);

        tx.commit();
        session.close();

        // Return the errors
        return errors;
    }

    private static List getSoftwares(List selected, List results,
            Session session) {

        results = session.getNamedQuery("softwareByIdList").setParameterList(
                "ids", selected).list();
        return results;
    }

    public static List getSoftwares(Manufacturer manufacturer)
            throws HibernateException, Exception {

        List manufacturers = null;

        Session session = getHibernateSession();

        manufacturers = getSoftwares(manufacturer, manufacturers, session);

        session.close();

        return manufacturers;
    }

    public static List getSoftwares(Manufacturer manufacturer, List results,
            Session session) {

        results = session.getNamedQuery("softwaresByManufacturer").setEntity(
                "manufacturer", manufacturer).list();

        return results;
    }

    public static void updateSoftwareSoftwareCategory(SoftwareCategory from,
            SoftwareCategory to, String remoteUser, Session session)
            throws HibernateException, NamingException, IllegalAccessException,
            InvocationTargetException {

        List softwares = null;
        softwares = getSoftwares(from, softwares, session);
        changeSoftwareSoftwareCategory(softwares, to, from
                .getChangeJustification(), "SOFTWARE CATEGORY CHANGE",
                remoteUser, session);

    }

    public static void changeSoftwareSoftwareCategory(List softwares,
            SoftwareCategory to, String changeJustification, String comments,
            String remoteUser, Session session) throws HibernateException,
            NamingException, IllegalAccessException, InvocationTargetException {

        // If we are moving software to an inactive manufacturer, we need to
        // activate the manufacturer
        if (to.getStatus().equals(Constants.INACTIVE)) {
            to.setStatus(Constants.ACTIVE);
            to.setChangeJustification(changeJustification);
            to.setComments(comments);
            SoftwareCategoryDelegate.save(to, remoteUser, session);
        }

        Integer priority = null;
        priority = getPriority(to, priority, session);

        Iterator i = softwares.iterator();
        while (i.hasNext()) {
            Software software = (Software) i.next();
            if (software.getSoftwareCategory().getSoftwareCategoryName()
                    .equals(to.getSoftwareCategoryName())) {
                continue;
            }
            software.setSoftwareCategory(to);
            software.setChangeJustification(changeJustification);
            software.setComments(comments);
            software.setPriority(priority);
            save(software, remoteUser, session);
            priority = new Integer(priority.intValue() + 1);
        }
    }

    public static List getSoftwares(SoftwareCategory softwareCategory)
            throws HibernateException, Exception {

        List softwares = null;

        Session session = getHibernateSession();

        softwares = getSoftwares(softwareCategory, softwares, session);

        session.close();

        return softwares;
    }

    public static List getSoftwares(SoftwareCategory softwareCategory,
            List results, Session session) {

        results = session.getNamedQuery("softwareBySoftwareCategory")
                .setEntity("softwareCategory", softwareCategory).list();

        return results;
    }

    public static ActionErrors updateSoftwareSoftwareCategory(
            SoftwareForm softwareForm, String remoteUser)
            throws HibernateException, NamingException, IllegalAccessException,
            InvocationTargetException {

        Session session = getHibernateSession();
        Transaction tx = session.beginTransaction();

        ActionErrors errors = new ActionErrors();
        List<Long> selected = new Vector<Long>();

        for (int i = 0; i < softwareForm.getSelectedItems().length; i++) {
            if (Util.isInt(softwareForm.getSelectedItems()[i])) {
                selected.add(new Long(softwareForm.getSelectedItems()[i]));
            }
        }

        SoftwareCategory to = null;
        to = SoftwareCategoryDelegate.getSoftwareCategory(softwareForm
                .getSoftwareCategory(), to, session);

        List softwares = null;
        softwares = getSoftwares(selected, softwares, session);

        changeSoftwareSoftwareCategory(softwares, to, softwareForm
                .getChangeJustification(), softwareForm.getComments(),
                remoteUser, session);

        tx.commit();
        session.close();

        // Return the errors
        return errors;
    }

    public static void changeSoftwarePriority(SoftwareForm sf, String remoteUser)
            throws HibernateException, NamingException, IllegalAccessException,
            InvocationTargetException {

        Session session = getHibernateSession();

        int newPriority = new Integer(sf.getPriority()).intValue();

        Software software = null;
        software = getSoftware(sf.getSoftwareId(), software, session);
        // if the new priority equals old then don't do anymore

        if (software.getPriority().intValue() != newPriority) {

            Transaction tx = session.beginTransaction();

            software.setPriority(new Integer(newPriority));
            software.setChangeJustification(sf.getChangeJustification());
            software.setComments(sf.getComments());
            save(software, remoteUser, session);

            tx.commit();

            tx = session.beginTransaction();

            List priorities = null;
            priorities = getSoftwarePriorityOrder(software
                    .getSoftwareCategory(), priorities, session);

            Iterator i = priorities.iterator();
            int currentPriority = 1;

            while (i.hasNext()) {
                Software sw = (Software) i.next();
                if (sw.getStatus().equals(Constants.INACTIVE)) {
                    if (sw.getPriority().intValue() == 0) {
                        continue;
                    } else {
                        sw.setChangeJustification(sf.getChangeJustification());
                        sw.setComments(sf.getComments());
                        save(sw, remoteUser, session);
                    }
                }
                if (sw.getPriority().intValue() != currentPriority) {
                    sw.setPriority(new Integer(currentPriority));
                    sw.setChangeJustification(sf.getChangeJustification());
                    sw.setComments(sf.getComments());
                    save(sw, remoteUser, session);
                }
                if (sw.getStatus().equals(Constants.ACTIVE)) {
                    currentPriority++;
                }
            }

            tx.commit();
        }
        session.close();
    }

    private static List getSoftwarePriorityOrder(
            SoftwareCategory softwareCategory, List priorities, Session session) {

        priorities = session.getNamedQuery("softwarePriorityOrder").setEntity(
                "softwareCategory", softwareCategory).list();
        return priorities;
    }

    public static List getSoftwares() throws HibernateException, Exception {

        List softwares = null;

        Session session = getHibernateSession();

        softwares = getSoftwares(softwares, session);

        session.close();

        return softwares;
    }

    public static List getSoftwares(List results, Session session) {

        results = session.getNamedQuery("softwares").list();

        return results;
    }

    public static List getHistoryYears() throws HibernateException,
            NamingException {

        List years = null;

        Session session = getHibernateSession();

        years = session.getNamedQuery("softwareHistoryYears").list();

        session.close();

        return years;
    }

    public static List getHistoryMonths(String year) throws HibernateException,
            NamingException {

        List years = null;

        Session session = getHibernateSession();

        years = session.getNamedQuery("softwareHistoryMonths").setString(
                "year", year).list();

        session.close();

        return years;
    }

    public static List getHistoryByYearByMonth(String year, String month)
            throws HibernateException, NamingException {

        List years = null;

        Session session = getHibernateSession();

        years = session.getNamedQuery("softwareHistoryByYearByMonth")
                .setString("year", year).setString("month", month).list();

        session.close();

        return years;
    }

    
    /**
     * @@param software
     * @@return
     * @@throws HibernateException
     * @@throws Exception
     */
    public static boolean isSoftware(String softwareName)
            throws HibernateException, Exception {
        Software software = null;

        Session session = getHibernateSession();

        software = (Software) session.getNamedQuery("softwareByName")
                .setString("softwareName", softwareName).uniqueResult();

        session.close();

        if (software == null) {
            return false;
        }
        return true;
    }

}
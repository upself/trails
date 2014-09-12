/*
 * Created on Mar 29, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.manufacturer;

import java.util.List;
import com.ibm.asset.swkbt.domain.Manufacturer;
import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.hibernate.Session;

import com.ibm.tap.sigbank.framework.common.Delegate;

/**
 * @@author Thomas
 * 
 *         TODO To change the template for this generated type comment go to
 *         Window - Preferences - Java - Code Style - Code Templates
 */
public abstract class ManufacturerDelegate extends Delegate {

    /**
     * @@return
     * @@throws Exception
     * @@throws HibernateException
     * @@throws NamingException
     */
    public static List getManufacturers() throws HibernateException,
            NamingException {
        List list = null;
        Session session = getHibernateSession();
        try {
            list = session.getNamedQuery("manufacturers").list();
        } finally {
            session.close();
        }
        return list;
    }

    public static Manufacturer getManufacturer(String id)
            throws HibernateException, NamingException {

        Manufacturer manufacturer = null;

        Session session = getHibernateSession();

        manufacturer = getManufacturer(id, manufacturer, session);

        session.close();

        return manufacturer;
    }

    public static Manufacturer getManufacturer(String id, Manufacturer result,
            Session session) {

        result = (Manufacturer) session.getNamedQuery("manufacturerById")
                .setLong("manufacturerId", new Long(id).longValue())
                .uniqueResult();

        return result;
    }

    private static Manufacturer getManufacturerByName(String manufacturerName,
            Manufacturer manufacturerByName, Session session) {

        manufacturerByName = (Manufacturer) session.getNamedQuery(
                "manufacturerByName").setString("name", manufacturerName)
                .uniqueResult();

        return manufacturerByName;
    }
}
package com.ibm.batch;

import java.io.IOException;
import java.sql.SQLException;

import javax.naming.NamingException;
import javax.servlet.ServletException;

import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;
import org.hibernate.HibernateException;

import com.ibm.tap.misld.framework.Constants;

/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BatchPlugin implements PlugIn {

    private BatchProcessor batchProcessor = new BatchProcessor();

    public void destroy() {
        // Nothing for now
    }

    public void init(ActionServlet servlet, ModuleConfig config)
            throws ServletException {

        batchProcessor.start();

        servlet.getServletContext().setAttribute(Constants.BATCH_FACTORY_KEY,
                this);
    }

    public void addBatch(IBatch batch) throws HibernateException, SQLException,
            IOException, NamingException {
        batchProcessor.addQueue(batch);
    }

}
/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.batch;

import java.util.Date;

import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public interface IBatch {

    public boolean validate() throws Exception;

    public void execute() throws Exception;

    public void sendNotify();

    public void sendNotifyException(Exception e);

    public String getName();

    public String getRemoteUser();

    public Customer getCustomer();

    public void setBatchId(int id);

    public int getBatchId();

    public void setStartTime(Date date);
    
}
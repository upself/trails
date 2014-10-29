/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.framework.batch.email;

import java.util.Date;
import java.util.List;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public interface IBatchEmail {

    public List getToRecipients();

    public List getCcRecipients();

    public StringBuffer getContent();

    public String getSubject();

    public String getName();

    public Date getStartTime();

    public void setStartTime(Date date);

}
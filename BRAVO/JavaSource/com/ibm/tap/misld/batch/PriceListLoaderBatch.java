/*
 * Created on May 27, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.io.Serializable;
import java.util.Date;

import javax.mail.MessagingException;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.struts.upload.FormFile;

import com.ibm.batch.IBatch;
import com.ibm.tap.misld.delegate.microsoftPriceList.MicrosoftPriceListWriteDelegate;
import com.ibm.tap.misld.framework.exceptions.LoadException;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class PriceListLoaderBatch
        extends BatchBase implements IBatch, Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String   remoteUser;

    private FormFile file;

    private String   dir;

    public PriceListLoaderBatch(String remoteUser, String dir, FormFile file)
            throws Exception {

        super();

        this.remoteUser = remoteUser;
        this.file = file;
        this.dir = dir;
		setStartTime(new Date());
    }

    public boolean validate() throws Exception {
        return false;
    }

    public void execute() throws Exception {

        try {
            setFrom("PRICELIST-LOADER");
            setSubject("Upload at: " + new Date().toString());
            setTo(remoteUser);
        }
        catch (Exception e) {
            logMsg(e);
        }

        //MicrosoftPriceListWriteDelegate.clearPriceList();

        HSSFSheet sheet = getSheet(dir + file.getFileName());
        int endi = sheet.getLastRowNum();
        endi++;

        for (int i = 0; i < endi; i++) {
            HSSFRow row = sheet.getRow(i);

            try {
                int size = 9;

                MicrosoftPriceListWriteDelegate.loadPriceList(getStringFields(
                        row, sheet, size), remoteUser);
            }
            catch (NullPointerException e) {

                addBodyln((i + 1) + ": " + "Invalid Row");
            }
            catch (LoadException e) {
                addBodyln((i + 1) + ": " + e.getString());
            }
        }

    }

    public void sendNotify() {
        try {
            addBody("The Price List has been uploaded.");
            sendMsg(remoteUser);
        }
        catch (MessagingException e) {
            logMsg(e);
        }

    }

    public void sendNotifyException(Exception e) {
        try {
            addBodyln("An error cccurred in batch processing: " + e.toString());
            logger.error(e.toString(), e);
            sendMsg(remoteUser);
        }
        catch (MessagingException mailE) {
            logMsg(mailE);
        }
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.batch.IBatch#getName()
     */
    public String getName() {
        return "Price List Loader";
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.batch.IBatch#getRemoteUser()
     */
    public String getRemoteUser() {
        return remoteUser;
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.batch.IBatch#getCustomer()
     */
    public Customer getCustomer() {
        // TODO Auto-generated method stub
        return null;
    }
}
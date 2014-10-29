/*
 * Created on Jun 3, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.io.FileOutputStream;
import java.io.Serializable;
import java.util.Date;

import org.apache.poi.hssf.usermodel.HSSFWorkbook;

import com.ibm.batch.IBatch;
import com.ibm.tap.misld.delegate.purchaseOrderReport.PurchaseOrderReportReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.exceptions.EmailDeliveryException;
import com.ibm.tap.misld.om.cndb.Customer;

/**
 * @author Thomas
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class EsplaPoReportBatch
        extends BatchBase implements IBatch, Serializable {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String remoteUser = null;

    public EsplaPoReportBatch(String remoteUser) 
    
    	throws EmailDeliveryException {

        super();

        this.remoteUser = remoteUser;
		setStartTime(new Date());
    }

    public boolean validate() throws Exception {
        return false;
    }

    public void execute() throws Exception {
    }

    public void sendNotify() {

        String reportTemplateFilename = null;

        reportTemplateFilename = "Po_Report.xls";

        try {
            setFrom("ESPLA-PO-REPORT");
            setSubject("Espla PO Report");
            setTo(remoteUser);
        }
        catch (Exception e) {
            logMsg(e);
        }
        try {
            XlsReport xlsReport = new XlsReport(reportTemplateFilename, null, null);

            xlsReport.setXlsReport(PurchaseOrderReportReadDelegate.getPoReport(
                    Constants.ESPLA, remoteUser));

            XlsReportGenerator xlsReportGenerator = new XlsReportGenerator();
            HSSFWorkbook wb = xlsReportGenerator.buildXlsReport(xlsReport);

            if (wb != null) {
                FileOutputStream fileOut = null;
                String fileOutName = "espla_po_report.xls";

                fileOut = new FileOutputStream(Constants.SPREAD_IN
                        + fileOutName);
                wb.write(fileOut);
                fileOut.close();

                addBody("Espla PO report is attached below.");
                addAttachment(Constants.SPREAD_IN + fileOutName);
                sendMsg(remoteUser);
            }
        }
        catch (Exception e) {
            e.printStackTrace();
            logMsg(e);
        }
    }

    public void sendNotifyException(Exception e) {
        logger.debug(e, e);
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.batch.IBatch#getName()
     */
    public String getName() {
        return "Espla PO Report";
    }

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.batch.IBatch#getRemoteUser()
     */
    public String getRemoteUser() {
        return remoteUser;
    }

    /* (non-Javadoc)
     * @see com.ibm.batch.IBatch#getCustomer()
     */
    public Customer getCustomer() {
        // TODO Auto-generated method stub
        return null;
    }
}
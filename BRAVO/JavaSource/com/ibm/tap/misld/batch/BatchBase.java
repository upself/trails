/*
 * Created on May 26, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.Date;
import java.util.Properties;

import javax.activation.DataHandler;
import javax.activation.FileDataSource;
import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Multipart;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.AddressException;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeBodyPart;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMultipart;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.exceptions.EmailDeliveryException;

/**
 * @author newtont
 * 
 *         To change the template for this generated type comment go to
 *         Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class BatchBase {

    private int                 batchId;

    private Message             msg;

    private Session             session;

    private Properties          props;

    private StringBuffer        body      = new StringBuffer();

    private MimeBodyPart        attachment;

    private NumberFormat        formatter = new DecimalFormat("#.##");

    private Date                startTime;

    protected static final Logger logger    = Logger.getLogger(BatchBase.class);

    public BatchBase() throws EmailDeliveryException {
        // TODO LOW put this in a config file
        props = System.getProperties();
        props.put("mail.smtp.host", "relay.us.ibm.com");
        session = Session.getInstance(props, null);
        msg = new MimeMessage(session);
        try {
            Transport.send(msg);
            // If default MX, relay.ibm.com fails, try individual servers of
            // backup MX, NA.relay.ibm.com. LK-31791-06032009
        } catch (Exception mailE) {
            try {
                // KJN 10/1/09
                props.put("mail.smtp.host", "d01av01.pok.ibm.com");
                Transport.send(msg);
            } catch (Exception mailE2) {
                // Try using another server
                try {
                    props.put("mail.smtp.host", "d01av02.pok.ibm.com");
                    Transport.send(msg);
                } catch (Exception mailE3) {
                    // Try using another server
                    try {
                        props.put("mail.smtp.host", "d01av03.pok.ibm.com");
                        Transport.send(msg);
                    } catch (Exception mailE4) {
                        try {
                            // Try using another server
                            props.put("mail.smtp.host", "d01av04.pok.ibm.com");
                            Transport.send(msg);
                        } catch (Exception mailE5) {
                            // Try using another server
                            try {
                                props.put("mail.smtp.host",
                                        "d03av01.boulder.ibm.com");
                                Transport.send(msg);
                            } catch (Exception mailE6) {
                                try {
                                    // Try using another server
                                    props.put("mail.smtp.host",
                                            "d03av02.boulder.ibm.com");
                                    Transport.send(msg);
                                } catch (Exception mailE7) {
                                    try {
                                        // Try using another server
                                        props.put("mail.smtp.host",
                                                "d03av04.boulder.ibm.com");
                                        Transport.send(msg);
                                    } catch (Exception mailE8) {
                                        // throw new EmailDeliveryException();
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }

    }

    protected void setTo(String remoteUser) throws AddressException,
            MessagingException {

        msg.setRecipients(Message.RecipientType.TO, InternetAddress.parse(
                remoteUser, false));
    }

    protected void setSubject(String subject) throws MessagingException {
        msg.setSubject(subject);

    }

    protected void setFrom(String from) throws AddressException,
            MessagingException {
        msg.setFrom(new InternetAddress(from + Constants.EMAIL_DOMAIN_SUFFIX));
    }

    protected void addBody(String bodyPart) {
        body.append(bodyPart);
    }

    protected void addBodyln(String bodyPart) {
        body.append(bodyPart + "\n");
    }

    public void sendMsg(String remoteUser) throws MessagingException {

        // create and fill the first message part
        MimeBodyPart mbp1 = new MimeBodyPart();
        addBody("\n\n\n");
        mbp1.setText(body.toString());

        msg.setHeader("X-Mailer", "msgsend");
        msg.setSentDate(new Date());

        msg.setText(body.toString());
        Multipart mp = new MimeMultipart();
        mp.addBodyPart(mbp1);

        if (attachment != null) {
            // create the Multipart and add its parts to it
            mp.addBodyPart(attachment);
        }

        // add the Multipart to the message
        msg.setContent(mp);

        // set the Date: header
        msg.setSentDate(new Date());

        // send the message
        logger.debug("sending right now....................");
        try {
            Transport.send(msg);
        } catch (Exception mailE) {
            // Try one more time, mail relay times out a lot
            Transport.send(msg);
        }
    }

    public void logMsg(Exception e) {
        try {
            logger.warn("An error occurred that required logging in the "
                    + "batch system.");

            logger.warn("Error is: " + e.toString());
            logger.warn("Going to: " + msg.getFrom());
            logger.warn("Message was: " + body.toString());
            logger.error(e, e);
        } catch (Exception e1) {
            logger.error("error when trying to log error message");
        }

    }

    protected HSSFSheet getSheet(String fileName) throws IOException,
            FileNotFoundException {

        logger.debug("getting POI fs");
        POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(fileName));
        logger.debug("getting WorkBook");
        return new HSSFWorkbook(fs).getSheetAt(0);
    }

    protected void addAttachment(String fileName) throws MessagingException {

        this.attachment = new MimeBodyPart();
        FileDataSource fds = new FileDataSource(fileName);

        this.attachment.setDataHandler(new DataHandler(fds));
        this.attachment.setFileName(fds.getName());

        logger.debug("Adding attchment: ");
        logger.debug("fileName: " + fileName);
        logger.debug("getContentID: " + this.attachment.getContentID());
        logger.debug("getContentType: " + this.attachment.getContentType());
        logger.debug("getDescription: " + this.attachment.getDescription());
        logger.debug("getDisposition: " + this.attachment.getDisposition());
        logger.debug("getEncoding: " + this.attachment.getEncoding());
        logger.debug("getFileName: " + this.attachment.getFileName());
    }

    public String[] getStringFields(HSSFRow row, HSSFSheet sheet, int size) {

        String[] fields = new String[size];

        for (int j = 0; j < size; j++) {
            HSSFCell cell = row.getCell((short) j);

            int cellType;

            if (cell == null) {
                cellType = HSSFCell.CELL_TYPE_BLANK;
            } else {
                cellType = cell.getCellType();
            }

            String value = null;

            if (cellType == HSSFCell.CELL_TYPE_BLANK) {
                value = "";
            } else if (cellType == HSSFCell.CELL_TYPE_BOOLEAN) {
                value = cell.getBooleanCellValue() + "";
            } else if (cellType == HSSFCell.CELL_TYPE_ERROR) {
                value = "";
            } else if (cellType == HSSFCell.CELL_TYPE_FORMULA) {
                value = "";
            } else if (cellType == HSSFCell.CELL_TYPE_NUMERIC) {
                value = formatter.format(cell.getNumericCellValue());
            } else if (cellType == HSSFCell.CELL_TYPE_STRING) {
                value = cell.getStringCellValue();
            }

            fields[j] = value.trim();
        }

        return fields;
    }

    public String[] getStringFields(String row) {

        String patternStr = "	";
        String[] fields = row.split(patternStr);

        return fields;
    }

    /**
     * @return Returns the startDate.
     */
    public Date getStartTime() {
        return startTime;
    }

    /**
     * @param startDate
     *            The startDate to set.
     */
    public void setStartTime(Date startTime) {
        this.startTime = startTime;
    }

    /**
     * @return Returns the batchId.
     */
    public int getBatchId() {
        return batchId;
    }

    /**
     * @param batchId
     *            The batchId to set.
     */
    public void setBatchId(int batchId) {
        this.batchId = batchId;
    }
}
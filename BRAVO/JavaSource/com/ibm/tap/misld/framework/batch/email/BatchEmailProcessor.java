package com.ibm.tap.misld.framework.batch.email;

import java.util.Arrays;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Properties;
import java.util.Timer;
import java.util.TimerTask;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.servlet.ServletException;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionServlet;
import org.apache.struts.action.PlugIn;
import org.apache.struts.config.ModuleConfig;

import com.ibm.tap.misld.framework.Constants;

public class BatchEmailProcessor
        extends TimerTask implements PlugIn {
    /**
     * Logger for this class
     */
    private static final Logger logger     = Logger
                                                   .getLogger(BatchEmailProcessor.class);

    private Timer               timer      = new Timer();

    private BatchEmailQueue     queue      = new BatchEmailQueue();

    private static Properties   properties = new Properties();

    // initialize the properties object with the SNMP hsot information
    static {
        properties.setProperty(Constants.EMAIL_SNMP_HOST_KEY,
                Constants.EMAIL_SNMP_HOST_VALUE);
    }

    // init is called when the Plugin initializes
    public void init(ActionServlet servlet, ModuleConfig config)
            throws ServletException {

        // start up the timer to execute the EmailProcessor's run method at the
        // given frequency
        timer.scheduleAtFixedRate(this, Constants.EMAIL_PLUGIN_DELAY_SECS,
                Constants.EMAIL_PLUGIN_PERIOD_SECS);
    }

    // destroy is called when the Plugin is destroyed
    public void destroy() {
        // kill the timer thread
        logger.debug(new Date() + " kill EmailProcessor timer");
        timer.cancel();
    }

    // run is called for each execution of the timer
    public void run() {
        IBatchEmail email;

        // loop through the items in the queue
        while ((email = queue.popEmail()) != null) {

            // create a session
            Session session = Session.getDefaultInstance(properties);

            try {
                // verify the recipients
                if (email.getToRecipients() == null)
                    throw new Exception("missing recipients");

                // create and populate the message
                Message message = new MimeMessage(session);
                message.setSubject(email.getSubject());
                message.setText(email.getContent().toString());

                // populate the To recipients
                Iterator i = email.getToRecipients().iterator();
                while (i.hasNext()) {
                    String recipient = (String) i.next();
                    message.addRecipient(Message.RecipientType.TO,
                            new InternetAddress(recipient));
                }

                // populate the Cc recipients
                Iterator c = email.getCcRecipients().iterator();
                while (c.hasNext()) {
                    String recipient = (String) c.next();
                    message.addRecipient(Message.RecipientType.CC,
                            new InternetAddress(recipient));
                }
                
                // populate the sender
                message.setFrom(new InternetAddress(
                        Constants.EMAIL_ADDRESS_FROM));

                // populate the date
                message.setSentDate(new Date());

                // send the message
                StringBuffer recipients = new StringBuffer();
                List recipientList = Arrays.asList(message.getAllRecipients());
                if (recipientList != null) {
                    Iterator j = recipientList.iterator();
                    while (j.hasNext()) {
                        InternetAddress address = (InternetAddress) j.next();
                        recipients.append(address.getAddress() + " ");
                    }
                }

                logger.info("subject = " + message.getSubject());
                logger.info("recipients " + recipients);
                Transport.send(message);

            }
            catch (MessagingException e) {
                // if we get a MessagingException add the email back to the
                // queue and continue
                queue.addEmail(email);
                logger.error("run()", e);

            }
            catch (Exception e) {
                // error something wrong with email
                logger.error("run()", e);
            }
        }
    }
}
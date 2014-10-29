package com.ibm.tap.misld.quartz.jobs;

import java.util.Calendar;
import java.util.Date;
import java.util.List;
import java.util.ListIterator;

import javax.naming.NamingException;

import org.hibernate.HibernateException;
import org.quartz.Job;
import org.quartz.JobExecutionContext;
import org.quartz.JobExecutionException;

import com.ibm.ea.cndb.Contact;
import com.ibm.tap.delegate.acl.BluegroupsDelegate;
import com.ibm.tap.misld.delegate.notification.NotificationReadDelegate;
import com.ibm.tap.misld.framework.Constants;
import com.ibm.tap.misld.framework.Util;
import com.ibm.tap.misld.framework.email.EmailDelegate;
import com.ibm.tap.misld.om.cndb.Customer;
import com.ibm.tap.misld.om.customerSettings.MisldAccountSettings;
import com.ibm.tap.misld.om.notification.Notification;
import com.ibm.tap.misld.report.PriceReportDelegate;

public class DailyPriceReportEscalationJob implements Job {

    public DailyPriceReportEscalationJob() {
    }

    public void execute(JobExecutionContext context) throws JobExecutionException {
    	
    	try {
    			System.out.println("In DailyPriceReportEscalationJob - executing its JOB at " 
    					+ new Date() + " by " + context.getTrigger().getName());
    
    			checkPriceReportsForEscalation();
    			
    	} catch (Exception e) {
            System.out.println(" DailyPriceReportEscalationJob error = " + e);
        }
    }
    
    private void checkPriceReportsForEscalation() throws HibernateException,
		NamingException, Exception {
    	
    	List notifications = null;
    	Notification notification = new Notification();
    	
		notifications = NotificationReadDelegate.
							  getNotificationsByTypeStatus(Constants.PRICE_REPORT,
														 Constants.ACTIVE);

		if (notifications != null) {
			//TestNotificationLists(notifications);
			
			ListIterator notificationIterator = notifications.listIterator();
			Customer customer = new Customer();
			Customer [] c = new Customer[1];
			String [] toUsers = new String[1];							
			String [] ccUsers = new String[3];
			MisldAccountSettings misldAccountSettings = new MisldAccountSettings();
			String priceReportStatus = null;
			
			Contact custDpe = new Contact();
			Contact dpe = new Contact();
			String dpe_serial = null;
			String dpe_email = null;
			Contact manager = new Contact();
			String manager_serial = null;
			String manager_email = null;
			
			String notifier_email = null;
			String notifier = null;
			int commaPos = 0;
			int spacePos = 0;
			String firstName = null;
			String lastName = null;
			
	        Calendar notifDtCal = Calendar.getInstance();
			Date currentDate = new Date();
	        Calendar currDtCal = Calendar.getInstance();
	        currDtCal.setTime(currentDate);
			
			int businessDays = 0;
		
			while(notificationIterator.hasNext()) {
				notification = (Notification)notificationIterator.next();			
				notifier_email = notification.getRemoteUser();
				Date notificationDate = (Date)notification.getRecordTime();
		        notifDtCal.setTime(notificationDate);
				customer = notification.getCustomer();
				misldAccountSettings = customer.getMisldAccountSettings();
				priceReportStatus = misldAccountSettings.getPriceReportStatus();
				
				if (!priceReportStatus.equals(Constants.APPROVED) &&
					!priceReportStatus.equals(Constants.REJECTED) &&
					!priceReportStatus.equals(Constants.PAST_DUE)) {
					
					businessDays = Util.calculateBusinessDays(notifDtCal, currDtCal);
					
					//if price report has not been approved after 5 business days
					//send escalation email to DPE and their manager and set
					//the price report status to E - Escalated
					if (businessDays > 5 && //businessDays < 9 && 
							!priceReportStatus.equals(Constants.ESCALATED)) {
					
						PriceReportDelegate.updatePriceReportStatus(customer, Constants.ESCALATED, "PRICE REPORT ESCALATION JOB");
					
						// Wizard customer table stores the DPE serial# but not the DPE's manager's serial so
						// first the DPE serial needs to be obtained from the customer record and then
						// a bluepages look up is done to get the manager's serial#
						custDpe = customer.getContactDPE();
						dpe_serial = custDpe.getSerial();
						dpe = BluegroupsDelegate.getContactByLongSerial(dpe_serial);
						dpe_email = dpe.getRemoteUser();
						if(!customer.getAccountNumber().equals(new Long(35400)))//if this is the test account 35400, then do not send to manager
							manager_serial = dpe.getManagerSerial();

						if (manager_serial != null) {
							manager = BluegroupsDelegate.getContactByLongSerial(manager_serial);
							manager_email = manager.getRemoteUser();
						}
						
						Contact notifierContact = new Contact();
						notifierContact = BluegroupsDelegate.getContactByEmail(notifier_email);
						notifier = notifierContact.getFullName();
						commaPos = notifier.indexOf(",");
						firstName = notifier.substring(commaPos+2);
						spacePos = firstName.indexOf(" ");
						firstName = firstName.substring(0,spacePos);
						lastName = notifier.substring(0, commaPos);
						notifier = firstName + " " + lastName;
						
						c[0] = customer;
					
						toUsers[0] = manager_email;
				
						
						if (!notifier_email.equals("srednick@us.ibm.com")) {
							ccUsers[0] = dpe_email;
							ccUsers[1] = notifier_email;
							ccUsers[2] = "srednick@us.ibm.com";
						} else {
							ccUsers[0] = dpe_email;
							ccUsers[1] = "srednick@us.ibm.com";
						}
						
						PriceReportDelegate.sendNotifications(c, "mswiz@tap.raleigh.ibm.com", notifier, 
																toUsers, ccUsers, Constants.ESCALATION);
				
					}
					//if it has been more than 8 days, set the price report status
					//to P - Past Due
					if (businessDays > 8 && priceReportStatus.equals(Constants.ESCALATED)) {
					
						PriceReportDelegate.updatePriceReportStatus(customer, Constants.PAST_DUE, "PRICE REPORT ESCALATION JOB");
					
					}
				}
			}
		}
    }
    
    private void TestNotificationLists(List notifications) throws HibernateException,
	NamingException, Exception {
    	
    	Notification notification = new Notification();
		ListIterator notificationIterator = notifications.listIterator();
    
		StringBuffer content = new StringBuffer();
		Customer customer = new Customer();
		Contact dpe = new Contact();
		String dpe_serial = null;
		String dpe_email = null;
		Contact manager = new Contact();
		String manager_serial = null;
		String manager_email = null;
		String subject = "Test notification lists";
		
		while(notificationIterator.hasNext()) {
			notification = (Notification)notificationIterator.next();	
			customer = notification.getCustomer();
			content.append("Customer = " + customer.getCustomerName() + " " + customer.getAccountNumber() + "\n");
			content.append("-------------------------------------------------------------------------------\n");
				
			// Wizard customer table stores the DPE serial# but not the DPE's manager's serial so
			// first the DPE serial needs to be obtained from the customer record and then
			// a bluepages look up is done to get the manager's serial#
			dpe = customer.getContactDPE();
			dpe_serial = dpe.getSerial();
			dpe = BluegroupsDelegate.getContactByLongSerial(dpe_serial);
			dpe_email = dpe.getRemoteUser();
			content.append("DPE = " + dpe_serial + " " + dpe_email + "\n");
			
			manager_serial = dpe.getManagerSerial();
			manager = BluegroupsDelegate.getContactByShortSerial(manager_serial);
			manager_email = manager.getRemoteUser();
			content.append("Manager = " + manager_serial + " " + manager_email + "\n\n\n");
					
		}
		
		EmailDelegate.sendMessage(subject, "kneikirk@us.ibm.com", content);
			
    }
    
}


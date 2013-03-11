package com.ibm.ea.bravo.contact;

import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.apache.log4j.Logger;
import org.apache.struts.action.ActionForm;
import org.apache.struts.action.ActionForward;
import org.apache.struts.action.ActionMapping;

import com.ibm.ea.bluepages.DelegateBluePages;
import com.ibm.ea.bravo.account.DelegateAccount;
import com.ibm.ea.bravo.framework.common.ActionBase;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.hardware.DelegateHardware;
import com.ibm.ea.bravo.hardware.Hardware;
import com.ibm.ea.bravo.hardware.HardwareLpar;
import com.ibm.ea.cndb.Customer;
import com.ibm.ea.utils.EaUtils;

public class ActionContact extends ActionBase {

	private static final Logger logger = Logger.getLogger(ActionContact.class);

	public ActionForward home(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionMachineType.home");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		logger.debug("ActionContact.edit");

		long contactId = 0;

		String id = getParameter(request, Constants.ID);
		String custid = getParameter(request, Constants.CUSTOMER_ID);
		String email = getParameter(request, Constants.EMAIL);
		String context = getParameter(request, Constants.CONTEXT);
		String accountid = getParameter(request, Constants.ACCOUNT_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		logger.debug("CONTEXT = " + context);

		if (!EaUtils.isBlank(id)) {
			contactId = Long.parseLong(id);
		}
		long customerId = Long.parseLong(custid);
		logger.debug("ActionContact.edit id=" + id);
		
		if ( EaUtils.isBlank(lparName)) {
			logger.debug("LparNmae is null  " + lparName);
			request.setAttribute(Constants.CUSTOMER_ID, custid);
			request.setAttribute(Constants.CONTEXT, context);
			request.setAttribute(Constants.ACCOUNT_ID, accountid);
			return mapping.findForward(Constants.ERROR);
		}

		if (!EaUtils.isBlank(id)) {
			// doing a delete

			if (context.equalsIgnoreCase(Constants.ACCOUNT)) {

				// create our AccountContact Object
				AccountContact contact = new AccountContact();
				String image = Constants.IMAGE_DELETE;

				// Get our object and delete it
				logger.debug("ActionContact.Edit delete Account customerId = "
						+ customerId);
				logger.debug("ActionContact.Edit delete Account customerId = "
						+ contactId);

				contact = (AccountContact) DelegateContact.getAccountContact(
						customerId, contactId);
				DelegateContact.deleteAccountContact(contact);

				// create the object and then populate it with our results
				List<AccountContact> list = DelegateContact.getAccountContacts(customerId);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.IMAGETAG, image);

				return mapping.findForward(Constants.SUCCESS);
			} else if (context.equalsIgnoreCase(Constants.LPAR)) {
				// create our AccountContact Object
				LparContact contact = new LparContact();
				String image = Constants.IMAGE_DELETE;

				// Get our Hardware_Lpar_ID
				HardwareLpar hardware = new HardwareLpar();
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());

				// Get our object and delete it
				contact = (LparContact) DelegateContact.getLparContact(
						contactId, hwlparid);
				DelegateContact.deleteLparContact(contact);

				// create the object and then populate it with our results
				List<LparContact> list = DelegateContact.getLparContacts(hwlparid);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.IMAGETAG, image);
				return mapping.findForward(Constants.SUCCESS);

			} else if (context.equalsIgnoreCase(Constants.HDW)) {
				// create our AccountContact Object
				HardwareContact contact = new HardwareContact();
				String image = Constants.IMAGE_DELETE;

				// Get our Hardware_Lpar_ID
				HardwareLpar hardware = new HardwareLpar();
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());
				long hdwId = Long.parseLong(hardware.getHardware().getId()
						.toString());

				// Get our object and delete it
				contact = (HardwareContact) DelegateContact.getHardwareContact(
						contactId, hdwId);
				DelegateContact.deleteHardwareContact(contact);

				// create the object and then populate it with our results
				List<HardwareContact> list = DelegateContact.getHardwareContacts(hdwId);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, String
						.valueOf(hwlparid));
				request.setAttribute(Constants.ID, String.valueOf(hdwId));
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.IMAGETAG, image);
				return mapping.findForward(Constants.SUCCESS);
			} else {
				return mapping.findForward(Constants.ERROR);

			}
		} else {
			// inserting a record
			logger.debug("ActionContact.edit insert");
			String image = Constants.IMAGE_DELETE;

			// inserting
			// create the object and then populate it with our results
			ContactSupport supportcontact = new ContactSupport();
			AccountContact contact = new AccountContact();
			Customer customer = new Customer();

			// get our bluepages info and automatically update/refresh the data
			supportcontact = DelegateBluePages.getContact(email,
					Constants.INTERNET);
			supportcontact.setId(null);

			// save our new blue pages updates
			if (context.equalsIgnoreCase(Constants.ACCOUNT)) {
				Integer supportcount = (Integer) DelegateContact
						.getSupportCount(email);
				int cnt = supportcount.intValue();

				// save new contact if it doesn't already exist
				// and also retrieve the object
				if (cnt >= 1) {
					supportcontact = (ContactSupport) DelegateContact
							.getContact(email);
					customer = (Customer) DelegateAccount.getAccount(accountid,
							request).getCustomer();
				} else {
					DelegateContact.saveContact(supportcontact);
					supportcontact = (ContactSupport) DelegateContact
							.getContact(email);
					customer = (Customer) DelegateAccount.getAccount(accountid,
							request).getCustomer();
				}

				// set our contactId
				id = supportcontact.getId().toString();
				contactId = Long.parseLong(id);

				// Get our count for
				Integer accountcount = (Integer) DelegateContact
						.getAccountCount(contactId, customerId);
				cnt = accountcount.intValue();

				if (cnt >= 1) {
					// don't do anything because the record already exists
				} else {
					// it doesn't exist, so lets save it
					AccountContact acontact = new AccountContact();
					acontact.setCustomer(customer);
					acontact.setContact(supportcontact);
					acontact.setId(null);
					acontact.setRemoteUser(request.getRemoteUser());

					DelegateContact.saveAccountContact(acontact);

				}

				// refresh our account_contact object
				// and pass back to our details page
				contact = (AccountContact) DelegateContact.getAccountContact(
						customerId, contactId);
				accountid = contact.getCustomer().getAccountNumber().toString();
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT, contact);

				// create the object and then populate it with our results
				List<AccountContact> list = DelegateContact.getAccountContacts(customerId);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);
			} else if (context.equalsIgnoreCase(Constants.LPAR)) {
				// LPAR

				HardwareLpar hardware = new HardwareLpar();

				Integer supportcount = (Integer) DelegateContact
						.getSupportCount(email);
				int cnt = supportcount.intValue();

				// save new contact if it doesn't already exist
				// and also retrieve the object
				if (cnt >= 1) {
					supportcontact = (ContactSupport) DelegateContact
							.getContact(email);
				} else {
					DelegateContact.saveContact(supportcontact);
					supportcontact = (ContactSupport) DelegateContact
							.getContact(email);
				}

				// set our contactId
				id = supportcontact.getId().toString();
				contactId = Long.parseLong(id);

				logger.debug("hw = ");

				// create our Hardware object
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());

				// Get our count for
				logger.debug("getLparCount");
				Integer lparcount = (Integer) DelegateContact.getLparCount(
						contactId, hwlparid);
				cnt = lparcount.intValue();
				logger.debug("lparcount = " + String.valueOf(cnt));

				if (cnt >= 1) {
					// don't do anything because the record already exists
				} else {
					// it doesn't exist, so lets save it
					LparContact acontact = new LparContact();
					acontact.setContact(supportcontact);
					acontact.setHardwareLpar(hardware);
					acontact.setRemoteUser(request.getRemoteUser());
					acontact.setId(null);

					DelegateContact.saveLparContact(acontact);

				}

				// refresh our account_contact object
				// and pass back to our details page
				logger.debug("About to fill our AccountContact object");
				// contact =
				// (AccountContact)DelegateContact.getAccountContact(customerId,
				// contactId);
				// accountid =
				// contact.getCustomer().getAccountNumber().toString();
				// request.setAttribute(Constants.ACCOUNT_ID, accountid);
				// request.setAttribute(Constants.CONTACT, contact);
				logger.debug("accountid = " + accountid);

				// create the object and then populate it with our results
				List<LparContact> list = DelegateContact.getLparContacts(hwlparid);

				logger.debug("context = " + context);
				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);

			} else if (context.equalsIgnoreCase(Constants.HDW)) {
				// LPAR

				HardwareLpar hardware = new HardwareLpar();

				Integer supportcount = (Integer) DelegateContact
						.getSupportCount(email);
				int cnt = supportcount.intValue();

				// save new contact if it doesn't already exist
				// and also retrieve the object
				if (cnt >= 1) {
					supportcontact = (ContactSupport) DelegateContact
							.getContact(email);
				} else {
					DelegateContact.saveContact(supportcontact);
					supportcontact = (ContactSupport) DelegateContact
							.getContact(email);
				}

				// set our contactId
				id = supportcontact.getId().toString();
				contactId = Long.parseLong(id);

				logger.debug("hw = ");

				// create our Hardware object
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());
				long hdwId = Long.parseLong(hardware.getHardware().getId()
						.toString());

				Hardware hdw = new Hardware();
				hdw = (Hardware) DelegateHardware.getHardware(hdwId);

				// Get our count for
				logger.debug("getHardwareCount");
				Integer hardwarecount = (Integer) DelegateContact
						.getHardwareCount(contactId, hdwId);
				cnt = hardwarecount.intValue();
				logger.debug("lparcount = " + String.valueOf(cnt));

				if (cnt >= 1) {
					// don't do anything because the record already exists
				} else {
					// it doesn't exist, so lets save it
					HardwareContact acontact = new HardwareContact();
					acontact.setContact(supportcontact);
					acontact.setHardware(hdw);
					acontact.setRemoteUser(request.getRemoteUser());
					acontact.setId(null);

					DelegateContact.saveHardwareContact(acontact);

				}

				// refresh our account_contact object
				// and pass back to our details page
				logger.debug("About to fill our AccountContact object");
				// contact =
				// (AccountContact)DelegateContact.getAccountContact(customerId,
				// contactId);
				// accountid =
				// contact.getCustomer().getAccountNumber().toString();
				// request.setAttribute(Constants.ACCOUNT_ID, accountid);
				// request.setAttribute(Constants.CONTACT, contact);
				logger.debug("accountid = " + accountid);

				// create the object and then populate it with our results
				List<HardwareContact> list = DelegateContact.getHardwareContacts(hdwId);

				logger.debug("context = " + context);
				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, String
						.valueOf(hwlparid));
				request.setAttribute(Constants.ID, String.valueOf(hdwId));
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);

			} else {
				return mapping.findForward(Constants.ERROR);

			}
		}

	}

	public ActionForward view(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// from this screen users can view the details of the record
		// like machine type details.jsp but can not do anything else
		// accept update the database with blue pages info

		String id = getParameter(request, Constants.ID);
		String custid = getParameter(request, Constants.CUSTOMER_ID);
		String context = getParameter(request, Constants.CONTEXT);
		String account_id = getParameter(request, Constants.ACCOUNT_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		long contactId = Long.parseLong(id);
		long customerId = Long.parseLong(custid);
		logger.debug("ActionContact.view id=" + id);
		logger.debug("ActionContact.view custid=" + custid);

		if (!EaUtils.isBlank(id)) {

			if (context.equalsIgnoreCase(Constants.ACCOUNT)) {
				// create the object and then populate it with our results
				AccountContact contact = new AccountContact();
				contact = (AccountContact) DelegateContact.getAccountContact(
						customerId, contactId);

				String accountid = contact.getCustomer().getAccountNumber()
						.toString();
				logger.debug("ActionContact.view accountid=" + accountid);

				request.setAttribute(Constants.ID, id);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT, contact);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);
			} else if (context.equalsIgnoreCase(Constants.LPAR)) {
				// create the object and then populate it with our results
				HardwareLpar hardware = new HardwareLpar();
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, account_id, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());

				LparContact contact = new LparContact();
				contact = (LparContact) DelegateContact.getLparContact(
						contactId, hwlparid);

				logger.debug("ActionContact.view accountid=" + account_id);

				request.setAttribute(Constants.ID, id);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, account_id);
				request.setAttribute(Constants.CONTACT, contact);

				logger.debug("ActionContact.view context=" + context);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);

			} else if (context.equalsIgnoreCase(Constants.HDW)) {
				// create the object and then populate it with our results
				// I have my contact id but I need my hardware ID
				// so I will get that from HardwareLpar
				HardwareLpar hardwarelpar = new HardwareLpar();
				hardwarelpar = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, account_id, request);
				long hwlparid = Long.parseLong(hardwarelpar.getId().toString());
				long hdwId = Long.parseLong(hardwarelpar.getHardware().getId()
						.toString());

				HardwareContact contact = new HardwareContact();
				contact = (HardwareContact) DelegateContact.getHardwareContact(
						contactId, hdwId);

				logger.debug("ActionContact.view accountid=" + account_id);
				logger.debug("ActionContact.view hardwareId=" + hdwId);
				logger.debug("ActionContact.view hardwareId=" + hwlparid);

				request.setAttribute(Constants.ID, String.valueOf(hdwId));
				request.setAttribute(Constants.LPAR_ID, String
						.valueOf(hwlparid));
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, account_id);
				request.setAttribute(Constants.CONTACT, contact);

				logger.debug("ActionContact.view context=" + context);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);

			} else {

				return mapping.findForward(Constants.ERROR);

			}

		}

		return mapping.findForward(Constants.ERROR);

	}

	public ActionForward refresh(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		// from this screen users can view the details of the record
		// like machine type details.jsp but can not do anything else
		// accept update the database with blue pages info
		long contactId = 0;
		long customerId = 0;

		String id = getParameter(request, Constants.ID);
		String custid = getParameter(request, Constants.CUSTOMER_ID);
		String email = getParameter(request, Constants.EMAIL);
		String context = getParameter(request, Constants.CONTEXT);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		String accountid = getParameter(request, Constants.ACCOUNT_ID);
		String image = Constants.IMAGE_DELETE;
		logger.debug("ActionContact.refresh got our parameters");
		logger.debug("ActionContact.refresh got our parameters - accountid = "
				+ accountid);

		if (!EaUtils.isBlank(id)) {
			contactId = Long.parseLong(id);
		}
		if (!EaUtils.isBlank(custid)) {
			customerId = Long.parseLong(custid);
		}

		logger.debug("ActionContact.refresh id=" + id);

		if (!EaUtils.isBlank(id)) {

			logger.debug("ActionContact.refresh single user - context = "
					+ context);

			if (context.equalsIgnoreCase(Constants.ACCOUNT)) {

				// create the object and then populate it with our results
				ContactSupport supportcontact = new ContactSupport();
				AccountContact contact = new AccountContact();

				// get our bluepages info and automatically update/refresh the
				// data
				supportcontact = DelegateBluePages.getContact(email,
						Constants.INTERNET);
				supportcontact.setId(Long.valueOf(id));

				// save our new blue pages updates
				DelegateContact.refreshContact(supportcontact);

				// refresh our account_contact object
				// and pass back to our details page
				contact = (AccountContact) DelegateContact.getAccountContact(
						customerId, contactId);
				accountid = contact.getCustomer().getAccountNumber().toString();
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT, contact);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);
			} else if (context.equalsIgnoreCase(Constants.LPAR)) {
				// create the object and then populate it with our results
				ContactSupport supportcontact = new ContactSupport();
				HardwareLpar hardware = new HardwareLpar();
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());

				// get our bluepages info and automatically update/refresh the
				// data
				supportcontact = DelegateBluePages.getContact(email,
						Constants.INTERNET);
				supportcontact.setId(Long.valueOf(id));

				// save our new blue pages updates
				DelegateContact.refreshContact(supportcontact);

				// refresh our account_contact object
				// and pass back to our details page
				LparContact contact = new LparContact();
				contact = (LparContact) DelegateContact.getLparContact(
						contactId, hwlparid);

				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT, contact);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);
			} else if (context.equalsIgnoreCase(Constants.HDW)) {
				// create the object and then populate it with our results
				logger.debug("ActionContact.refresh Hardware Context");
				ContactSupport supportcontact = new ContactSupport();
				HardwareLpar hardware = new HardwareLpar();
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());
				long hdwId = Long.parseLong(hardware.getHardware().getId()
						.toString());
				logger.debug("ActionContact.refresh hwlparid =" + hwlparid);
				logger.debug("ActionContact.refresh hdwId =" + hdwId);

				// get our bluepages info and automatically update/refresh the
				// data
				supportcontact = DelegateBluePages.getContact(email,
						Constants.INTERNET);
				supportcontact.setId(Long.valueOf(id));

				// save our new blue pages updates
				DelegateContact.refreshContact(supportcontact);

				// refresh our account_contact object
				// and pass back to our details page
				HardwareContact contact = new HardwareContact();
				contact = (HardwareContact) DelegateContact.getHardwareContact(
						contactId, hdwId);
				logger.debug("ActionContact.refresh contact info = "
						+ contact.getContact().getName());

				request.setAttribute(Constants.ID, String.valueOf(hdwId));
				request.setAttribute(Constants.LPAR_ID, String
						.valueOf(hwlparid));
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT, contact);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);
			} else {
				return mapping.findForward(Constants.ERROR);

			}

		} else {
			logger.debug("ActionContact.refresh multiple users");

			if (context.equalsIgnoreCase(Constants.ACCOUNT)) {
				// we are updating all contacts for this account
				// create the object and then populate it with our results

				// create the object and then populate it with our results
				// create our Hardware object
				List<AccountContact> list = DelegateContact.getAccountContacts(customerId);

				if (list != null) {
					Iterator<AccountContact> i = list.iterator();
					while (i.hasNext()) {
						// now we will refresh all contacts
						AccountContact contact = (AccountContact) i.next();
						email = contact.getContact().getEmail();
						id = contact.getContact().getId().toString();
						accountid = contact.getCustomer().getAccountNumber()
								.toString();
						logger
								.debug("ActionContact.refresh - email = "
										+ email);
						logger.debug("ActionContact.refresh - account id = "
								+ accountid);

						ContactSupport supportcontact = new ContactSupport();
						supportcontact = DelegateBluePages.getContact(email,
								Constants.INTERNET);
						supportcontact.setId(Long.valueOf(id));

						// save our new blue pages updates
						DelegateContact.refreshContact(supportcontact);

					}
				}

				list = DelegateContact.getAccountContacts(customerId);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.LIST);

			} else if (context.equalsIgnoreCase(Constants.LPAR)) {

				// create the object and then populate it with our results

				HardwareLpar hardware = new HardwareLpar();
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());
				List<LparContact> list = DelegateContact.getLparContacts(hwlparid);

				if (list != null) {
					Iterator<LparContact> i = list.iterator();
					while (i.hasNext()) {
						// now we will refresh all contacts
						LparContact contact = (LparContact) i.next();
						email = contact.getContact().getEmail();
						id = contact.getContact().getId().toString();
						logger
								.debug("ActionContact.refresh - email = "
										+ email);
						logger.debug("ActionContact.refresh - account id = "
								+ accountid);

						ContactSupport supportcontact = new ContactSupport();
						supportcontact = DelegateBluePages.getContact(email,
								Constants.INTERNET);
						supportcontact.setId(Long.valueOf(id));

						// save our new blue pages updates
						DelegateContact.refreshContact(supportcontact);

					}
				}

				list = DelegateContact.getLparContacts(hwlparid);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.IMAGETAG, image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.LIST);
			} else if (context.equalsIgnoreCase(Constants.HDW)) {

				// create the object and then populate it with our results

				HardwareLpar hardwarelpar = new HardwareLpar();
				hardwarelpar = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardwarelpar.getId().toString());
				long hdwId = Long.parseLong(hardwarelpar.getHardware().getId()
						.toString());
				List<HardwareContact> list = DelegateContact.getHardwareContacts(hdwId);

				if (list != null) {
					Iterator<HardwareContact> i = list.iterator();
					while (i.hasNext()) {
						// now we will refresh all contacts
						HardwareContact contact = (HardwareContact) i.next();
						email = contact.getContact().getEmail();
						id = contact.getContact().getId().toString();
						logger
								.debug("ActionContact.refresh - email = "
										+ email);
						logger.debug("ActionContact.refresh - account id = "
								+ accountid);

						ContactSupport supportcontact = new ContactSupport();
						supportcontact = DelegateBluePages.getContact(email,
								Constants.INTERNET);
						supportcontact.setId(Long.valueOf(id));

						// save our new blue pages updates
						DelegateContact.refreshContact(supportcontact);

					}
				}

				list = DelegateContact.getHardwareContacts(hdwId);
				logger.debug("ActionContact.refresh List list size = "
						+ list.size());

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, String
						.valueOf(hwlparid));
				request.setAttribute(Constants.ID, String.valueOf(hdwId));
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.IMAGETAG, image);

				return mapping.findForward(Constants.LIST);

			} else {
				return mapping.findForward(Constants.ERROR);

			}

		}

	}

	public ActionForward quicksearch(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionMachineType.quicksearch");

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward search(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionContact.search");

		List<ContactSupport> list = null;

		String custid = getParameter(request, Constants.CUSTOMER_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		String lparId = getParameter(request, Constants.LPAR_ID);
		String context = getParameter(request, Constants.CONTEXT);
		String accountid = getParameter(request, Constants.ACCOUNT_ID);
		String search = getParameter(request, Constants.SEARCH);
		String action = getParameter(request, Constants.ACTION);
		String image = Constants.IMAGE_ADD;

		// now we need to do a search based on the value presented
		list = DelegateBluePages.findContact(search, action);
		logger.debug("ActionContact.search list size = " + list.size());

		request.setAttribute(Constants.LPAR_ID, lparId);
		request.setAttribute(Constants.LPAR_NAME, lparName);
		request.setAttribute(Constants.CUSTOMER_ID, custid);
		request.setAttribute(Constants.CONTEXT, context);
		request.setAttribute(Constants.ACCOUNT_ID, accountid);
		request.setAttribute(Constants.CONTACT_LIST, list);
		request.setAttribute(Constants.IMAGETAG, image);

		return mapping.findForward(Constants.SUCCESS);
	}

	public ActionForward create(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionContact.create");

		String custid = getParameter(request, Constants.CUSTOMER_ID);
		String context = getParameter(request, Constants.CONTEXT);
		String accountid = getParameter(request, Constants.ACCOUNT_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		String image = Constants.IMAGE_ADD;
		String lpar_id = "";
       
		if ( EaUtils.isBlank(lparName)) {
			logger.debug("LparNmae is null  " + lparName);
			request.setAttribute(Constants.CUSTOMER_ID, custid);
			request.setAttribute(Constants.CONTEXT, context);
			request.setAttribute(Constants.ACCOUNT_ID, accountid);
			return mapping.findForward(Constants.ERROR);
		}

		
		if (context.equalsIgnoreCase(Constants.HDW)) {
			// get the lparId
			HardwareLpar hardwarelpar = new HardwareLpar();
			hardwarelpar = (HardwareLpar) DelegateHardware.getHardwareLpar(
					lparName, accountid, request);
			long hwlparid = Long.parseLong(hardwarelpar.getId().toString());
			lpar_id = String.valueOf(hwlparid);

		}

		logger.debug("ActionContact.create id=" + custid);

		// fill our request attributes to populate our objects
		request.setAttribute(Constants.LPAR_ID, lpar_id);
		request.setAttribute(Constants.LPAR_NAME, lparName);
		request.setAttribute(Constants.CUSTOMER_ID, custid);
		request.setAttribute(Constants.CONTEXT, context);
		request.setAttribute(Constants.ACCOUNT_ID, accountid);
		request.setAttribute(Constants.CONTACT_LIST, null);
		request.setAttribute(Constants.IMAGETAG, image);

		// return the form in the request
		// and set our title, buttons, etc...
		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward update(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionContact.update");

		String id = getParameter(request, Constants.ID);
		String custid = getParameter(request, Constants.CUSTOMER_ID);
		String context = getParameter(request, Constants.CONTEXT);
		String accountid = getParameter(request, Constants.ACCOUNT_ID);
		String lparName = getParameter(request, Constants.LPAR_NAME);
		String image = Constants.IMAGE_DELETE;

		// long contactId = Long.parseLong(id);
		long customerId = Long.parseLong(custid);

		logger.debug("ActionContact.update id=" + custid);
		
		if ( EaUtils.isBlank(lparName)) {
			logger.debug("LparNmae is null  " + lparName);
			request.setAttribute(Constants.CUSTOMER_ID, custid);
			request.setAttribute(Constants.CONTEXT, context);
			request.setAttribute(Constants.ACCOUNT_ID, accountid);
			return mapping.findForward(Constants.ERROR);
		}


		if (!EaUtils.isBlank(custid)) {

			if (context.equalsIgnoreCase(Constants.ACCOUNT)) {
				// create the object and then populate it with our results
				List<AccountContact> list = DelegateContact.getAccountContacts(customerId);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.IMAGETAG, image);
				logger.debug("ActionContact.Update image = " + image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);
			} else if (context.equalsIgnoreCase(Constants.LPAR)) {
				// create the object and then populate it with our results
				HardwareLpar hardware = new HardwareLpar();
				hardware = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardware.getId().toString());
				List<LparContact> list = DelegateContact.getLparContacts(hwlparid);

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.LPAR_ID, "");
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.IMAGETAG, image);
				logger.debug("ActionContact.Update image = " + image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);

			} else if (context.equalsIgnoreCase(Constants.HDW)) {
				// create the object and then populate it with our results
				long hardwareId = Long.parseLong(id);
				HardwareLpar hardwarelpar = new HardwareLpar();
				hardwarelpar = (HardwareLpar) DelegateHardware.getHardwareLpar(
						lparName, accountid, request);
				long hwlparid = Long.parseLong(hardwarelpar.getId().toString());
				long hdwId = Long.parseLong(hardwarelpar.getHardware().getId()
						.toString());

				// Now I can get my Hardware object
				List<HardwareContact> list = DelegateContact.getHardwareContacts(hdwId);

				logger.debug("ActionContact.update hdwId = "
						+ String.valueOf(hdwId));
				logger.debug("ActionContact.update hardwareId = "
						+ String.valueOf(hardwareId));

				// fill our request attributes to populate our objects
				request.setAttribute(Constants.ID, String.valueOf(hdwId));
				request.setAttribute(Constants.LPAR_ID, String
						.valueOf(hwlparid));
				request.setAttribute(Constants.CUSTOMER_ID, custid);
				request.setAttribute(Constants.CONTEXT, context);
				request.setAttribute(Constants.ACCOUNT_ID, accountid);
				request.setAttribute(Constants.CONTACT_LIST, list);
				request.setAttribute(Constants.LPAR_NAME, lparName);
				request.setAttribute(Constants.IMAGETAG, image);
				logger.debug("ActionContact.Update image = " + image);

				// return the form in the request
				// and set our title, buttons, etc...
				return mapping.findForward(Constants.SUCCESS);

			} else {
				return mapping.findForward(Constants.ERROR);

			}

		}

		return mapping.findForward(Constants.ERROR);

	}

	public ActionForward cancel_edit(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {

		logger.debug("ActionMachineType.delete");

		return mapping.findForward(Constants.SUCCESS);

	}

	public ActionForward delete(ActionMapping mapping, ActionForm form,
			HttpServletRequest request, HttpServletResponse response)
			throws Exception {
		logger.debug("ActionMachineType.delete");

		return mapping.findForward(Constants.ERROR);

	}

}

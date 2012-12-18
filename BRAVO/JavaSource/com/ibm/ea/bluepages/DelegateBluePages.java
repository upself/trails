package com.ibm.ea.bluepages;

import java.util.Date;
import java.util.Hashtable;
import java.util.LinkedList;
import java.util.List;

import org.apache.log4j.Logger;

import com.ibm.bluepages.BPResults;
import com.ibm.bluepages.BluePages;
import com.ibm.ea.bravo.contact.ContactSupport;
import com.ibm.ea.bravo.framework.common.Constants;

public abstract class DelegateBluePages {

	private static final Logger logger = Logger
			.getLogger(DelegateBluePages.class);

	/**
	 * @param custId
	 * @return
	 */
	@SuppressWarnings("unchecked")
    public static ContactSupport getContact(String search, String type)
			throws Exception {

		BPResults results = null; // Results of BluePages method
		int i;
		Hashtable<String, String> row;
		String name = "";
		String serial = "";
		String email = "";
		String cnum = "";
		String isMgr = "N";

		String[] managers = new String[3];

		logger.debug("DelegateBluePages.getContact");
		logger.debug("DelegateBluePages.getContact search = " + search);
		logger.debug("DelegateBluePages.getContact type = " + type);

		ContactSupport contact = new ContactSupport();

		// get main information
		if (type.equalsIgnoreCase(Constants.INTERNET)) {
			results = BluePages.getPersonsByInternet(search);
		}

		if (type.equalsIgnoreCase(Constants.SERIAL)) {
			results = BluePages.getPersonsBySerial(search);
		}

		if (results.rows() == 0) {
		} else {
			for (i = 0; i < results.rows(); i++) {
				row = results.getRow(i);

				name = (String) row.get("NAME");
				serial = (String) row.get("EMPNUM");
				email = (String) row.get("INTERNET");
				cnum = (String) row.get("CNUM"); // This is the Unique Serial
													// Number CC+SERIAL
				isMgr = (String) row.get("MGR");

			}
		}

		// Now Get Mgr Chain
		results = BluePages.getMgrChainOf(cnum);
		if (results.rows() == 0) {
		} else {
			for (i = 0; i < results.rows(); i++) {
				if (i > 2) {

				} else {
					row = results.getRow(i);
					managers[i] = (String) row.get("EMPNUM");
				}
			}
		}

		logger.debug("DelegateBluePages.getContact - mgr3 = " + managers[2]);
		contact.setName(name);
		contact.setSerial(serial);
		contact.setEmail(email);
		if (isMgr.equalsIgnoreCase(Constants.N)) {
			contact.setSerialMgr1(managers[0]);
			contact.setSerialMgr2(managers[1]);
			contact.setSerialMgr3(managers[2]);
		} else {
			contact.setSerialMgr1(serial);
			contact.setSerialMgr2(managers[0]);
			contact.setSerialMgr3(managers[1]);
		}
		contact.setIsManager(isMgr);
		contact.setRemoteUser("screeley@us.ibm.com");
		contact.setStatus(Constants.ACTIVE);
		contact.setRecordTime(new Date());
		logger.debug("DelegateBluePages.getContact - remoteUser = "
				+ contact.getRemoteUser());

		return contact;

	}

	@SuppressWarnings("unchecked")
    public static List<ContactSupport> findContact(String search, String type) throws Exception {
		LinkedList<ContactSupport> listlink = new LinkedList<ContactSupport>();

		BPResults results = null; // Results of BluePages method
		BPResults results2 = null; // Results of BluePages method
		int i;
		Hashtable<String, String> row;
		Hashtable<String, String> row2;
		String name = "";
		String serial = "";
		String email = "";
		String cnum = "";
		String isMgr = "N";
		String[] managers = new String[3];

		logger.debug("DelegateBluePages.findContact");
		logger.debug("DelegateBluePages.findContact search = " + search);
		logger.debug("DelegateBluePages.findContact type = " + type);

		// get main information
		if (type.equalsIgnoreCase(Constants.INTERNET)) {
			results = BluePages.getPersonsByInternet(search);
		}

		if (type.equalsIgnoreCase(Constants.SERIAL)) {
			results = BluePages.getPersonsBySerial(search);
		}

		if (type.equalsIgnoreCase(Constants.NAME)) {
			results = BluePages.getPersonsByName(search);
		}

		if (results.rows() == 0) {
		} else {
			for (i = 0; i < results.rows(); i++) {
				row = results.getRow(i);

				logger.debug("DelegateBluePages.findContact new object ");
				ContactSupport contact = new ContactSupport();

				name = (String) row.get("NAME");
				serial = (String) row.get("EMPNUM");
				email = (String) row.get("INTERNET");
				cnum = (String) row.get("CNUM"); // This is the Unique Serial
													// Number CC+SERIAL
				isMgr = (String) row.get("MGR");

				// Now Get Mgr Chain
				results2 = BluePages.getMgrChainOf(cnum);
				if (results2.rows() == 0) {
				} else {
					for (int j = 0; j < results2.rows(); j++) {
						if (j > 2) {

						} else {
							row2 = results2.getRow(j);
							managers[j] = (String) row2.get("EMPNUM");
						}
					}
				}

				logger.debug("DelegateBluePages.findContact name = " + name);
				contact.setName(name);
				contact.setSerial(serial);
				contact.setEmail(email);
				if (isMgr.equalsIgnoreCase(Constants.N)) {
					contact.setSerialMgr1(managers[0]);
					contact.setSerialMgr2(managers[1]);
					contact.setSerialMgr3(managers[2]);
				} else {
					contact.setSerialMgr1(serial);
					contact.setSerialMgr2(managers[0]);
					contact.setSerialMgr3(managers[1]);
				}
				contact.setIsManager(isMgr);
				contact.setRemoteUser("screeley@us.ibm.com");
				contact.setStatus(Constants.ACTIVE);
				contact.setRecordTime(new Date());
				logger.debug("DelegateBluePages.findContact contact object = "
						+ contact);

				logger
						.debug("DelegateBluePages.findContact about to add to our list");
				listlink.add(contact);
				// arraylist.add((ContactSupport)contact);
				// logger.debug("DelegateBluePages.findContact list size = " +
				// list.size());

			}
		}

		return listlink;

	}

}
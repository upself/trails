/*
 * Created on Jan 19, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.misld.framework;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Constants {

	//General Constants
	public static final String VERSION = "2.4.0";
	
	public static final String USER_CONTAINER = "user.container";

	public static final String CONF_DIR = "/opt/bravo/conf";

	public static final String PROPERTIES = "/bravo.properties";

	public static final String ERROR_DIR = "/opt/IBMIHS/htdocs/en_US/uploadReport";

	public static final String PAGINATION = "pagination";

	//Mapping Constants
	public static final String ERROR = "error";

	public static final String SUCCESS = "success";

	public static final String HOME = "home";

	public static final String ACCESS = "access";

	//BlueGroups Constants
	public static final String GROUP_ADMIN = "com.ibm.tap.admin";

	public static final String CUSTOMER_LIST = "customer.list";

	public static final String PRICE_REPORTS_LIST = "priceReports.list";

	public static final String HARDWARE_LIST = "hardware.list";

	public static final String SOFTWARE_LIST = "software.list";

	public static final String LOCKED = "LOCKED";

	public static final String HIBERNATE_PROPERTIES = CONF_DIR
			+ "/hibernate.properties";

	public static final String GROUP_ASSET = "com.ibm.tap.asset";

	public static final String GROUP_MISLD_ADMIN = "com.ibm.tap.misld.admin";

	public static final String AGREEMENT_TYPE_LIST = "agreementType.list";

	public static final String NEXT = "next";

	public static final String SCAN = "SCAN";

	public static final String REGISTRATION_REPORT = "registrationReport";

	public static final String GROUP_MISLD_PREFIX = "com.ibm.tap.misld.";

	public static final String POD_LIST = "pod.list";

	public static final int BLUEGROUP_SUBDEPTH = 4;

	public static final String COMPLETE = "COMPLETE";
	
	public static final String REGISTERED = "REGISTERED";

	public static final String SPREAD_IN = "/var/misld/spreadIn/";

	public static final String REGISTRATION = "registration";

	public static final String INACTIVE = "INACTIVE";

	public static final String SPLA = "SPLA";

	public static final String BLUEPAGES = "bluepages.ibm.com";

	public static final String PRICE_REPORT_NOTIFICATION = "priceReportNotification";

	public static final String BLUEGROUPS = "bluegroups.ibm.com";

	public static final String CANCEL = "cancel";

	public static final String DRAFT = "DRAFT";

	public static final String CUSTOMER = "CUSTOMER";

	//Status Constants
	public static final String NEW = "NEW";

	public static final String ESPLA = "ESPLA";

	public static final String SETTINGS = "settings";

	public static final String ESPLA_ENROLLMENT_FORM = "ESPLA ENROLLMENT FORM";

	public static final String ACCOUNT_LOCK_STATUS = "accountLockStatus";

	public static final String ACTIVE = "ACTIVE";

	public static final String CLOSED = "CLOSED";

	public static final String REJECTED = "REJECTED";

	public static final String ESCALATED = "ESCALATED";

	public static final String ESCALATION = "ESCALATION";

	public static final String SW_ANALYST_APPROVAL = "SW_ANALYST_APPROVAL";

	public static final String PAST_DUE = "PAST DUE";

	public static final String VIEW = "view";

	public static final String ARCHIVED = "ARCHIVED";

	public static final String CUSTOMER_AGREEMENT_LIST = "customer.agreement.list";

	public static final String APPROVED = "APPROVED";
	
	public static final String PO_ENTERED = "PO ENTERED";
	
	public static final String MOET_ACCEPTED = "MOET ACCEPTED";

	public static final String OPERATING_SYSTEMS = "Operating Systems";

	//Email Batch Constants
	public static final String EMAIL_PROCESSOR_KEY = "batch.email.processor";

	public static final String CONSENT_LIST = "consent.list";

	public static final String EMAIL_SNMP_HOST_KEY = "mail.smtp.host";

	public static final String EMAIL_SNMP_HOST_VALUE = "na.relay.ibm.com";

	public static final String EMAIL_ADDRESS_FROM = "mswiz@tap.raleigh.ibm.com";

	public static final int EMAIL_PLUGIN_DELAY_SECS = 15 * 1000;

	public static final int EMAIL_PLUGIN_PERIOD_SECS = 15 * 1000;

	public static final String EMAIL_DOMAIN_SUFFIX = "@tap.raleigh.ibm.com";

	//Navigation Constants
	public static final String PATH = "/BRAVO";

	//Batch Constants
	public static final String BATCH_FACTORY_KEY = "batch.factory";

	public static final String SELECT = "SELECT";

	public static final String PRELOAD = "PRELOADED/SHRINK WRAPPED/OPEN LICENSE";

	public static final Object ENTERPRISE = "ENTERPRISE";

	public static final String SELECT_HOSTING = "SELECT HOSTING VERIFICATION FORM";

	public static final String ENTERPRISE_HOSTING = "ENTERPRISE HOSTING VERIFICATION FORM";

	public static final String PRO_FORMA = "PRO FORMA CONSENT";

	public static final String IBM = "IBM";

	public static final String SELECT_OUTSOURCER = "SELECT OUTSOURCER ENROLLMENT AGREEMENT";

	public static final String ENTERPRISE_OUTSOURCER = "ENTERPRISE OUTSOURCER ENROLLMENT AGREEMENT";

	public static final String BOTH = "BOTH";

	public static final String MANUAL = "MANUAL";

	public static final String USER_LICENSE_TYPE = "SUBSCRIBER ACCESS LICENSES (SAL)";

	public static final String PROCESSOR_BASED_LICENSE = "PROCESSOR LICENSES (PL)";

	public static final String NO_OPERATING_SYSTEM = "NO OPERATING SYSTEM";

	public static final String ONDEMAND = "ONDEMAND";

	public static final String ARCHIVE = "ARCHIVE";

	public static final String PRICE_REPORT = "PRICE REPORT";

	public static final String POD = "pod";

}
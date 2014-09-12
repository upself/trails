/*
 * Created on Jan 19, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.common;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Constants {

	// Configuration Constatns
	public static final String CONF_DIR = "/opt/sigbank/conf";

	public static final String APP_PROPERTIES = CONF_DIR
			+ "/sigbank.properties";

	public static final String HIBERNATE_PROPERTIES = CONF_DIR
			+ "/hibernate.properties";

	public static final String VAR_DIR = "/var/sigbank";

	public static final String HIBERNATE_SCHEMA = "/var/sigbank/project-schema.sql";

	public static final String BATCH_FACTORY_KEY = "batch.factory";

	// Data constants
	public static final String ACTIVE = "ACTIVE";

	public static final String INACTIVE = "INACTIVE";

	public static final String ALERT = "ALERT";

	public static final String ALL = "ALL";

	public static final String DISCONNECTED = "DISCONNECTED";

	public static final String CONNECTED = "CONNECTED";

	public static final String CUSTOMER_NAME = "Customer Name";
	
	public static final String CONFIDENTIAL = "IBM Confidential";

	public static final String ACCOUNT_NUMBER = "Account Number";

	public static final String ID = "id";

	public static final String BANK_ACCOUNT_BEAN = "bankAccount";

	public static final String MANUFACTURER_BEAN = "manufacturer";

	public static final String SOFTWARE_BEAN = "software";

	public static final String SOFTWARE_CATEGORY_BEAN = "softwareCategory";

	public static final String USER_CONTAINER_BEAN = "userContainer";

	public static final String SOFTWARE_FILTER_BEAN = "softwareFilter";

	public static final String SOFTWARE_SIGNATURE_BEAN = "softwareSignature";

	public static final String MANUFACTURERS = "manufacturers";

	public static final String SOFTWARES = "softwares";

	public static final String SOFTWARE_CATEGORYS = "softwareCategories";

	public static final String UNKNOWN = "UNKNOWN";

	public static final String CUSTOMER_SEARCH = "customerSearch";

	public static final String SOFTWARE_CATEGORY_ID = "softwareCategoryId";

	public static final String MANUFACTURER_ID = "manufacturerId";

	public static final String NONE = "NONE";

	public static final String UNLICENSABLE = "UN-LICENSABLE";

	public static final String DELIM_TSV = "\t";

	public static final int SIG_LOADER_COLUMN_LENGTH = 5;

	public static final int EMAIL_PLUGIN_DELAY_SECS = 15 * 1000;

	public static final int EMAIL_PLUGIN_PERIOD_SECS = 15 * 1000;

	public static final String INACTIVE_SIGNATURE = "inactiveSoftwareSignature";

	public static final String EMAIL_ADDRESS_FROM = "tap@tap.raleigh.ibm.com";

	public static final String[] OS_TYPES = { "JVM", "OS/400", "Unix", "Windows" };

	// Common Navigation Constants
	public static final String USER_CONTAINER = "user.container";

	public static final String VIEW = "view";

	public static final String GLOBAL_HOME = "GLOBAL_HOME";

	public static final String FORM = "form";

	public static final String SUCCESS = "success";

	public static final String ERROR = "error";

	public static final String REPORT = "report";

	public static final String SEARCH = "Search";

	public static final String CANCELED = "canceled";

	public static final int MAX_RESULTS = 15;

	public static final String EDIT = "edit";

	// Bluegroup Constants
	public static final String BLUEPAGES = "bluepages.ibm.com";

	public static final String BLUEGROUPS = "bluegroups.ibm.com";

	public static final int BLUEGROUP_SUBDEPTH = 4;

	public static final String GROUP_ADMIN = "com.ibm.tap.admin";

	public static final String GROUP_ASSET = "com.ibm.tap.asset";

	public static final String GROUP_SIGBANK_ADMIN = "com.ibm.tap.sigbank.admin";

	public static final String GROUP_SIGBANK_USER = "com.ibm.tap.sigbank.user";

	public static final String GROUP_SIGBANK_READER = "com.ibm.tap.sigbank.reader";

	public static final String ICON_SYSTEM_STATUS_OK = "http://w3.ibm.com/ui/v8/images/icon-system-status-ok.gif";

	public static final String ICON_SYSTEM_STATUS_NA = "http://w3.ibm.com/ui/v8/images/icon-system-status-na.gif";

	public static final String ICON_SYSTEM_STATUS_ALERT = "http://w3.ibm.com/ui/v8/images/icon-system-status-alert.gif";

	public static final String PATH = "/SignatureBank";
	
	public static final String PRODUCTS = "products";

	public static final String PAGINATION = "pagination";

	public static final String EMAIL_DOMAIN_SUFFIX = "@tap.raleigh.ibm.com";
}

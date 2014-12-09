package com.ibm.asset.trails.service.impl;

import java.io.OutputStream;
import java.io.PrintWriter;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Iterator;

import javax.persistence.EntityManager;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.hibernate.HibernateException;
import org.hibernate.ScrollMode;
import org.hibernate.ScrollableResults;
import org.hibernate.Session;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.DataExceptionTypeEnum;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.DatabaseDeterminativeService;
import com.ibm.asset.trails.service.ReportService;

@Service
public class ReportServiceImpl implements ReportService {
	private final String[] ALERT_VALID_CAUSE_CODE_HEADERS = { "Alert Type",
			"Cause Code (CC)", "Responsibility" };
	private final String[] ALERT_EXPIRED_MAINT_REPORT_COLUMN_HEADERS = {
			"Status", "Product name", "Total qty", "Expiration date",
			"SWCM ID", "Create date/time", "Age", "Assignee",
			"Assignee comments", "Assigned date/time" };
	private final String ALERT_EXPIRED_MAINT_REPORT_NAME = "Expired maintenance alert report";
	private final String ALERT_EXPIRED_SCAN_REPORT_NAME = "Outdated SW LPAR alert report";
	private final String[] ALERT_HARDWARE_LPAR_REPORT_COLUMN_HEADERS = {
			"Status", "Hostname", "Serial", "Machine type", "Asset type",
			"Create date/time", "Age", "Assignee", "Assignee comments",
			"Assigned date/time", "Cause Code (CC)", "CC target date",
			"CC owner", "CC change date", "CC change person", "Internal ID" };
	private final String ALERT_HARDWARE_LPAR_REPORT_NAME = "HW LPAR w/o SW LPAR alert report";
	private final String[] ALERT_HARDWARE_REPORT_COLUMN_HEADERS = { "Status",
			"Serial", "Machine type", "Asset type", "Create date/time", "Age",
			"Assignee", "Assignee comments", "Assigned date/time",
			"Cause Code (CC)", "CC target date", "CC owner", "CC change date",
			"CC change person", "Internal ID" };
	private final String ALERT_HARDWARE_REPORT_NAME = "HW w/o HW LPAR alert report";
	private final String ALERT_SOFTWARE_LPAR_REPORT_NAME = "SW LPAR w/o HW LPAR alert report";
	private final String[] ALERT_SW_LPAR_REPORT_COLUMN_HEADERS = { "Status",
			"Hostname", "Bios serial", "Create date/time", "Age", "Assignee",
			"Assignee comments", "Assigned date/time", "Cause Code (CC)",
			"CC target date", "CC owner", "CC change date", "CC change person",
			"Internal ID" };
	private final String ACCOUNT_DATA_EXCEPTIONS_REPORT_NAME = "Account Data Exceptions report";
	private final String ALERT_UNLICENSED_IBM_SW_REPORT_NAME = "Unlicensed IBM SW alert report";
	private final String ALERT_UNLICENSED_ISV_SW_REPORT_NAME = "Unlicensed ISV SW alert report";
	private final String[] ACCOUNT_DATA_EXCEPTIONS_REPORT_SWLPAR_COLUMN_HEADERS = {
			"DATA EXCEPTION TYPE", "HOST NAME", "SCAN TIME", "CREATION TIME",
			"BIOS SERIAL", "OS NAME", "ASSIGNEE", "COMMENT" };
	private final String[] ACCOUNT_DATA_EXCEPTIONS_REPORT_HWLPAR_COLUMN_HEADERS = {
			"DATA EXCEPTION TYPE", "HOST NAME", "SERIAL", "CREATION TIME",
			"HW PROCESSORS", "HW EXT ID", "HW CHIPS", "ASSIGNEE", "COMMENT" };
	private final String[] ALERT_UNLICENSED_SW_REPORT_COLUMN_HEADERS = {
			"Status", "Hostname", "Installed SW product name", "Number of instances",
			"Create date/time", "Age", "Cause Code (CC)", "CC target date",
			"CC owner", "CC change date", "CC change person", "Internal ID" };
	private final String FREE_LICENSE_POOL_REPORT_NAME = "Free license pool report";
	private final String[] FULL_RECONCILIATION_REPORT_COLUMN_HEADERS = {
			"Alert status", "Alert opened", "Alert duration", "SW LPAR name",
			"HW serial", "HW machine type","CPU Model","CHASSIS ID","Cloud Name",
			"Owner", "Country", "Asset type","Server type","SPLA","Virtual Flag","Virtual Mobility restriction",
			"SysPlex","Cluster type","Backup method", "Internet ACC Flag","Capped LPAR", "Processor Type",
			"Processor Manufacturer", "Processor Model", "NBR Cores per Chip",
			"NBR of Chips Max","Shared processor", "CPU IBM LSPR MIPS", "CPU Gartner MIPS",
			"CPU MSU", "Part IBM LSPR MIPS", "Part Gartner MIPS", "Part MSU",
			"SHARED", "Hardware Status", "Lpar Status",
			"Physical HW processor count", "Physical chips",
			"Effective processor count","Effective threads","PVU/core",
			"Installed SW product name", "SW Owner", "Alert assignee",
			"Alert assignee comment", "Inst SW manufacturer",
			"Inst SW validation status", "Reconciliation action", "Allocation methodology", 
			"Reconciliation user", "Reconciliation date/time",
			"Reconciliation comments", "Reconciliation parent product",
			"License account number", "Full product description",
			"Catalog match", "License product name", "Version",
			"Capacity type","Environment", "Quantity used", "Machine level",
			"Maintenance expiration date", "PO number",
			"License serial number", "License owner", "SWCM ID",
			"License last updated" };
	private final String FULL_RECONCILIATION_REPORT_NAME = "Full reconciliation report";
	private final String[] HARDWARE_BASELINE_COLUMN_HEADERS = { "Serial",
			"Machine type", "Hostname", "Asset type", "Server type", "SPLA", "SysPlex",
			"Internet ACC Flag", "Processor Type", "Processor Manufacturer",
			"Processor Model", "NBR Cores per Chip", "NBR of Chips Max",
			"SHARED", "Hardware Status", "Lpar Status", "Composite" };
	private final String HARDWARE_BASELINE_REPORT_NAME = "Hardware baseline report";
	private final String[] INSTALLED_SOFTWARE_BASELINE_COLUMN_HEADERS = {
			"Software product name", "Manufacturer", "Vendor managed",
			"Hostname", "Bios serial", "Processor count", "Chips", "Scan time",
			"Composite", "Serial", "Machine type", "Asset type" };
	private final String INSTALLED_SOFTWARE_BASELINE_REPORT_NAME = "Installed software baseline report";
	private final String LICENSE_BASELINE_REPORT_NAME = "License baseline report";
	private final String[] LICENSE_COLUMN_HEADERS = { "Product name",
			"Catalog match", "Full product description", "Capacity type",
			"Environment","Total qty", "Available qty", "Expiration date", "PO number",
			"Serial number", "License owner", "SWCM ID", "Pool",
			"Record date/time" };
	private final String NON_WORKSTATION_ACCOUNTS_REPORT_NAME = "Non-workstation accounts with workstations report";
	private final String[] NON_WORKSTATION_ACCOUNTS_REPORT_COLUMN_HEADERS = {
			"Account #", "Account name", "Account type", "Geography", "Region",
			"Country", "Sector", "Workstation count", "HW status" };
	private final String[] PENDING_CUSTOMER_DECISION_DETAIL_COLUMN_HEADERS = {
			"Software product name", "Hostname", "Action performed",
			"Create date/time", "Recon date/time", "Recon user" };
	private final String PENDING_CUSTOMER_DECISION_DETAIL_REPORT_NAME = "Customer owned and IBM managed detail report";
	private final String[] PENDING_CUSTOMER_DECISION_SUMMARY_COLUMN_HEADERS = {
			"Software product name", "Action performed", "Total",
			"0 - 45 days", "46 - 90 days", "91 - 120 days", "121 - 180 days",
			"181 - 365 days", "Over 365 days" };
	private final String PENDING_CUSTOMER_DECISION_SUMMARY_REPORT_NAME = "Customer owned and IBM managed summary report";
	private final String[] RECONCILIATION_SUMMARY_COLUMN_HEADERS = {
			"Product name", "Installed instances",
			"Installed instances covered by entitlement",
			"Installed instances not covered by entitlement",
			"Unassigned license pool count", "Unassigned license pool type" };
	private final String RECONCILIATION_SUMMARY_REPORT_NAME = "Reconciliation summary report";
	private final String[] SOFTWARE_COMPLIANCE_SUMMARY_COLUMN_HEADERS = {
			"Product name", "Installed instances",
			"Installed instances covered by entitlement",
			"Installed instances not covered by entitlement",
			"License pool type", "Unassigned license pool count",
			"Assigned license pool count" };
	private final String SOFTWARE_COMPLIANCE_SUMMARY_REPORT_NAME = "Software compliance summary report";
	private final String[] SOFTWARE_LPAR_BASELINE_COLUMN_HEADERS = {
			"Hostname", "Bios serial", "Processor count", "Scan time",
			"Composite", "Serial", "Machine type", "Asset type" };
	private final String SOFTWARE_LPAR_BASELINE_REPORT_NAME = "Software LPAR baseline report";
	private final String[] SOFTWARE_VARIANCE_REPORT_COLUMN_HEADERS = {
			"Product name", "Installed instances", "Scope software title" };
	private final String SOFTWARE_VARIANCE_REPORT_NAME = "Contract scope to installed software variance report";
	private final String SQL_QUERY_SW_LPAR = "SELECT CASE WHEN VA.Alert_Age > 90 THEN 'Red' WHEN VA.Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END, SL.Name, SL.Bios_Serial, VA.Creation_Time, VA.Alert_Age, VA.Remote_User, VA.Comments, VA.Record_Time , AC.name as ac_name, CC.target_date,CC.owner as cc_owner,CC.record_time as cc_record_time,CC.remote_user as cc_remote_user, CC.id as cc_id  FROM EAADMIN.V_Alerts VA, EAADMIN.Software_Lpar SL, EAADMIN.cause_code CC, EAADMIN.alert_cause AC WHERE VA.Customer_Id = :customerId AND VA.Type = :type AND VA.Open = 1 AND SL.Id = VA.FK_Id and VA.id=CC.alert_id and CC.alert_type_id = :alertTypeId and CC.alert_cause_id=AC.id ORDER BY SL.Name ASC";
	private final String SQL_QUERY_UNLICENSED_SW = "SELECT CASE WHEN Alert_Age > 90 THEN 'Red' WHEN Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END, Software_Lpar_Name, Software_Item_Name, Alert_Count, Creation_Time, Alert_Age, ac_name, target_date, cc_owner, cc_record_time, cc_remote_user, cc_id FROM (SELECT MAX(DAYS(CURRENT TIMESTAMP) - DAYS(VA.Creation_Time)) AS Alert_Age, SL.Name AS Software_Lpar_Name, S.software_name AS Software_Item_Name, COUNT(*) AS Alert_Count, MIN(VA.Creation_Time) AS Creation_Time, VA.ac_name as ac_name, CC.target_date,CC.owner as cc_owner,CC.record_time as cc_record_time,CC.remote_user as cc_remote_user, CC.id as cc_id FROM EAADMIN.V_Alerts VA, EAADMIN.software  S, EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS , EAADMIN.cause_code CC, EAADMIN.Software_Lpar SL WHERE VA.Customer_Id = :customerId AND VA.Type = :type AND VA.Open = 1 AND AUS.Id = VA.Id AND IS.Id = AUS.Installed_Software_Id AND IS.Software_Id = S.software_id and VA.id=CC.alert_id and CC.alert_type_id=17 AND IS.SOFTWARE_LPAR_ID=SL.ID GROUP BY SL.NAME, S.software_name, VA.ac_name, CC.target_date, CC.owner, CC.remote_user, CC.id, CC.record_time) AS TEMP ORDER BY Software_Item_Name ASC";
	private final String SQL_QUERY_ACCOUNT_DATAEXCEPTION_SWLPAR_Report = "SELECT  AT.Name as DataException_Type, SL.Name as Lpar_Name, SL.Scantime as Scan_Time, A.Creation_time, SL.Bios_serial as Serial, SL.os_name as OS, A.Assignee, A.COMMENT from Alert A, Alert_type AT, Alert_Software_Lpar ASL, Software_Lpar SL where A.open=:open and A.alert_type_id=AT.id and ASL.id=A.id and ASL.software_lpar_id=SL.id  and SL.customer_id= :customerId and AT.code= :alertCode order by SL.Scantime";
	private final String SQL_QUERY_ACCOUNT_DATAEXCEPTION_HWLPAR_Report = "SELECT  AT.Name as DataException_Type, HL.Name as Lpar_Name,  Hw.SERIAL as Serial, A.Creation_time, HW.PROCESSOR_COUNT,cast(HL.EXT_ID as VARCHAR(8)),HW.CHIPS, A.Assignee, A.COMMENT from Alert A, Alert_type AT, Alert_Hardware_Lpar AHL, hardware_Lpar HL,hardware HW where A.open=:open and A.alert_type_id=AT.id and AHL.id=A.id and AHL.hardware_lpar_id=HL.id and HL.hardware_id=HW.id and HL.customer_id= :customerId and AT.code= :alertCode order by A.Creation_time";
	private final String WORKSTATION_ACCOUNTS_REPORT_NAME = "Workstation accounts with non-workstations report";
	private final String[] WORKSTATION_ACCOUNTS_REPORT_COLUMN_HEADERS = {
			"Account #", "Account name", "Account type", "Geography", "Region",
			"Country", "Sector", "Non-workstation count", "HW status" };
	private final String CAUSE_CODE_SUMMARY_REPORT_NAME = "Cause Code Summary Report";
	private final String[] CAUSE_CODE_SUMMARY_REPORT_COLUMN_HEADERS = {
			"Alert", "Count", "Color", "Cause Code", "Responsibility" };
	private DatabaseDeterminativeService dbdeterminativeService;
	
	@Autowired
	public ReportServiceImpl(DatabaseDeterminativeService dbdeterminativeService) {
		this.dbdeterminativeService = dbdeterminativeService;
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAlertExpiredMaintReport(Account pAccount, String remoteUser, String lsName,  
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT CASE WHEN VA.Alert_Age > 90 THEN 'Red' WHEN VA.Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END, COALESCE(SI.Name, L.Full_Desc), L.Quantity, L.Expire_Date, L.Ext_Src_Id, VA.Creation_Time, VA.Alert_Age, VA.Remote_User, VA.Comments, VA.Record_Time FROM EAADMIN.V_Alerts VA, EAADMIN.License L LEFT OUTER JOIN EAADMIN.License_Sw_Map LSM ON LSM.License_Id = L.Id LEFT OUTER JOIN EAADMIN.Software_Item SI ON SI.Id = LSM.Software_Id WHERE VA.Customer_Id = :customerId AND VA.Type = 'EXPIRED_MAINT' AND VA.Open = 1 AND L.Id = VA.Fk_Id ORDER BY COALESCE(SI.Name, L.Full_Desc) ASC")
				.setLong("customerId", pAccount.getId())
				.setString("type", "EXPIRED_MAINT")
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(ALERT_EXPIRED_MAINT_REPORT_NAME, pAccount.getAccount(),
				ALERT_EXPIRED_MAINT_REPORT_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAlertExpiredScanReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb,
			OutputStream pOutputStream) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate()).createSQLQuery(SQL_QUERY_SW_LPAR)
				.setLong("customerId", pAccount.getId())
				.setString("type", "EXPIRED_SCAN")
				.setInteger("alertTypeId", 6)
				.scroll(ScrollMode.FORWARD_ONLY);
		HSSFSheet sheet = phwb.createSheet("Alert Outdated Swlpar Report");
		printHeader(ALERT_EXPIRED_SCAN_REPORT_NAME, pAccount.getAccount(),
				ALERT_SW_LPAR_REPORT_COLUMN_HEADERS, sheet);
		int i = 3;
		while (lsrReport.next()) {
			int k = 1;
            if (i>65535){
                k++;
				sheet = phwb.createSheet("Alert Outdated SWLpar Sheet"+k);
				i = 1;
			}
			HSSFRow row = sheet.createRow((int) i);
			outputData(lsrReport.get(), row);
			i++;
		}
		// lsrReport.close();
		@SuppressWarnings("unchecked")
		Iterator<Object[]> vCauseCodeSummary = getEntityManager()
				.createNamedQuery("getValidCauseCodesByAlertTypeId")
				.setParameter("alertTypeId", new Long(6)).getResultList()
				.iterator();
		HSSFSheet sheet_2 = phwb.createSheet("Valid Cause Codes");
		HSSFRow rowhead0 = sheet_2.createRow((int) 0);
		outputData(ALERT_VALID_CAUSE_CODE_HEADERS, rowhead0);
		int j = 1;
		while (vCauseCodeSummary.hasNext()) {
			HSSFRow row = sheet_2.createRow((int) j);
			outputData(vCauseCodeSummary.next(), row);
			j++;
		}
		phwb.write(pOutputStream);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAlertHardwareLparReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb,
			OutputStream pOutputStream) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT CASE WHEN VA.Alert_Age > 90 THEN 'Red' WHEN VA.Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END, HL.Name AS HL_Name, H.Serial, MT.Name AS MT_Name, MT.Type, VA.Creation_Time, VA.Alert_Age, VA.Remote_User, VA.Comments, VA.Record_Time, AC.name as ac_name, CC.target_date, CC.owner as cc_owner,CC.record_time as cc_record_time,CC.remote_user as cc_remote_user, CC.id as cc_id FROM EAADMIN.V_Alerts VA, EAADMIN.Hardware_Lpar HL, EAADMIN.Hardware H, EAADMIN.Machine_Type MT, EAADMIN.cause_code CC, EAADMIN.alert_cause AC WHERE VA.Customer_Id = :customerId AND VA.Type = 'HARDWARE_LPAR' AND VA.Open = 1 AND HL.Id = VA.FK_Id AND H.Id = HL.Hardware_Id AND MT.Id = H.Machine_Type_Id and VA.id=CC.alert_id and CC.alert_type_id=4 and CC.alert_cause_id=AC.id ORDER BY HL.Name ASC")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);
		HSSFSheet sheet = phwb.createSheet("Alert HwLPAR Report");
		printHeader(ALERT_HARDWARE_LPAR_REPORT_NAME, pAccount.getAccount(),
				ALERT_HARDWARE_LPAR_REPORT_COLUMN_HEADERS, sheet);
		int i = 3;
		while (lsrReport.next()) {
			int k = 1;
            if (i>65535){
                k++;
				sheet = phwb.createSheet("Alert HWLpar Report Sheet"+k);
				i = 1;
			}
			HSSFRow row = sheet.createRow((int) i);
			outputData(lsrReport.get(), row);
			i++;
		}

		// lsrReport.close();
		@SuppressWarnings("unchecked")
		Iterator<Object[]> vCauseCodeSummary = getEntityManager()
				.createNamedQuery("getValidCauseCodesByAlertTypeId")
				.setParameter("alertTypeId", new Long(4)).getResultList()
				.iterator();
		HSSFSheet sheet_2 = phwb.createSheet("Valid Cause Codes");
		HSSFRow rowhead0 = sheet_2.createRow((int) 0);
		outputData(ALERT_VALID_CAUSE_CODE_HEADERS, rowhead0);
		int j = 1;
		while (vCauseCodeSummary.hasNext()) {
			HSSFRow row = sheet_2.createRow((int) j);
			outputData(vCauseCodeSummary.next(), row);
			j++;
		}
		phwb.write(pOutputStream);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAlertHardwareReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb,
			OutputStream pOutputStream) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT CASE WHEN VA.Alert_Age > 90 THEN 'Red' WHEN VA.Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END, H.Serial, MT.Name, MT.Type, VA.Creation_Time, VA.Alert_Age, VA.Remote_User, VA.Comments, VA.Record_Time,  AC.name as ac_name, CC.target_date,CC.owner as cc_owner,CC.record_time as cc_record_time,CC.remote_user as cc_remote_user, CC.id as cc_id FROM EAADMIN.V_Alerts VA, EAADMIN.Hardware H, EAADMIN.Machine_Type MT, EAADMIN.cause_code CC, EAADMIN.alert_cause AC WHERE VA.Customer_Id = :customerId AND VA.Type = 'HARDWARE' AND VA.Open = 1 AND H.Id = VA.FK_Id AND MT.Id = H.Machine_Type_Id and VA.id=CC.alert_id and CC.alert_type_id=3 and CC.alert_cause_id=AC.id ORDER BY H.Serial ASC")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);
		HSSFSheet sheet = phwb.createSheet("Alert Hardware Report");
		printHeader(ALERT_HARDWARE_REPORT_NAME, pAccount.getAccount(),
				ALERT_HARDWARE_REPORT_COLUMN_HEADERS, sheet);
		int i = 3;
		while (lsrReport.next()) {
			int k = 1;
            if (i>65535){
                k++;
				sheet = phwb.createSheet("Alert HW Report Sheet"+k);
				i = 1;
			}
			HSSFRow row = sheet.createRow((int) i);
			outputData(lsrReport.get(), row);
			i++;
		}
		// lsrReport.close();

		@SuppressWarnings("unchecked")
		Iterator<Object[]> vCauseCodeSummary = getEntityManager()
				.createNamedQuery("getValidCauseCodesByAlertTypeId")
				.setParameter("alertTypeId", new Long(3)).getResultList()
				.iterator();
		HSSFSheet sheet_2 = phwb.createSheet("Valid Cause Codes");
		HSSFRow rowhead0 = sheet_2.createRow((int) 0);
		outputData(ALERT_VALID_CAUSE_CODE_HEADERS, rowhead0);
		int j = 1;
		while (vCauseCodeSummary.hasNext()) {
			HSSFRow row = sheet_2.createRow((int) j);
			outputData(vCauseCodeSummary.next(), row);
			j++;
		}
		phwb.write(pOutputStream);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAlertSoftwareLparReport(Account pAccount, String remoteUser, String lsName,  HSSFWorkbook phwb,
			OutputStream pOutputStream) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate()).createSQLQuery(SQL_QUERY_SW_LPAR)
				.setLong("customerId", pAccount.getId())
				.setString("type", "SOFTWARE_LPAR")
				.setInteger("alertTypeId", 5)
				.scroll(ScrollMode.FORWARD_ONLY);

		HSSFSheet sheet = phwb.createSheet("Alert SwLpar Report");
		printHeader(ALERT_SOFTWARE_LPAR_REPORT_NAME, pAccount.getAccount(),
				ALERT_SW_LPAR_REPORT_COLUMN_HEADERS, sheet);
		int i = 3;
		while (lsrReport.next()) {
			int k = 1;
            if (i>65535){
                k++;
				sheet = phwb.createSheet("Alert SWLpar Report Sheet"+k);
				i = 1;
			}
			HSSFRow row = sheet.createRow((int) i);
			outputData(lsrReport.get(), row);
			i++;
		}

		// lsrReport.close();
		@SuppressWarnings("unchecked")
		Iterator<Object[]> vCauseCodeSummary = getEntityManager()
				.createNamedQuery("getValidCauseCodesByAlertTypeId")
				.setParameter("alertTypeId", new Long(5)).getResultList()
				.iterator();
		HSSFSheet sheet_2 = phwb.createSheet("Valid Cause Codes");
		HSSFRow rowhead0 = sheet_2.createRow((int) 0);
		outputData(ALERT_VALID_CAUSE_CODE_HEADERS, rowhead0);
		int j = 1;
		while (vCauseCodeSummary.hasNext()) {
			HSSFRow row = sheet_2.createRow((int) j);
			outputData(vCauseCodeSummary.next(), row);
			j++;
		}
		phwb.write(pOutputStream);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAccountDataExceptionReport(Account pAccount, String remoteUser, String lsName, 
			String pAlertCode, PrintWriter pPrintWriter)
			throws HibernateException, Exception {
		String sql_query_data_exception = null;
		String[] header_of_data_exception = null;
		for (DataExceptionTypeEnum l : DataExceptionTypeEnum.values()) {
			if (pAlertCode.equals(l.name().toString())) {
				if (l.getLevel().equals("SWLPAR")) {
					sql_query_data_exception = SQL_QUERY_ACCOUNT_DATAEXCEPTION_SWLPAR_Report;
					header_of_data_exception = ACCOUNT_DATA_EXCEPTIONS_REPORT_SWLPAR_COLUMN_HEADERS;
				}
				if (l.getLevel().equals("HWLPAR")) {
					sql_query_data_exception = SQL_QUERY_ACCOUNT_DATAEXCEPTION_HWLPAR_Report;
					header_of_data_exception = ACCOUNT_DATA_EXCEPTIONS_REPORT_HWLPAR_COLUMN_HEADERS;
				}
			}
		}

		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate()).createSQLQuery(sql_query_data_exception)
				.setLong("open", 1).setLong("customerId", pAccount.getId())
				.setString("alertCode", pAlertCode)
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(ACCOUNT_DATA_EXCEPTIONS_REPORT_NAME, pAccount.getAccount(),
				header_of_data_exception, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAlertUnlicensedIbmSwReport(Account pAccount, String remoteUser, String lsName, 
			HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate()).createSQLQuery(SQL_QUERY_UNLICENSED_SW)
				.setLong("customerId", pAccount.getId())
				.setString("type", "UNLICENSED_IBM_SW")
				.scroll(ScrollMode.FORWARD_ONLY);
		HSSFSheet sheet = phwb.createSheet("Alert UNLICENSED_IBM_SW Report");
		printHeader(ALERT_UNLICENSED_IBM_SW_REPORT_NAME, pAccount.getAccount(),
				ALERT_UNLICENSED_SW_REPORT_COLUMN_HEADERS, sheet);
		int i = 3;
		while (lsrReport.next()) {
			int k = 1;
            if (i>65535){
                k++;
				sheet = phwb.createSheet("Alert UIBM SW Report Sheet"+k);
				i = 1;
			}
			HSSFRow row = sheet.createRow((int) i);
			outputData(lsrReport.get(), row);
			i++;
		}

		// lsrReport.close();
		@SuppressWarnings("unchecked")
		Iterator<Object[]> vCauseCodeSummary = getEntityManager()
				.createNamedQuery("getValidCauseCodesByAlertTypeId")
				.setParameter("alertTypeId", new Long(17)).getResultList()
				.iterator();
		HSSFSheet sheet_2 = phwb.createSheet("Valid Cause Codes");
		HSSFRow rowhead0 = sheet_2.createRow((int) 0);
		outputData(ALERT_VALID_CAUSE_CODE_HEADERS, rowhead0);
		int j = 1;
		while (vCauseCodeSummary.hasNext()) {
			HSSFRow row = sheet_2.createRow((int) j);
			outputData(vCauseCodeSummary.next(), row);
			j++;
		}
		phwb.write(pOutputStream);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getAlertUnlicensedIsvSwReport(Account pAccount, String remoteUser, String lsName, 
			HSSFWorkbook phwb, OutputStream pOutputStream)
			throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate()).createSQLQuery(SQL_QUERY_UNLICENSED_SW)
				.setLong("customerId", pAccount.getId())
				.setString("type", "UNLICENSED_ISV_SW")
				.scroll(ScrollMode.FORWARD_ONLY);
		HSSFSheet sheet = phwb.createSheet("Alert UNLICENSED_ISV_SW Report");
		printHeader(ALERT_UNLICENSED_ISV_SW_REPORT_NAME, pAccount.getAccount(),
				ALERT_UNLICENSED_SW_REPORT_COLUMN_HEADERS, sheet);
		int i = 3;
		while (lsrReport.next()) {
			int k = 1;
            if (i>65535){
                k++;
				sheet = phwb.createSheet("Alert UISV SW Report Sheet"+k);
				i = 1;
			}
			HSSFRow row = sheet.createRow((int) i);
			outputData(lsrReport.get(), row);
			i++;
		}

		// lsrReport.close();
		@SuppressWarnings("unchecked")
		Iterator<Object[]> vCauseCodeSummary = getEntityManager()
				.createNamedQuery("getValidCauseCodesByAlertTypeId")
				.setParameter("alertTypeId", new Long(17)).getResultList()
				.iterator();
		HSSFSheet sheet_2 = phwb.createSheet("Valid Cause Codes");
		HSSFRow rowhead0 = sheet_2.createRow((int) 0);
		outputData(ALERT_VALID_CAUSE_CODE_HEADERS, rowhead0);
		int j = 1;
		while (vCauseCodeSummary.hasNext()) {
			HSSFRow row = sheet_2.createRow((int) j);
			outputData(vCauseCodeSummary.next(), row);
			j++;
		}
		phwb.write(pOutputStream);
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getFreeLicensePoolReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate()).getNamedQuery("freePoolReport")
				.setLong("account", pAccount.getAccount())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(FREE_LICENSE_POOL_REPORT_NAME, pAccount.getAccount(),
				LICENSE_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getFullReconciliationReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception {
		String lsBaseSelectClauseOne = "select "
				+ "CASE WHEN AUS.Open = 0 THEN 'Blue' "
				+ "WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 90 THEN 'Red' "
				+ "WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 45 THEN 'Yellow' "
				+ "ELSE 'Green' "
				+ "END "
				+ ",aus.creation_time "
				+ ", case when aus.open = 1 then DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) "
				+ "else days(aus.record_time) - days(aus.creation_time) "
				+ "end "
				+ ",sl.name as swLparName "
				+ ",h.serial as hwSerial "
				+ ",mt.name as hwMachType "
				+ ",h.model as cpuModel"
				+ ",h.chassis_id"
				+ ",h.cloud_name"
				+ ",h.owner as hwOwner "
				+ ",h.country as hwCountry "
				+ ",mt.type as hwAssetType "
				+ ",hl.server_type as serverType "
				+ ",hl.SPLA"
				+ ",hl.virtual_flag"
				+ ",hl.virtual_mobility_restriction"
				+ ",cast(hl.SYSPLEX as VARCHAR(8))"
				+ ",hl.cluster_type"
				+ ",hl.backupmethod"
				+ ",hl.INTERNET_ICC_FLAG"
				+ ",hl.capped_lpar"
				+ ",h.MAST_PROCESSOR_TYPE"
				+ ",h.PROCESSOR_MANUFACTURER"
				+ ",h.PROCESSOR_MODEL"
				+ ",h.NBR_CORES_PER_CHIP"
				+ ",h.NBR_OF_CHIPS_MAX"
				+ ",h.shared_processor"
				+ ",h.CPU_MIPS"
				+ ",h.CPU_GARTNER_MIPS"
				+ ",h.CPU_MSU"
				+ ",hl.PART_MIPS"
				+ ",hl.PART_GARTNER_MIPS"
				+ ",hl.PART_MSU"
				+ ",h.SHARED"
				+ ",h.hardware_status"
				+ ",hl.lpar_status"
				+ ",h.processor_count as hwProcCount "
				+ ",h.chips as hwChips "
				+ ",case when sle.software_lpar_id is null then sl.processor_count else sle.processor_count end as swLparProcCount "
				+ ",hl.EFFECTIVE_THREADS "
				+ ",case when ibmb.id is not null then COALESCE( CAST( (select pvui.VALUE_UNITS_PER_CORE from pvu_info pvui where pvui.pvu_id=pvum.pvu_id and "
				+ "(case when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) = 1 then  'SINGLE-CORE' "
				+ "when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) = 2 then  'DUAL-CORE' "
				+ "when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) = 4 then  'QUAD-CORE' "
				+ "when COALESCE( h.PROCESSOR_COUNT / NULLIF(h.CHIPS,0), 0) > 0 then 'MULTI-CORE' else '' end ) = pvui.PROCESSOR_TYPE  fetch first 1 row only ) as CHAR(8)),'base data missing') else 'Non_IBM Product' end as pvuPerCode"
				+ ",instSi.name as instSwName ";
		
		String lsBaseSelectClauseTwo = ", COALESCE ( CAST ( (select scop.description from scope scop join schedule_f sf on sf.scope_id = scop.id "
                + "where sf.customer_id = :customerId "
                + "and sf.status_id=2 "
                + "and sf.software_name = instSi.name "
                + "and ( ( sf.level = 'PRODUCT' ) "
                + "or (( sf.hostname = sl.name ) and ( level = 'HOSTNAME' )) "
                + "or (( sf.serial = h.serial ) and ( sf.machine_type = mt.name ) and ( sf.level = 'HWBOX' )) "
                + "or (( sf.hw_owner = h.owner ) and ( sf.level ='HWOWNER' )) ) "
                + "order by sf.LEVEL fetch first 1 rows only) as varchar(64) ), 'Not specified' ) as swOwner ";
		String lsBaseSelectClauseThree = ", 'Not specified' as swOwner ";
		String lsBaseSelectClauseFour = ",aus.remote_user as alertAssignee "
				+ ",aus.comments as alertAssComments "
				+ ",instSwMan.name as instSwManName "
				+ ",dt.name as instSwDiscrepName "
				+ ",case when rt.is_manual = 0 then rt.name || '(AUTO)' when rt.is_manual = 1 then rt.name || '(MANUAL)' end "
				+ ",am.name as reconAllocMethod "
				+ ",r.remote_user as reconUser "
				+ ",r.record_time as reconTime "
				+ ",case when rt.is_manual = 0 then 'Auto Close' when rt.is_manual = 1 then r.comments end as reconComments "
				+ ",parentSi.name as parentName "
				+ ",c.account_number as licAccount "
				+ ",l.full_desc as licenseDesc "
				+ ",case when l.id is null then '' "
				+ "when lsm.id is null then 'No' "
				+ "else 'Yes' end as catalogMatch "
				+ ",l.prod_name as licProdName "
				+ ",l.version as licVersion "
				+ ",CONCAT(CONCAT(RTRIM(CHAR(L.Cap_Type)), '-'), CT.Description) "
				+ ",l.environment as licEnvironment "
				+ ",ul.used_quantity " + ",case when r.id is null then '' "
				+ "when r.machine_level = 0 then 'No' " + "else 'Yes' end "
				+ ", REPLACE(RTRIM(CHAR(DATE(L.Expire_Date), USA)), '/', '-') "
				+ ",l.po_number " + ",l.cpu_serial "
				+ ",case when l.ibm_owned = 0 then 'Customer' "
				+ "when l.ibm_owned = 1 then 'IBM' " + "else '' end "
				+ ",l.ext_src_id " + ",l.record_time ";
		String lsBaseFromClause = "from  "
				+ "eaadmin.software_lpar sl "
				+ "left outer join eaadmin.software_lpar_eff sle on "
				+ "sl.id = sle.software_lpar_id "
				+ "and sle.status = 'ACTIVE' "
				+ "and sle.processor_count != 0 "
				+ "inner join eaadmin.hw_sw_composite hsc on "
				+ "sl.id = hsc.software_lpar_id "
				+ "inner join eaadmin.hardware_lpar hl on "
				+ "hsc.hardware_lpar_id = hl.id "
				+ "inner join eaadmin.hardware h on "
				+ "hl.hardware_id = h.id "
				+ "inner join eaadmin.machine_type mt on "
				+ "h.machine_type_id = mt.id "
				+ "inner join eaadmin.installed_software is on "
				+ "sl.id = is.software_lpar_id "
				+ "inner join eaadmin.product_info instPi on "
				+ "is.software_id = instPi.id "
				+ "inner join eaadmin.product instP on "
				+ "instPi.id = instP.id "
				+ "inner join eaadmin.software_item instSi on "
				+ "instP.id = instSi.id "
				+ "inner join eaadmin.manufacturer instSwMan on "
				+ "instP.manufacturer_id = instSwMan.id "
				+ "inner join eaadmin.discrepancy_type dt on "
				+ "is.discrepancy_type_id = dt.id "
				+ "inner join eaadmin.alert_unlicensed_sw aus on "
				+ "is.id = aus.installed_software_id "
				+ "left outer join eaadmin.reconcile r on "
				+ "is.id = r.installed_software_id "
				+ "left outer join eaadmin.reconcile_type rt on "
				+ "r.reconcile_type_id = rt.id "
				+ "left outer join eaadmin.installed_software parent on "
				+ "r.parent_installed_software_id = parent.id "
				+ "left outer join eaadmin.product_info parentPi on "
				+ "parent.software_id = parentPi.id "
				+ "left outer join eaadmin.product parentP on "
				+ "parentPi.id = parentP.id "
				+ "left outer join eaadmin.software_item parentSi on "
				+ "parentSi.id = parentP.id "
				+ "left outer join eaadmin.reconcile_used_license rul on "
				+ "r.id = rul.reconcile_id "
				+ "left outer join eaadmin.used_license ul on "
				+ "rul.used_license_id = ul.id "
				+ "left outer join eaadmin.license l on "
				+ "ul.license_id = l.id "
				+ "left outer join eaadmin.license_sw_map lsm on "
				+ "l.id = lsm.license_id "
				+ "left outer join eaadmin.capacity_type ct on "
				+ "l.cap_type = ct.code "
				+ "left outer join eaadmin.customer c on "
				+ "l.customer_id = c.customer_id "
				+ "left outer join eaadmin.pvu_map pvum on h.MACHINE_TYPE_ID = pvum.MACHINE_TYPE_ID and h.MAST_PROCESSOR_TYPE = pvum.PROCESSOR_BRAND and h.MODEL = pvum.PROCESSOR_MODEL "
				+ "left outer join eaadmin.ibm_brand ibmb on instSwMan.id=ibmb.manufacturer_id "
				+ "left outer join eaadmin.allocation_methodology am on r.allocation_methodology_id=am.id ";
		String lsBaseWhereClausea = "where "
				+ "sl.customer_id = :customerId "
				+ "and hl.customer_id = :customerId "
				+ "and (aus.open = 1 or (aus.open = 0 and is.id = r.installed_software_id)) ";
//				+ "and (sf.id in (select ssf.id  "
//                + " from schedule_f ssf where  sl.customer_id =  ssf.customer_id and instSi.name = ssf.SOFTWARE_NAME  order by "
//                + " CASE WHEN  ssf.level='HOSTNAME' and ssf.hostname = sl.name THEN 1 ELSE "
//                + " CASE WHEN  ssf.level='HWBOX' and ssf.serial = h.serial and ssf.machine_type = mt.name THEN 2 ELSE "
//                + "  CASE WHEN ssf.level='HWOWNER' and  ssf.hw_owner = h.owner THEN 3 ELSE "
//                + "  4 END END END "
//                + " fetch first 1 row only ) )";
		String lsBaseWhereClauseb = "where "
				+ "sl.customer_id = :customerId "
				+ "and hl.customer_id = :customerId "
				+ "and (aus.open = 1 or (aus.open = 0 and is.id = r.installed_software_id)) "
				;
		StringBuffer lsbSql = new StringBuffer();
		StringBuffer lsbScopeSql = new StringBuffer();
		ScrollableResults lsrReport = null;

// ------- BUGFIX --------
		lsbSql.append(
							lsBaseSelectClauseOne + lsBaseSelectClauseTwo
									+ lsBaseSelectClauseFour + lsBaseFromClause)
							.append(lsBaseWhereClausea);
// --------------------------		
/*		if (pbCustomerOwnedCustomerManagedSearchChecked
				|| pbCustomerOwnedIBMManagedSearchChecked
				|| pbIBMOwnedIBMManagedSearchChecked
				|| pbIBMO3rdMSearchChecked
				|| pbCustO3rdMSearchChecked
				|| pbIBMOibmMSWCOSearchChecked
				|| pbCustOibmMSWCOSearchChecked
				|| pbSelectAllChecked) {
			lsbSql.append(
					lsBaseSelectClauseOne + lsBaseSelectClauseTwo
							+ lsBaseSelectClauseFour + lsBaseFromClause)
					.append("inner join EAADMIN.Schedule_F SF on sf.customer_id = sl.customer_id and instSi.name = sf.SOFTWARE_NAME inner join EAADMIN.Scope scp on SF.scope_id=scp.id ")
					.append(lsBaseWhereClausea);
			if (pbSelectAllChecked) {				
					lsbScopeSql.append("1, 2, 3, 4, 5, 6, 7");
					pbTitlesNotSpecifiedInContractScopeSearchChecked = true;
			} else {

				if (pbCustomerOwnedCustomerManagedSearchChecked) {
					lsbScopeSql.append("1");
				}
				if (pbCustomerOwnedIBMManagedSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 2");
					} else {
						lsbScopeSql.append("2");
					}
				}
				if (pbIBMOwnedIBMManagedSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 3");
					} else {
						lsbScopeSql.append("3");
					}
				}
				if (pbIBMO3rdMSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 4");
					} else {
						lsbScopeSql.append("4");
					}
				}
				if (pbCustO3rdMSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 5");
					} else {
						lsbScopeSql.append("5");
					}
				}
				if (pbIBMOibmMSWCOSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 6");
					} else {
						lsbScopeSql.append("6");
					}
				}
				if (pbCustOibmMSWCOSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 7");
					} else {
						lsbScopeSql.append("7");
					}
				}
			}
			lsbSql.append(" AND SF.Scope_Id IN (")
			.append(lsbScopeSql)
			.append(") ")
			.append(" AND SF.STATUS_ID = 2 ")
			.append(" and (\r\n"
					+ "  sf.level = 'PRODUCT'\r\n"
					+ " or (( sf.hostname = sl.name ) and ( sf.level = 'HOSTNAME' )) \r\n"
					+ " or (( sf.serial = h.serial ) and ( sf.machine_type = mt.name ) and ( sf.level = 'HWBOX' )) \r\n"
					+ " or (( sf.hw_owner = h.owner ) and ( sf.level ='HWOWNER' )) \r\n"
					+ " )")
			.append(pbTitlesNotSpecifiedInContractScopeSearchChecked ? "UNION "
					: "");
		}
		if (pbTitlesNotSpecifiedInContractScopeSearchChecked) {
			lsbSql.append(
					lsBaseSelectClauseOne + lsBaseSelectClauseThree
							+ lsBaseSelectClauseFour + lsBaseFromClause)
					.append(" ")
					.append(lsBaseWhereClauseb)
					.append(" AND NOT EXISTS (SELECT SF.Software_Id FROM EAADMIN.Schedule_F SF, EAADMIN.Status S3 WHERE SF.Customer_Id = :customerId AND SF.SOFTWARE_NAME = instSi.name AND S3.Id = SF.Status_Id AND S3.Description = 'ACTIVE') ");
		}
*/
		lsbSql.append("ORDER BY 4");
		lsrReport = ((Session) getEntityManager().getDelegate())
				.createSQLQuery(lsbSql.toString())
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(FULL_RECONCILIATION_REPORT_NAME, pAccount.getAccount(),
				FULL_RECONCILIATION_REPORT_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getHardwareBaselineReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT H.Serial, MT.Name AS MT_Name, HL.Name AS HL_Name, MT.Type,HL.server_type,HL.SPLA,cast(hl.SYSPLEX as VARCHAR(8)),HL.INTERNET_ICC_FLAG,H.MAST_PROCESSOR_TYPE,H.PROCESSOR_MANUFACTURER,H.PROCESSOR_MODEL,H.NBR_CORES_PER_CHIP,H.NBR_OF_CHIPS_MAX,H.SHARED,H.Hardware_Status,HL.Lpar_Status, CASE LENGTH(RTRIM(COALESCE(CHAR(HSC.Id), ''))) WHEN 0 THEN 'No' ELSE 'Yes' END FROM EAADMIN.Hardware H LEFT OUTER JOIN EAADMIN.Hardware_Lpar HL ON HL.Hardware_Id = H.Id LEFT OUTER JOIN EAADMIN.HW_SW_Composite HSC ON HSC.Hardware_Lpar_Id = HL.Id LEFT OUTER JOIN EAADMIN.Machine_Type MT ON MT.Id = H.Machine_Type_Id WHERE HL.Customer_Id = :customerId AND HL.Status = 'ACTIVE' ORDER BY H.Serial ASC")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(HARDWARE_BASELINE_REPORT_NAME, pAccount.getAccount(),
				HARDWARE_BASELINE_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getInstalledSoftwareBaselineReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception {
		String lsBaseSelectAndFromClause = "SELECT SI.Name AS SI_Name, M.Name AS M_Name, CASE UCASE(KBD.Custom_2) WHEN 'TRUE' THEN 'Yes' ELSE 'No' END, SL.Name AS SL_Name, SL.Bios_Serial, VSLP.Processor_Count, H.Chips, SL.ScanTime, CASE LENGTH(RTRIM(COALESCE(CHAR(HSC.Id), ''))) WHEN 0 THEN 'No' ELSE 'Yes' END, H.Serial, MT.Name AS MT_Name, MT.Type FROM EAADMIN.Kb_Definition KBD, EAADMIN.Software_Item SI, EAADMIN.Product P, EAADMIN.Product_Info PI, EAADMIN.Manufacturer M, EAADMIN.Software_Lpar SL, EAADMIN.V_Software_Lpar_Processor VSLP, EAADMIN.Installed_Software IS LEFT OUTER JOIN EAADMIN.HW_SW_Composite HSC ON HSC.Software_Lpar_Id = IS.Software_Lpar_Id LEFT OUTER JOIN EAADMIN.Hardware_Lpar HL ON HL.Id = HSC.Hardware_Lpar_Id LEFT OUTER JOIN EAADMIN.Hardware H ON H.Id = HL.Hardware_Id LEFT OUTER JOIN EAADMIN.Machine_Type MT ON MT.Id = H.Machine_Type_Id, (SELECT SL2.Customer_Id, SI2.Id, PI2.Software_Category_Id, MIN(PI2.Priority) AS Priority FROM EAADMIN.Software_Lpar SL2, EAADMIN.Software_Item SI2, EAADMIN.Product_Info PI2, EAADMIN.Installed_Software IS2 WHERE SL2.Customer_Id = :customerId AND SL2.Status = 'ACTIVE' AND SL2.Id = IS2.Software_Lpar_Id AND SI2.Id = IS2.Software_Id AND PI2.Id = SI2.Id AND PI2.Licensable = 1 AND IS2.Discrepancy_Type_Id IN (1, 2, 4) AND IS2.Status = 'ACTIVE' GROUP BY SL2.Customer_Id, SI2.Id, PI2.Software_Category_Id) AS TEMP";
		String lsBaseWhereClause = "WHERE KBD.Id = IS.Software_Id AND SI.Id = KBD.Id AND P.Id = SI.Id AND PI.Id = P.Id AND PI.Licensable = 1 AND M.Id = P.Manufacturer_Id AND SL.Customer_Id = TEMP.Customer_Id AND SL.Status = 'ACTIVE' AND SL.Id = IS.Software_Lpar_Id AND VSLP.Id = SL.Id AND IS.Discrepancy_Type_Id IN (1, 2, 4) AND IS.Status = 'ACTIVE' AND TEMP.Id = SI.Id AND TEMP.Software_Category_Id = PI.Software_Category_Id AND TEMP.Priority = PI.Priority";
		StringBuffer lsbSql = new StringBuffer();
		StringBuffer lsbScopeSql = new StringBuffer();
		ScrollableResults lsrReport = null;

		if (!((pbCustomerOwnedCustomerManagedSearchChecked
				&& pbCustomerOwnedIBMManagedSearchChecked
				&& pbIBMOwnedIBMManagedSearchChecked
				&& pbTitlesNotSpecifiedInContractScopeSearchChecked
				&& pbIBMO3rdMSearchChecked
				&& pbCustO3rdMSearchChecked
				&& pbIBMOibmMSWCOSearchChecked
				&& pbCustOibmMSWCOSearchChecked)
				|| pbSelectAllChecked)) {
			if (pbCustomerOwnedCustomerManagedSearchChecked
					|| pbCustomerOwnedIBMManagedSearchChecked
					|| pbIBMOwnedIBMManagedSearchChecked
					|| pbIBMO3rdMSearchChecked
					|| pbCustO3rdMSearchChecked
					|| pbIBMOibmMSWCOSearchChecked
					|| pbCustOibmMSWCOSearchChecked) {
				lsbSql.append(lsBaseSelectAndFromClause)
						.append(", EAADMIN.Schedule_F SF ")
						.append(lsBaseWhereClause);
				if (pbCustomerOwnedCustomerManagedSearchChecked) {
					lsbScopeSql.append("1");
				}
				if (pbCustomerOwnedIBMManagedSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 2");
					} else {
						lsbScopeSql.append("2");
					}
				}
				if (pbIBMOwnedIBMManagedSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 3");
					} else {
						lsbScopeSql.append("3");
					}
				}
				if (pbIBMO3rdMSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 4");
					} else {
						lsbScopeSql.append("4");
					}
				}
				if (pbCustO3rdMSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 5");
					} else {
						lsbScopeSql.append("5");
					}
				}
				if (pbIBMOibmMSWCOSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 6");
					} else {
						lsbScopeSql.append("6");
					}
				}
				if (pbCustOibmMSWCOSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 7");
					} else {
						lsbScopeSql.append("7");
					}
			}
				lsbSql.append(
						" AND SF.Customer_Id = SL.Customer_Id AND SF.Software_Id = SI.Id AND " 
								+"(sf.id in (select ssf.id  "
					                  + " from schedule_f ssf where  ol.customer_id =  ssf.customer_id and SI.software_id = ssf.software_id order by "
					                  + "  CASE WHEN  ssf.level='HOSTNAME' and ssf.hostname = SL.name THEN 1 ELSE "
					                  + "  CASE WHEN  ssf.level='HWBOX' and ssf.serial = H.serial and ssf.machine_type = mt.name THEN 2 ELSE"
					                 +  "  CASE WHEN ssf.level='HWOWNER' and  ssf.hw_owner = H.owner THEN 3 ELSE"
					                 +  "   4 END END END "
					            + "fetch first 1 row only ) )"
						+"AND SF.Scope_Id IN (")
						.append(lsbScopeSql)
						.append(") ")
						.append(pbTitlesNotSpecifiedInContractScopeSearchChecked ? "UNION "
								: "");
			}
			if (pbTitlesNotSpecifiedInContractScopeSearchChecked) {
				lsbSql.append(lsBaseSelectAndFromClause)
						.append(" ")
						.append(lsBaseWhereClause)
						.append(" AND NOT EXISTS (SELECT SF.Software_Id FROM EAADMIN.Schedule_F SF, EAADMIN.Status S WHERE SF.Customer_Id = :customerId AND SF.Software_Id = SI.Id AND S.Id = SF.Status_Id AND S.Description = 'ACTIVE'" +
								" AND (\r\n" + 
								"  sf.level = 'PRODUCT'\r\n" + 
								" or (( sf.hostname = sl.name ) and ( sf.level = 'HOSTNAME' )) \r\n" + 
								" or (( sf.serial = h.serial ) and ( sf.machine_type = mt.name ) and ( sf.level = 'HWBOX' )) \r\n" + 
								" or (( sf.hw_owner = h.owner ) and ( sf.level ='HWOWNER' )) \r\n" + 
								" )" +
								") ");
			}
		} else {
			lsbSql.append(lsBaseSelectAndFromClause).append(" ")
					.append(lsBaseWhereClause).append(" ");
		}
		lsbSql.append("ORDER BY SI_Name");
		lsrReport = ((Session) getEntityManager().getDelegate())
				.createSQLQuery(lsbSql.toString())
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(INSTALLED_SOFTWARE_BASELINE_REPORT_NAME,
				pAccount.getAccount(),
				INSTALLED_SOFTWARE_BASELINE_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getLicenseBaselineReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception {
		String lsBaseSelectAndFromClause = "SELECT COALESCE(SI.Name, L.Full_Desc) AS Product_Name, CASE LENGTH(COALESCE(SI.Name, '')) WHEN 0 THEN 'No' ELSE 'Yes' END, L.Full_Desc, CONCAT(CONCAT(RTRIM(CHAR(CT.Code)), '-'), CT.Description), L.environment, L.Quantity, coalesce(L.Quantity - sum(VLUQ.Used_Quantity), L.Quantity), L.Expire_Date, L.Po_Number, L.Cpu_Serial, CASE L.IBM_Owned WHEN 1 THEN 'IBM' ELSE 'Customer' END, L.Ext_Src_Id, CASE L.Pool WHEN 0 THEN 'No' ELSE 'Yes' END, L.Record_Time FROM EAADMIN.License L LEFT OUTER JOIN EAADMIN.License_Sw_Map LSWM ON LSWM.License_Id = L.Id LEFT OUTER JOIN EAADMIN.Software_Item SI ON SI.Id = LSWM.Software_Id LEFT OUTER JOIN EAADMIN.USED_LICENSE VLUQ ON VLUQ.License_Id = L.Id, EAADMIN.Capacity_Type CT";
		String lsBaseWhereClause = "WHERE L.Customer_Id = :customerId AND L.Status = 'ACTIVE' AND CT.Code = L.Cap_Type";
		StringBuffer lsbSql = new StringBuffer();
		StringBuffer lsbScopeSql = new StringBuffer();
		ScrollableResults lsrReport = null;

		if (!((pbCustomerOwnedCustomerManagedSearchChecked
				&& pbCustomerOwnedIBMManagedSearchChecked
				&& pbIBMOwnedIBMManagedSearchChecked
				&& pbTitlesNotSpecifiedInContractScopeSearchChecked
				&& pbIBMO3rdMSearchChecked
				&& pbCustO3rdMSearchChecked
				&& pbIBMOibmMSWCOSearchChecked
				&& pbCustOibmMSWCOSearchChecked)
				|| pbSelectAllChecked)) {
			if (pbCustomerOwnedCustomerManagedSearchChecked
					|| pbCustomerOwnedIBMManagedSearchChecked
					|| pbIBMOwnedIBMManagedSearchChecked
					|| pbIBMO3rdMSearchChecked
					|| pbCustO3rdMSearchChecked
					|| pbIBMOibmMSWCOSearchChecked
					|| pbCustOibmMSWCOSearchChecked) {
				lsbSql.append(lsBaseSelectAndFromClause)
						.append(", EAADMIN.Schedule_F SF ")
						.append(lsBaseWhereClause);
				if (pbCustomerOwnedCustomerManagedSearchChecked) {
					lsbScopeSql.append("1");
				}
				if (pbCustomerOwnedIBMManagedSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 2");
					} else {
						lsbScopeSql.append("2");
					}
				}
				if (pbIBMOwnedIBMManagedSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 3");
					} else {
						lsbScopeSql.append("3");
					}
				}
				if (pbIBMO3rdMSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 4");
					} else {
						lsbScopeSql.append("4");
					}
				}
				if (pbCustO3rdMSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 5");
					} else {
						lsbScopeSql.append("5");
					}
				}
				if (pbIBMOibmMSWCOSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 6");
					} else {
						lsbScopeSql.append("6");
					}
				}
				if (pbCustOibmMSWCOSearchChecked) {
					if (lsbScopeSql.length() > 0) {
						lsbScopeSql.append(", 7");
					} else {
						lsbScopeSql.append("7");
					}
			}
				lsbSql.append(
						" AND SF.Customer_Id = L.Customer_Id AND SF.Software_Id = SI.Id AND SF.Scope_Id IN (")
						.append(lsbScopeSql)
						.append(") ")
						.append(pbTitlesNotSpecifiedInContractScopeSearchChecked ? "UNION "
								: "");
			}
			if (pbTitlesNotSpecifiedInContractScopeSearchChecked) {
				lsbSql.append(lsBaseSelectAndFromClause)
						.append(" ")
						.append(lsBaseWhereClause)
						.append(" AND NOT EXISTS (SELECT SF.Software_Id FROM EAADMIN.Schedule_F SF, EAADMIN.Status S WHERE SF.Customer_Id = :customerId AND SF.Software_Id = SI.Id AND S.Id = SF.Status_Id AND S.Description = 'ACTIVE') ");
			}
		} else {
			lsbSql.append(lsBaseSelectAndFromClause).append(" ")
					.append(lsBaseWhereClause).append(" ");
		}
		lsbSql.append("group by COALESCE(SI.Name, L.Full_Desc), CASE LENGTH(COALESCE(SI.Name, '')) WHEN 0 THEN 'No' ELSE 'Yes' END, L.Full_Desc, CONCAT(CONCAT(RTRIM(CHAR(CT.Code)), '-'), CT.Description),L.environment, L.Quantity, L.Expire_Date, L.Po_Number, L.Cpu_Serial, CASE L.IBM_Owned WHEN 1 THEN 'IBM' ELSE 'Customer' END, L.Ext_Src_Id, CASE L.Pool WHEN 0 THEN 'No' ELSE 'Yes' END, L.Record_Time ");
		lsbSql.append("ORDER BY Product_Name ASC");
		lsrReport = ((Session) getEntityManager().getDelegate())
				.createSQLQuery(lsbSql.toString())
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(LICENSE_BASELINE_REPORT_NAME, pAccount.getAccount(),
				LICENSE_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getNonWorkstationAccountsReport(String remoteUser, String lsName,  PrintWriter pPrintWriter)
			throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT C.Account_Number, C.Customer_Name, CT.Customer_Type_Name, G.Name AS G_Name, R.Name AS R_Name, CC.Name AS CC_Name, S.Sector_Name, COUNT(H.Id), H.Hardware_Status FROM EAADMIN.Customer C, EAADMIN.Customer_Type CT, EAADMIN.Country_Code CC, EAADMIN.Region R, EAADMIN.Geography G, EAADMIN.Sector S, EAADMIN.Industry I, EAADMIN.Hardware H, EAADMIN.Machine_Type MT WHERE C.Status = 'ACTIVE' AND C.Customer_Type_Id = CT.Customer_Type_Id AND CT.Customer_Type_Name NOT LIKE '%WORKSTATION%' AND G.Id = R.Geography_Id AND R.Id = CC.Region_Id AND CC.Id = C.Country_Code_Id AND S.Sector_Id = I.Sector_Id AND I.Industry_Id = C.Industry_Id AND H.Customer_Id = C.Customer_Id AND H.Status = 'ACTIVE' AND MT.Id = H.Machine_Type_Id AND MT.Type = 'WORKSTATION' GROUP BY C.Account_Number, C.Customer_Name, CT.Customer_Type_Name, G.Name, R.Name, CC.Name, S.Sector_Name, H.Hardware_Status ORDER BY C.Account_Number, H.Hardware_Status")
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(NON_WORKSTATION_ACCOUNTS_REPORT_NAME, null,
				NON_WORKSTATION_ACCOUNTS_REPORT_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getPendingCustomerDecisionDetailReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT SI.Name, SL.Name AS SL_Name, RT.Name AS RT_Name, AUS.Creation_Time, R.Record_Time, R.Remote_User FROM EAADMIN.Software_Item SI, EAADMIN.Installed_Software IS, EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Software_Lpar SL, EAADMIN.Reconcile R, EAADMIN.Reconcile_Type RT WHERE SI.Id = IS.Software_Id AND IS.Id = AUS.Installed_Software_Id AND AUS.Open = 0 AND SL.Id = IS.Software_Lpar_Id AND SL.Customer_Id = :customerId AND R.Installed_Software_Id = IS.Id AND R.Reconcile_Type_ID IN (2, 14) AND RT.Id = R.Reconcile_Type_Id ORDER BY SI.Name, SL.Name, RT.Name")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(PENDING_CUSTOMER_DECISION_DETAIL_REPORT_NAME,
				pAccount.getAccount(),
				PENDING_CUSTOMER_DECISION_DETAIL_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getPendingCustomerDecisionSummaryReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT SI.Name, RT.Name AS RT_Name, COUNT(AUS.Id), SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) < 46 THEN 1 ELSE 0 END), SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 46 AND 90 THEN 1 ELSE 0 END), SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 91 AND 120 THEN 1 ELSE 0 END), SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 121 AND 180 THEN 1 ELSE 0 END), SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) BETWEEN 181 AND 365 THEN 1 ELSE 0 END), SUM(CASE WHEN DAYS(CURRENT TIMESTAMP) - DAYS(AUS.Creation_Time) > 365 THEN 1 ELSE 0 END) FROM EAADMIN.Software_Item SI, EAADMIN.Installed_Software IS, EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Software_Lpar SL, EAADMIN.Reconcile R, EAADMIN.Reconcile_Type RT WHERE SI.Id = IS.Software_Id AND IS.Id = AUS.Installed_Software_Id AND AUS.Open = 0 AND SL.Id = IS.Software_Lpar_Id AND SL.Customer_Id = :customerId AND R.Installed_Software_Id = IS.Id AND R.Reconcile_Type_ID IN (2, 14) AND RT.Id = R.Reconcile_Type_Id GROUP BY SI.Name, RT.Name ORDER BY SI.Name, RT.Name")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(PENDING_CUSTOMER_DECISION_SUMMARY_REPORT_NAME,
				pAccount.getAccount(),
				PENDING_CUSTOMER_DECISION_SUMMARY_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getReconciliationSummaryReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery("CALL EAADMIN.ReconSummaryReport(:customerId)")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);
		Object[] loaData = null;

		printHeader(RECONCILIATION_SUMMARY_REPORT_NAME, pAccount.getAccount(),
				RECONCILIATION_SUMMARY_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputReconciliationSummaryData(
					lsrReport.get(), loaData));
			loaData = lsrReport.get();
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getCauseCodeSummaryReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT VA.CAUSE_CODE_ALERT_TYPE,count(*),CASE WHEN VA.Alert_Age > 90 THEN 'Red' WHEN VA.Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END as color,VA.AC_NAME, VA.AC_RESPONSIBILITY from v_alerts VA where VA.Customer_Id = :customerId and VA.open = 1 group by VA.CAUSE_CODE_ALERT_TYPE,VA.AC_NAME, (CASE WHEN VA.Alert_Age > 90 THEN 'Red' WHEN VA.Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END) ,VA.AC_RESPONSIBILITY order by VA.CAUSE_CODE_ALERT_TYPE,VA.AC_NAME, (CASE WHEN VA.Alert_Age > 90 THEN 'Red' WHEN VA.Alert_Age > 45 THEN 'Yellow' ELSE 'Green' END) ,VA.AC_RESPONSIBILITY ")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(CAUSE_CODE_SUMMARY_REPORT_NAME, pAccount.getAccount(),
				CAUSE_CODE_SUMMARY_REPORT_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getSoftwareComplianceSummaryReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter,
			boolean pbCustomerOwnedCustomerManagedSearchChecked,
			boolean pbCustomerOwnedIBMManagedSearchChecked,
			boolean pbIBMOwnedIBMManagedSearchChecked,
			boolean pbIBMO3rdMSearchChecked,
			boolean pbCustO3rdMSearchChecked,
			boolean pbIBMOibmMSWCOSearchChecked,
			boolean pbCustOibmMSWCOSearchChecked,
			boolean pbTitlesNotSpecifiedInContractScopeSearchChecked,
			boolean pbSelectAllChecked)
			throws HibernateException, Exception {
		if (pbSelectAllChecked){
			 pbCustomerOwnedCustomerManagedSearchChecked = true;
			 pbCustomerOwnedIBMManagedSearchChecked= true;
			 pbIBMOwnedIBMManagedSearchChecked= true;
			 pbIBMO3rdMSearchChecked= true;
			 pbCustO3rdMSearchChecked= true;
			 pbIBMOibmMSWCOSearchChecked= true;
			 pbCustOibmMSWCOSearchChecked= true;
			 pbTitlesNotSpecifiedInContractScopeSearchChecked= true;
		}
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"CALL EAADMIN.SwComplianceSum(:customerId, :customerOwnedCustomerManaged, :customerOwnedIBMManaged, :ibmOwnedIBMManaged, :ibmOwned3RDManaged, :customerOwned3RDManaged, :ibmOwnedIbmManagedSWConsumBased, :custOwnedIbmManagedSWConsumBased, :titlesNotSpecifiedInContractScope)")
				.setLong("customerId", pAccount.getId())
				.setInteger("customerOwnedCustomerManaged",
						pbCustomerOwnedCustomerManagedSearchChecked ? 1 : 0)
				.setInteger("customerOwnedIBMManaged",
						pbCustomerOwnedIBMManagedSearchChecked ? 1 : 0)
				.setInteger("ibmOwnedIBMManaged",
						pbIBMOwnedIBMManagedSearchChecked ? 1 : 0)
				.setInteger("ibmOwned3RDManaged",
						pbIBMO3rdMSearchChecked ? 1 : 0)
				.setInteger("customerOwned3RDManaged",
						pbCustO3rdMSearchChecked ? 1 : 0)
				.setInteger("ibmOwnedIbmManagedSWConsumBased",
						pbIBMOibmMSWCOSearchChecked ? 1 : 0)
				.setInteger("custOwnedIbmManagedSWConsumBased",
						pbCustOibmMSWCOSearchChecked ? 1 : 0)
				.setInteger(
						"titlesNotSpecifiedInContractScope",
						pbTitlesNotSpecifiedInContractScopeSearchChecked ? 1
								: 0).scroll(ScrollMode.FORWARD_ONLY);

		printHeader(SOFTWARE_COMPLIANCE_SUMMARY_REPORT_NAME,
				pAccount.getAccount(),
				SOFTWARE_COMPLIANCE_SUMMARY_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getSoftwareLparBaselineReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT SL.Name AS SL_Name, SL.Bios_Serial, VSLP.Processor_Count, SL.ScanTime, CASE LENGTH(RTRIM(COALESCE(CHAR(HSC.Id), ''))) WHEN 0 THEN 'No' ELSE 'Yes' END, H.Serial, MT.Name AS MT_Name, MT.Type FROM EAADMIN.Software_Lpar SL LEFT OUTER JOIN EAADMIN.HW_SW_Composite HSC ON HSC.Software_Lpar_Id = SL.Id LEFT OUTER JOIN EAADMIN.Hardware_Lpar HL ON HL.Id = HSC.Hardware_Lpar_Id LEFT OUTER JOIN EAADMIN.Hardware H ON H.Id = HL.Hardware_Id LEFT OUTER JOIN EAADMIN.Machine_Type MT ON MT.Id = H.Machine_Type_Id, EAADMIN.V_Software_Lpar_Processor VSLP WHERE SL.Customer_Id = :customerId AND SL.Status = 'ACTIVE' AND VSLP.Id = SL.Id ORDER BY SL.Name ASC")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(SOFTWARE_LPAR_BASELINE_REPORT_NAME, pAccount.getAccount(),
				SOFTWARE_LPAR_BASELINE_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getSoftwareVarianceReport(Account pAccount, String remoteUser, String lsName, 
			PrintWriter pPrintWriter) throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT S.Software_Name, COUNT(IS.Software_Id), CAST(NULL AS VARCHAR(256)) FROM EAADMIN.Software S, EAADMIN.Installed_Software IS, EAADMIN.Software_Lpar SL WHERE S.Software_Id = IS.Software_Id AND S.Status = 'ACTIVE' AND S.Level = 'LICENSABLE' AND IS.Discrepancy_Type_Id IN (1, 2, 4) AND IS.Status = 'ACTIVE' AND IS.Software_Lpar_Id = SL.Id AND NOT EXISTS (SELECT SF.Software_Id FROM EAADMIN.Schedule_F SF, EAADMIN.Status S2 WHERE SF.Customer_Id = :customerId AND SF.Software_Id = S.Software_Id AND S2.Id = SF.Status_Id AND S2.Description = 'ACTIVE') AND SL.Customer_Id = :customerId GROUP BY S.Software_Name UNION SELECT S.Software_Name, CAST(0 AS INTEGER), SF.Software_Title FROM EAADMIN.Software S, EAADMIN.Schedule_F SF, EAADMIN.Status S2 WHERE SF.Customer_Id = :customerId AND S2.Id = SF.Status_Id AND S2.Description = 'ACTIVE' AND S.Software_Id = SF.Software_Id AND S.Status = 'ACTIVE' AND NOT EXISTS (SELECT S3.Software_Id FROM EAADMIN.Software S3, EAADMIN.Installed_Software IS, EAADMIN.Software_Lpar SL WHERE S3.Software_Id = S.Software_Id AND S3.Software_Id = IS.Software_Id AND S3.Status = 'ACTIVE' AND S3.Level = 'LICENSABLE' AND IS.Discrepancy_Type_Id IN (1, 2, 4) AND IS.Status = 'ACTIVE' AND IS.Software_Lpar_Id = SL.Id AND SL.Customer_Id = :customerId) ORDER BY Software_Name")
				.setLong("customerId", pAccount.getId())
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(SOFTWARE_VARIANCE_REPORT_NAME, null,
				SOFTWARE_VARIANCE_REPORT_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	@Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
	public void getWorkstationAccountsReport( String remoteUser, String lsName,  PrintWriter pPrintWriter)
			throws HibernateException, Exception {
		ScrollableResults lsrReport = ((Session) getEntityManager()
				.getDelegate())
				.createSQLQuery(
						"SELECT C.Account_Number, C.Customer_Name, CT.Customer_Type_Name, G.Name AS G_Name, R.Name AS R_Name, CC.Name AS CC_Name, S.Sector_Name, COUNT(H.Id), H.Hardware_Status FROM EAADMIN.Customer C, EAADMIN.Customer_Type CT, EAADMIN.Country_Code CC, EAADMIN.Region R, EAADMIN.Geography G, EAADMIN.Sector S, EAADMIN.Industry I, EAADMIN.Hardware H, EAADMIN.Machine_Type MT WHERE C.Status = 'ACTIVE' AND C.Customer_Type_Id = CT.Customer_Type_Id AND CT.Customer_Type_Name LIKE '%WORKSTATION%' AND G.Id = R.Geography_Id AND R.Id = CC.Region_Id AND CC.Id = C.Country_Code_Id AND S.Sector_Id = I.Sector_Id AND I.Industry_Id = C.Industry_Id AND H.Customer_Id = C.Customer_Id AND H.Status = 'ACTIVE' AND MT.Id = H.Machine_Type_Id AND MT.Type != 'WORKSTATION' GROUP BY C.Account_Number, C.Customer_Name, CT.Customer_Type_Name, G.Name, R.Name, CC.Name, S.Sector_Name, H.Hardware_Status ORDER BY C.Account_Number, H.Hardware_Status")
				.scroll(ScrollMode.FORWARD_ONLY);

		printHeader(WORKSTATION_ACCOUNTS_REPORT_NAME, null,
				WORKSTATION_ACCOUNTS_REPORT_COLUMN_HEADERS, pPrintWriter);
		while (lsrReport.next()) {
			pPrintWriter.println(outputData(lsrReport.get()));
		}
		lsrReport.close();
	}

	private String outputData(Object[] poaData, HSSFRow rowct) {

		StringBuffer lsbData = new StringBuffer();
		String lsData = null;

		for (int i = 0; poaData != null && i < poaData.length; i++) {
			lsData = poaData[i] == null ? "" : poaData[i].toString();
			rowct.createCell((int) i).setCellValue(lsData);
		}

		return lsbData.toString();
	}

	private String outputData(Object[] poaData) {
		StringBuffer lsbData = new StringBuffer();
		String lsData = null;

		for (int i = 0; poaData != null && i < poaData.length; i++) {
			lsData = poaData[i] == null ? "" : poaData[i].toString();

			lsbData.append(i == 0 ? "" : "\t").append(lsData);
		}

		return lsbData.toString();
	}

	private String outputReconciliationSummaryData(Object[] poaData,
			Object[] poaPreviousData) {
		StringBuffer lsbData = new StringBuffer();
		String lsData = null;

		for (int i = 0; poaData != null && i < poaData.length; i++) {
			if (poaPreviousData != null
					&& (i == 1 || i == 2 || i == 3)
					&& poaData[0].toString().equalsIgnoreCase(
							poaPreviousData[0].toString())) {
				lsData = "-";
			} else {
				lsData = poaData[i] == null ? "" : poaData[i].toString();
			}

			lsbData.append(i == 0 ? "" : "\t").append(lsData);
		}

		return lsbData.toString();
	}

	private void printHeader(String psReportName, Long plAccountNumber,
			String[] psaColumnHeader, HSSFSheet sheet) {
		HSSFRow rowhead0 = sheet.createRow((int) 0);
		SimpleDateFormat lsdfNow = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		Object[] loaReportHeader = null;

		if (plAccountNumber != null) {
			loaReportHeader = new Object[] { psReportName, plAccountNumber,
					lsdfNow.format(Calendar.getInstance().getTime()) };
		} else {
			loaReportHeader = new Object[] { psReportName,
					lsdfNow.format(Calendar.getInstance().getTime()) };
		}

		rowhead0.createCell((int) 0).setCellValue("IBM Confidential");
		HSSFRow rowhead1 = sheet.createRow((int) 1);
		outputData(loaReportHeader, rowhead1);
		HSSFRow rowhead2 = sheet.createRow((int) 2);
		outputData(psaColumnHeader, rowhead2);
	}

	private void printHeader(String psReportName, Long plAccountNumber,
			String[] psaColumnHeader, PrintWriter pPrintWriter) {
		SimpleDateFormat lsdfNow = new SimpleDateFormat("MM-dd-yyyy HH:mm:ss");
		Object[] loaReportHeader = null;

		if (plAccountNumber != null) {
			loaReportHeader = new Object[] { psReportName, plAccountNumber,
					lsdfNow.format(Calendar.getInstance().getTime()) };
		} else {
			loaReportHeader = new Object[] { psReportName,
					lsdfNow.format(Calendar.getInstance().getTime()) };
		}

		pPrintWriter.println("IBM Confidential");
		pPrintWriter.println(outputData(loaReportHeader));
		pPrintWriter.println(outputData(psaColumnHeader));
	}
	
	private EntityManager getEntityManager() {
		try {
			dbdeterminativeService.setEntityManager();
		} catch (HibernateException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return dbdeterminativeService.getEntityManager();
	}
}

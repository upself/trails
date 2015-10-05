package com.ibm.asset.trails.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.regex.Pattern;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.apache.log4j.Logger;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFDateUtil;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Row;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.AlertCause;
import com.ibm.asset.trails.domain.AlertExpiredScan;
import com.ibm.asset.trails.domain.AlertExpiredScanH;
import com.ibm.asset.trails.domain.AlertHardware;
import com.ibm.asset.trails.domain.AlertHardwareCfgData;
import com.ibm.asset.trails.domain.AlertHardwareCfgDataH;
import com.ibm.asset.trails.domain.AlertHardwareH;
import com.ibm.asset.trails.domain.AlertHardwareLpar;
import com.ibm.asset.trails.domain.AlertHardwareLparH;
import com.ibm.asset.trails.domain.AlertSoftwareLpar;
import com.ibm.asset.trails.domain.AlertSoftwareLparH;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.AlertUnlicensedSwH;
import com.ibm.asset.trails.domain.CauseCode;
import com.ibm.asset.trails.domain.CauseCodeHistory;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.CauseCodeService;
import com.ibm.bluepages.BPResults;
import com.ibm.bluepages.BluePages;
import com.ibm.ea.common.State;
import com.ibm.ea.common.State.EStatus;

@Service
public class CauseCodeServiceImpl implements CauseCodeService {

	private EntityManager em;

	private static final Logger log = Logger
			.getLogger(CauseCodeServiceImpl.class);

	private final static int ROW_ALERT_TYPE = 1;
	private final static int ROW_TABLE_HEAD = 2;
	private final static int COL_ALERT_TYPE = 0;

	private final static String ERROR_UNKONW_TYPE = "Please do not change the structure of the report.";
	private final static String ERROR_INTERNAL_ID_NOT_EXIST = "Internal id not exists";
	private final static String ERROR_BAD_DATE_FORMAT = "Please ensure the cell is date formatted or valid string value with format YYYY-MM-DD, YYYY/MM/DD or MM/DD/YYYY";
	private static final String ERROR_UNKNOW_OWNER = "Please use an Email Address, as specified in Blue Pages";
	private static final String ERROR_UNKONW_CAUSE_CODE = "Unknown alert cause or it's inactive";
	private static final String ERROR_ALERT_TYPE_NOT_MATCH = "Alert type not match";
	
	private ECauseCodeReport colIndexes;

	private final static String STEP2_LABEL = "VALIDATE";
	private final static String STEP3_LABEL = "PERSISTE";

	private static final String SOM1a_REPORT_NAME = "SOM1a: HW WITH HOSTNAME";
	private static final String SOM1b_REPORT_NAME = "SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED";
	private static final String SOM2a_REPORT_NAME = "SOM2a: HW LPAR WITH SW LPAR";
	private static final String SOM2b_REPORT_NAME = "SOM2b: SW LPAR WITH HW LPAR";
	private static final String SOM2c_REPORT_NAME = "SOM2c: UNEXPIRED SW LPAR";
	private static final String SOM3_REPORT_NAME  = "SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE";
	private static final String SOM4a_REPORT_NAME = "SOM4a: IBM SW INSTANCES REVIEWED";
	private static final String SOM4b_REPORT_NAME = "SOM4b: PRIORITY ISV SW INSTANCES REVIEWED";
	private static final String SOM4c_REPORT_NAME = "SOM4c: ISV SW INSTANCES REVIEWED";
	
	private static final String DASH  = "-";
	private static final String SLASH = "/";
	private static final String DATE_FORMAT1 = "yyyy-MM-dd";
	private static final String DATE_FORMAT2 = "yyyy/MM/dd";
	private static final String DATE_FORMAT3 = "MM/dd/yyyy";
	
	@Autowired
	private AccountService accountService;

	private EntityManager getEntityManager() {
		return em;
	}

	@PersistenceContext(unitName = "trailspd")
	public void setEntityManager(EntityManager em) {
		this.em = em;
	}

	public AccountService getAccountService() {
		return accountService;
	}

	public void setAccountService(AccountService accountService) {
		this.accountService = accountService;
	}

	@Transactional(readOnly = true, propagation = Propagation.REQUIRES_NEW)
	public ByteArrayOutputStream loadSpreadsheet(File file, String remoteUser,
			List<State> steps) throws IOException {

		ByteArrayOutputStream bos = null;

		FileInputStream fin = new FileInputStream(file);
		HSSFWorkbook wb = new HSSFWorkbook(fin);

		HSSFSheet sheet = wb.getSheetAt(0);

		HSSFCell reportNameCell = sheet.getRow(ROW_ALERT_TYPE).getCell(
				COL_ALERT_TYPE);
		String reportName = reportNameCell.getStringCellValue().trim();

		HSSFCellStyle errorStyle = wb.createCellStyle();
		errorStyle.setFillForegroundColor(HSSFColor.RED.index);
		errorStyle.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

		colIndexes = ECauseCodeReport.getReportByName(reportName);

		boolean error = validateExcelCauseCodeContent(sheet, errorStyle, steps);

		if (!error) {
			saveCauseCode(wb, remoteUser, steps);
		} else {
			State state = State.findStateByLable(steps, STEP3_LABEL);
			if (state == null) {
				state = new State();
				state.setDescription("Persist changes");
				state.setLabel(STEP3_LABEL);
				state.setStatus(EStatus.IGNORED);
				steps.add(state);
			}
		}

		bos = new ByteArrayOutputStream();
		wb.write(bos);

		return bos;

	}

	@SuppressWarnings("unchecked")
	private boolean validateExcelCauseCodeContent(HSSFSheet sheet,
			HSSFCellStyle errorStyle, List<State> steps) {

		State state = State.findStateByLable(steps, STEP2_LABEL);
		if (state == null) {
			state = new State();
			state.setDescription("Data validation");
			state.setLabel(STEP2_LABEL);
			state.setStatus(EStatus.IN_PROGRESS);
			steps.add(state);
		}

		boolean error = false;
		if (colIndexes == null) {
			int lastCellNO = sheet.getRow(ROW_ALERT_TYPE).getLastCellNum();
			HSSFCell cell = sheet.getRow(ROW_ALERT_TYPE).createCell(
					lastCellNO + 1);
			cell.setCellStyle(errorStyle);
			cell.setCellValue(new HSSFRichTextString(ERROR_UNKONW_TYPE));
			error = true;
		} else {
			Iterator<Row> rowIter = sheet.rowIterator();
			int rowCounter = -1;
			int totalRows = sheet.getLastRowNum();
			int colStart = colIndexes.getColCauseCode();
			int colEnd = colIndexes.getColInternalId();
			
			while (rowIter.hasNext()) {
				HSSFRow row = (HSSFRow) rowIter.next();
				rowCounter++;
				
				int progress = (int) ((float) rowCounter / totalRows * 100);
				state.setProgress(progress);

				if (rowCounter <= ROW_TABLE_HEAD) {
					continue;
				}

				StringBuffer errorMsg = new StringBuffer();
				for (int col = colStart; col <= colEnd; col++) {
					HSSFCell cell = row.getCell(col);

					if (col == colIndexes.getColInternalId()) {
						if (!isCauseCodeExists(cell)) {

							buildErrorMsg(errorMsg,
									colIndexes.getColInternalId(),
									"Internal ID", ERROR_INTERNAL_ID_NOT_EXIST);
						} else {
							Long alertTypeId = getAlertTypeId(cell);
							if (alertTypeId != null
									&& alertTypeId != this.getAlertTypeIdByCode(colIndexes.getAlertTypeCode())
									&& alertTypeId != 17// Bypass alert type id
														// value validation for
														// the existing alert
														// type id
														// 17(NOLIC=UNLICENSED
														// SW) Cause Code DB
														// Record
							) {
								buildErrorMsg(errorMsg,
										colIndexes.getColInternalId(),
										"Internal ID",
										ERROR_ALERT_TYPE_NOT_MATCH);
							}
						}

					}

					if (col == colIndexes.getColCauseCode()) {
						if (cell == null) {
							buildErrorMsg(errorMsg,
									colIndexes.getColCauseCode(),
									"Cause Code (CC)", ERROR_UNKONW_CAUSE_CODE);
							continue;
						}
						HSSFCell causeCodeIdCell = row.getCell(colIndexes
								.getColInternalId());
						if (!isCauseCodeExists(causeCodeIdCell)) {
							buildErrorMsg(errorMsg,
									colIndexes.getColCauseCode(),
									"Cause Code (CC)", ERROR_UNKONW_CAUSE_CODE);
							continue;
						}

						boolean pass = true;
						// if no change continue;
						String alertCauseNameInCell = null;
						if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
							alertCauseNameInCell = cell.getStringCellValue();
						} else {
							pass = false;
						}

						if (alertCauseNameInCell == null
								|| "".equals(alertCauseNameInCell.trim())) {
							pass = false;
						}

						if (!pass) {
							buildErrorMsg(errorMsg,
									colIndexes.getColCauseCode(),
									"Cause Code (CC)", ERROR_UNKONW_CAUSE_CODE);
							continue;
						}

						if (alertCauseNameInCell.length() > 128) {
							alertCauseNameInCell = alertCauseNameInCell
									.substring(0, 128);
						}
						
						String alertCauseNameInDb = getAlertCauseName(causeCodeIdCell);
						// compare the cc name and cause code name under id. if
						// not same check it's availability. if same ignore.
						if (!strCompare(alertCauseNameInDb,
								alertCauseNameInCell)) {

							List<AlertCause> acList = null;
							try {
								acList = getEntityManager()
										.createNamedQuery(
												"findActiveAlertCauseByNameAndTypeId")
										.setParameter(
												"alertCauseName",
												alertCauseNameInCell.trim()
														.toUpperCase())
										.setParameter("alertTypeId",
												this.getAlertTypeIdByCode(colIndexes.getAlertTypeCode()))
										.getResultList();
								if (acList.size() <= 0) {
									buildErrorMsg(errorMsg,
											colIndexes.getColCauseCode(),
											"Cause Code (CC)",
											ERROR_UNKONW_CAUSE_CODE);
								}
							} catch (Exception e) {
								log.error(e.getMessage(), e);
							}
						}

					}

					if (col == colIndexes.getColTargetDate()) {
						if (!isDateFormat(cell)){//CC Target Date is an optional field
							buildErrorMsg(errorMsg,
									colIndexes.getColTargetDate(),
									"CC target date", ERROR_BAD_DATE_FORMAT);
						}
					}

					if (col == colIndexes.getColOwner()) {
						if (!isOwnerExistsInBluePage(cell)){//CC Owner is an optional field
							buildErrorMsg(errorMsg, colIndexes.getColOwner(),
									"CC owner", ERROR_UNKNOW_OWNER);
						}
					}
				}

				if (errorMsg.length() > 0) {
					HSSFCell msgCell = row.createCell(colIndexes
							.getColMessage());
					msgCell.setCellStyle(errorStyle);
					msgCell.setCellValue(new HSSFRichTextString(errorMsg
							.toString()));
					error = true;
				}
			}
		}

		if (error) {
			state.setStatus(EStatus.FAILED);
		} else {
			if (state.getProgress() == 100
					&& state.getStatus().getPriority() < EStatus.FINISHED
							.getPriority()) {
				state.setStatus(EStatus.FINISHED);
			}
		}
		return error;
	}

	private void saveCauseCode(HSSFWorkbook wb, String remoteUser,
			List<State> steps) {
		HSSFSheet sheet = wb.getSheetAt(0);
		Iterator<Row> rowIter = sheet.rowIterator();

		State state = State.findStateByLable(steps, STEP3_LABEL);
		if (state == null) {
			state = new State();
			state.setDescription("Persist changes");
			state.setLabel(STEP3_LABEL);
			state.setStatus(EStatus.IN_PROGRESS);
			steps.add(state);
		}

		int rowCounter = -1;
		int totalRows = sheet.getLastRowNum();
		while (rowIter.hasNext()) {
			HSSFRow row = (HSSFRow) rowIter.next();
			rowCounter++;

			int progress = (int) ((float) rowCounter / totalRows * 100);
			state.setProgress(progress);
			if (progress == 100) {
				state.setStatus(EStatus.FINISHED);
			}

			if (rowCounter <= ROW_TABLE_HEAD) {
				continue;
			}

			HSSFCell causeCodeIdCell = row.getCell(colIndexes
					.getColInternalId());

			long causeCodeId = -1;
			if (causeCodeIdCell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
				causeCodeId = Long
						.valueOf(causeCodeIdCell.getStringCellValue());
			} else if (causeCodeIdCell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
				causeCodeId = Math.round(causeCodeIdCell.getNumericCellValue());
			}

			CauseCode causeCode = (CauseCode) getEntityManager()
					.createNamedQuery("getCauseCodeById")
					.setParameter("id", causeCodeId).getSingleResult();

			String causeCodeName = causeCode.getAlertCause().getName();
			String colCauseCode = row.getCell(colIndexes.getColCauseCode())
					.getStringCellValue().trim();

			Date targetDate = causeCode.getTargetDate();
			HSSFCell targetDateCell = row
					.getCell(colIndexes.getColTargetDate());
			Date colTargetDate = null;
			if (targetDateCell != null) {
				if (targetDateCell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC
						&& HSSFDateUtil.isCellDateFormatted(targetDateCell)) {
					colTargetDate = targetDateCell.getDateCellValue();
				}
			}
			String owner = causeCode.getOwner();
			String colOwner = row.getCell(colIndexes.getColOwner())
					.getStringCellValue().trim();

			//Assignee Comments Function Start
			if (colIndexes.getColAssigneeComments() != -1) {
				HSSFCell assigneeCommentsCell = row.getCell(colIndexes
						.getColAssigneeComments());

				String assigneeComments = "";
				if (assigneeCommentsCell!=null && assigneeCommentsCell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
					assigneeComments = assigneeCommentsCell
							.getStringCellValue();
				}

				if (assigneeComments != null
						&& !"".equals(assigneeComments.trim())) {
					updateAssigneeComments(causeCode.getAlertId(),
							assigneeComments.trim(), colIndexes.getReportName()
									.trim(), remoteUser);
				}
			}
			//Assignee Comments Function End 
			
			boolean changed = false;

			if (!strCompare(causeCodeName, colCauseCode)
					|| !dateCompare(targetDate, colTargetDate)
					|| !strCompare(owner, colOwner)){
				changed = true;
			}

			if (!changed) {
				continue;
			}

			CauseCodeHistory history = new CauseCodeHistory();
			history.setCauseCode(causeCode);
			history.setAlertType(causeCode.getAlertType());
			history.setAlertId(causeCode.getAlertId());
			history.setAlertCause(causeCode.getAlertCause());
			history.setTargetDate(causeCode.getTargetDate());
			history.setOwner(causeCode.getOwner());
			history.setRecordTime(causeCode.getRecordTime());
			history.setRemoteUser(causeCode.getRemoteUser());

			if (!strCompare(causeCodeName, colCauseCode)) {
				AlertCause alertCause = (AlertCause) getEntityManager()
						.createNamedQuery("findAlertCauseByName")
						.setParameter("name", colCauseCode.trim().toUpperCase())
						.getSingleResult();
				causeCode.setAlertCause(alertCause);
			}

			if (!dateCompare(targetDate, colTargetDate)) {
				causeCode.setTargetDate(colTargetDate);
			}

			if (!strCompare(owner, colOwner)) {
				causeCode.setOwner(colOwner);
			}

			causeCode.setRemoteUser(remoteUser);
			causeCode.setRecordTime(new Date());

			try {
				getEntityManager().persist(history);
				getEntityManager().persist(causeCode);
				getEntityManager().flush();
			} catch (Exception e) {
				log.error(e.getMessage(), e);
			}			
		}

	}

	@SuppressWarnings("deprecation")
	private boolean dateCompare(Date dbValue, Date cellValue) {
		if (cellValue == null || "".equals(cellValue.toString())) {
			return true;
		}

		if (dbValue == cellValue) {
			return true;
		}
		if (dbValue == null && cellValue != null) {
			return false;
		}

		if (dbValue != null && cellValue == null) {
			return false;
		}

	    int dbValueYear = dbValue.getYear();
	    int dbValueMonth = dbValue.getMonth();
	    int dbValueDay = dbValue.getDay();
	    int cellValueYear = cellValue.getYear();
	    int cellValueMonth = cellValue.getMonth();
	    int cellValueDay = cellValue.getDay();
	    
	    if(dbValueYear == cellValueYear
	    && dbValueMonth == cellValueMonth
	    && dbValueDay == cellValueDay){
	      return true;
	    }
	    else{
	      return false;
	    }
	}

	private boolean strCompare(String dbValue, String cellValue) {
		if (cellValue == null || "".equals(cellValue.trim())) {
			return true;
		}

		if (dbValue == cellValue) {
			return true;
		}
		if (dbValue == null && cellValue != null) {
			return false;
		}

		if (dbValue != null && cellValue == null) {
			return false;
		}

		return dbValue.trim().equals(cellValue.trim());
	}

	private void buildErrorMsg(StringBuffer result, int columnNo,
			String colName, String errorMsg) {
		result.append(" Error: column " + columnNo + ":" + colName + ",");
		result.append(errorMsg);
	}

	private boolean isOwnerExistsInBluePage(HSSFCell cell){
		if (cell == null) {
			return true;
		}

		if (cell.getCellType() == HSSFCell.CELL_TYPE_BLANK) {
			return true;
		}

		if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
			String internetId = cell.getStringCellValue();
			if (internetId == null || "".equals(internetId.trim())) {
				return true;
			}
			BPResults result = BluePages.getPersonsByInternet(internetId);
			return result.hasColumn("EMPNUM");
		}
		return false;
	}

	private boolean isDateFormat(HSSFCell cell){
		if (cell == null || cell.getCellType() == HSSFCell.CELL_TYPE_BLANK) {
			return true;
		}
		
		if (cell.getCellType() == HSSFCell.CELL_TYPE_ERROR) {
			return true;
		}

		if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
			String dateStr = cell.getStringCellValue();
			if (dateStr == null || "".equals(dateStr.trim())){
				return true;
			}
			else{
				dateStr = dateStr.trim();
				int dateLen = dateStr.length();
				if(dateLen!=10){
				 return false;	
				}
				else{
				  boolean dashFormat = dateStr.indexOf(DASH)!=-1;
				  if(dashFormat){//DASH Date Format: YYYY-MM-DD
					  SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT1);
					  try{
						  format.setLenient(false);
						  format.parse(dateStr);
						  return true;
					  }
					  catch(ParseException e){
						  return false;
					  }
				  }
				  else{
					  SimpleDateFormat format = new SimpleDateFormat(DATE_FORMAT2);//SLASH Date Format: YYYY/MM/DD
					  try{
						  format.setLenient(false);
						  format.parse(dateStr);
						  return true;
					  }
					  catch(ParseException e){
						  format = new SimpleDateFormat(DATE_FORMAT3);//SLASH Date Format: MM/DD/YYYY
						  try{
							  format.setLenient(false);
							  format.parse(dateStr);
							  return true;
						  }
						  catch(ParseException ex){
							  return false;
						  } 
					  } 
				  }
				}
			}
		}

		if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC
				&& HSSFDateUtil.isCellDateFormatted(cell)) {
			return true;
		}
		
		return false;
	}
	
	@SuppressWarnings("unchecked")
	private boolean isAlertCauseExists(HSSFCell cell) {
		String alertCause;
		if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
			alertCause = cell.getStringCellValue();
		} else {
			return false;
		}

		if (alertCause.length() > 128) {
			alertCause = alertCause.substring(0, 128);
		}

		if (alertCause == null || "".equals(alertCause)) {
			return false;
		}

		List<AlertCause> acList = null;
		try {
			acList = getEntityManager()
					.createNamedQuery("findActiveAlertCauseByNameAndTypeId")
					.setParameter("alertCauseName",
							alertCause.trim().toUpperCase())
					.setParameter("alertTypeId", this.getAlertTypeIdByCode(colIndexes.getAlertTypeCode()))
					.getResultList();
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return acList.size() >= 1;
	}

	private Long getAlertTypeId(HSSFCell cell) {

		Long causeCodeId = parseCauseCodeIdCell(cell);
		if (causeCodeId == null) {
			return null;
		}

		Long alertTypeId = (Long) getEntityManager()
				.createNamedQuery("getAlertTypeId")
				.setParameter("id", causeCodeId).getSingleResult();
		return alertTypeId;
	}

	private String getAlertCauseName(HSSFCell cell) {

		Long causeCodeId = parseCauseCodeIdCell(cell);
		if (causeCodeId == null) {
			return null;
		}

		String name = (String) getEntityManager()
				.createNamedQuery("getAlertCauseName")
				.setParameter("id", causeCodeId).getSingleResult();
		return name;
	}

	private boolean isCauseCodeExists(HSSFCell cell) {
		Long causeCodeId = parseCauseCodeIdCell(cell);
		if (causeCodeId == null) {
			return false;
		}

		Long id = (Long) getEntityManager()
				.createNamedQuery("isCauseCodeExists")
				.setParameter("id", causeCodeId).getSingleResult();

		if (id != null && id != 0) {
			return true;
		}

		return false;
	}

	private Long parseCauseCodeIdCell(HSSFCell cell) {

		long causeCodeId;
		if (cell != null && cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
			String content = cell.getStringCellValue();
			Pattern pattern = Pattern.compile("[0-9]*");
			if (!pattern.matcher(content).matches()) {
				return null;
			}
			causeCodeId = Long.valueOf(content);
		} else if (cell != null
				&& cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
			causeCodeId = Math.round(cell.getNumericCellValue());
		} else {
			return null;
		}
		return causeCodeId;
	}

	private Long getAlertTypeIdByCode(String alertTypeCode){
	  Long alertTypeId = (Long) getEntityManager()
				.createNamedQuery("getAlertTypeIdByCode")
				.setParameter("code", alertTypeCode).getSingleResult();

	  return alertTypeId;
	}
	
	@SuppressWarnings("unchecked")
	private void updateAssigneeComments(long alertId, String assigneeComments,
			String reportName, String remoteUser) {
		if (reportName != null && !"".equals(reportName.trim())) {
			if (reportName.equalsIgnoreCase(SOM1a_REPORT_NAME)){//SOM1a: HW WITH HOSTNAME
				List<AlertHardware> ahList = null;
				try {
					ahList = getEntityManager()
							.createNamedQuery("alertHardwareById")
							.setParameter("id", alertId).getResultList();
				} catch (Exception e) {
					log.error(e.getMessage(), e);
				}

				if (ahList.size() >= 1) {
					AlertHardware ahInDB = ahList.get(0);
					String assigneeCommentsInDB = ahInDB.getComments();
					if (!strCompare(assigneeCommentsInDB, assigneeComments)) {

						AlertHardwareH ahHistory = new AlertHardwareH();
						ahHistory.setAlertHardware(ahInDB);
						ahHistory.setComments(ahInDB.getComments());
						ahHistory.setRemoteUser(ahInDB.getRemoteUser());
						ahHistory.setCreationTime(ahInDB.getCreationTime());
						ahHistory.setRecordTime(ahInDB.getRecordTime());
						ahHistory.setOpen(ahInDB.isOpen());

						ahInDB.setComments(assigneeComments);
						ahInDB.setRemoteUser(remoteUser);
						ahInDB.setRecordTime(new Date());

						try {
							getEntityManager().persist(ahHistory);
							getEntityManager().persist(ahInDB);
							getEntityManager().flush();
						} catch (Exception e) {
							log.error(e.getMessage(), e);
						}
					}
				}
			}
			else if(reportName.equalsIgnoreCase(SOM1b_REPORT_NAME)){//SOM1b: HW BOX CRITICAL CONFIGURATION DATA POPULATED
				List<AlertHardwareCfgData> ahcfgList = null;
				try {
					ahcfgList = getEntityManager()
							.createNamedQuery("alertHardwareCfgDataById")
							.setParameter("id", alertId).getResultList();
				} catch (Exception e) {
					log.error(e.getMessage(), e);
				}

				if (ahcfgList.size() >= 1) {
					AlertHardwareCfgData ahcfgInDB = ahcfgList.get(0);
					String assigneeCommentsInDB = ahcfgInDB.getComments();
					if (!strCompare(assigneeCommentsInDB, assigneeComments)) {

						AlertHardwareCfgDataH ahcfgHistory = new AlertHardwareCfgDataH();
						ahcfgHistory.setAlertHardwareCfgData(ahcfgInDB);
						ahcfgHistory.setComments(ahcfgInDB.getComments());
						ahcfgHistory.setRemoteUser(ahcfgInDB.getRemoteUser());
						ahcfgHistory.setCreationTime(ahcfgInDB.getCreationTime());
						ahcfgHistory.setRecordTime(ahcfgInDB.getRecordTime());
						ahcfgHistory.setOpen(ahcfgInDB.isOpen());

						ahcfgInDB.setComments(assigneeComments);
						ahcfgInDB.setRemoteUser(remoteUser);
						ahcfgInDB.setRecordTime(new Date());

						try {
							getEntityManager().persist(ahcfgHistory);
							getEntityManager().persist(ahcfgInDB);
							getEntityManager().flush();
						} catch (Exception e) {
							log.error(e.getMessage(), e);
						}
					}
				}
			}
			else if(reportName.equalsIgnoreCase(SOM2a_REPORT_NAME)){//SOM2a: HW LPAR WITH SW LPAR
				List<AlertHardwareLpar> ahwLparList = null;
				try {
					ahwLparList = getEntityManager()
							.createNamedQuery("alertHardwareLparById")
							.setParameter("id", alertId).getResultList();
				} catch (Exception e) {
					log.error(e.getMessage(), e);
				}

				if (ahwLparList.size() >= 1) {
					AlertHardwareLpar ahwLparInDB = ahwLparList.get(0);
					String assigneeCommentsInDB = ahwLparInDB.getComments();
					if (!strCompare(assigneeCommentsInDB, assigneeComments)) {

						AlertHardwareLparH ahwLparHistory = new AlertHardwareLparH();
						ahwLparHistory.setAlertHardwareLpar(ahwLparInDB);
						ahwLparHistory.setComments(ahwLparInDB.getComments());
						ahwLparHistory.setRemoteUser(ahwLparInDB.getRemoteUser());
						ahwLparHistory.setCreationTime(ahwLparInDB.getCreationTime());
						ahwLparHistory.setRecordTime(ahwLparInDB.getRecordTime());
						ahwLparHistory.setOpen(ahwLparInDB.isOpen());

						ahwLparInDB.setComments(assigneeComments);
						ahwLparInDB.setRemoteUser(remoteUser);
						ahwLparInDB.setRecordTime(new Date());

						try {
							getEntityManager().persist(ahwLparHistory);
							getEntityManager().persist(ahwLparInDB);
							getEntityManager().flush();
						} catch (Exception e) {
							log.error(e.getMessage(), e);
						}
					}
				}
			}
			else if(reportName.equalsIgnoreCase(SOM2b_REPORT_NAME)){//SOM2b: SW LPAR WITH HW LPAR
				List<AlertSoftwareLpar> aswLparList = null;
				try {
					aswLparList = getEntityManager()
							.createNamedQuery("alertSoftwareLparById")
							.setParameter("id", alertId).getResultList();
				} catch (Exception e) {
					log.error(e.getMessage(), e);
				}

				if (aswLparList.size() >= 1) {
					AlertSoftwareLpar aswLparInDB = aswLparList.get(0);
					String assigneeCommentsInDB = aswLparInDB.getComments();
					if (!strCompare(assigneeCommentsInDB, assigneeComments)) {

						AlertSoftwareLparH aswLparHistory = new AlertSoftwareLparH();
						aswLparHistory.setAlertSoftwareLpar(aswLparInDB);
						aswLparHistory.setComments(aswLparInDB.getComments());
						aswLparHistory.setRemoteUser(aswLparInDB.getRemoteUser());
						aswLparHistory.setCreationTime(aswLparInDB.getCreationTime());
						aswLparHistory.setRecordTime(aswLparInDB.getRecordTime());
						aswLparHistory.setOpen(aswLparInDB.isOpen());

						aswLparInDB.setComments(assigneeComments);
						aswLparInDB.setRemoteUser(remoteUser);
						aswLparInDB.setRecordTime(new Date());

						try {
							getEntityManager().persist(aswLparHistory);
							getEntityManager().persist(aswLparInDB);
							getEntityManager().flush();
						} catch (Exception e) {
							log.error(e.getMessage(), e);
						}
					}
				}
			}
			else if(reportName.equalsIgnoreCase(SOM2c_REPORT_NAME)){//SOM2c: UNEXPIRED SW LPAR
				List<AlertExpiredScan> aexpiredScanList = null;
				try {
					aexpiredScanList = getEntityManager()
							.createNamedQuery("alertExpiredScanById")
							.setParameter("id", alertId).getResultList();
				} catch (Exception e) {
					log.error(e.getMessage(), e);
				}

				if (aexpiredScanList.size() >= 1) {
					AlertExpiredScan aexpiredScanInDB = aexpiredScanList.get(0);
					String assigneeCommentsInDB = aexpiredScanInDB.getComments();
					if (!strCompare(assigneeCommentsInDB, assigneeComments)) {

						AlertExpiredScanH aexpiredScanHistory = new AlertExpiredScanH();
						aexpiredScanHistory.setAlertExpiredScan(aexpiredScanInDB);
						aexpiredScanHistory.setComments(aexpiredScanInDB.getComments());
						aexpiredScanHistory.setRemoteUser(aexpiredScanInDB.getRemoteUser());
						aexpiredScanHistory.setCreationTime(aexpiredScanInDB.getCreationTime());
						aexpiredScanHistory.setRecordTime(aexpiredScanInDB.getRecordTime());
						aexpiredScanHistory.setOpen(aexpiredScanInDB.isOpen());

						aexpiredScanInDB.setComments(assigneeComments);
						aexpiredScanInDB.setRemoteUser(remoteUser);
						aexpiredScanInDB.setRecordTime(new Date());

						try {
							getEntityManager().persist(aexpiredScanHistory);
							getEntityManager().persist(aexpiredScanInDB);
							getEntityManager().flush();
						} catch (Exception e) {
							log.error(e.getMessage(), e);
						}
					}
				}
			}
			else if (reportName.equalsIgnoreCase(SOM3_REPORT_NAME)//SOM3: SW INSTANCES WITH DEFINED CONTRACT SCOPE
				   ||reportName.equalsIgnoreCase(SOM4a_REPORT_NAME)//SOM4a: IBM SW INSTANCES REVIEWED
				   ||reportName.equalsIgnoreCase(SOM4b_REPORT_NAME)//SOM4b: PRIORITY ISV SW INSTANCES REVIEWED
				   ||reportName.equalsIgnoreCase(SOM4c_REPORT_NAME)//SOM4c: ISV SW INSTANCES REVIEWED
					){
				List<AlertUnlicensedSw> ausList = null;
				try {
					ausList = getEntityManager()
							.createNamedQuery("alertUnlicensedSwListById")
							.setParameter("idList", alertId).getResultList();
				} catch (Exception e) {
					log.error(e.getMessage(), e);
				}

				if (ausList.size() >= 1) {
					AlertUnlicensedSw ausInDB = ausList.get(0);
					String assigneeCommentsInDB = ausInDB.getComments();
					if (!strCompare(assigneeCommentsInDB, assigneeComments)) {

						AlertUnlicensedSwH ausHistory = new AlertUnlicensedSwH();
						ausHistory.setAlertUnlicensedSw(ausInDB);
						ausHistory.setComments(ausInDB.getComments());
						ausHistory.setType(ausInDB.getType());
						ausHistory.setRemoteUser(ausInDB.getRemoteUser());
						ausHistory.setCreationTime(ausInDB.getCreationTime());
						ausHistory.setRecordTime(ausInDB.getRecordTime());
						ausHistory.setOpen(ausInDB.isOpen());

						ausInDB.setComments(assigneeComments);
						ausInDB.setRemoteUser(remoteUser);
						ausInDB.setRecordTime(new Date());

						try {
							getEntityManager().persist(ausHistory);
							getEntityManager().persist(ausInDB);
							getEntityManager().flush();
						} catch (Exception e) {
							log.error(e.getMessage(), e);
						}
					}
				}
			}
		}
	}
}

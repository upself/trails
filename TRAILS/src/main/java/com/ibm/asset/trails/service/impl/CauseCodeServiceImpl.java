package com.ibm.asset.trails.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.Date;
import java.util.Iterator;
import java.util.List;

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
import com.ibm.asset.trails.domain.CauseCode;
import com.ibm.asset.trails.domain.CauseCodeHistory;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.CauseCodeService;
import com.ibm.bluepages.BPResults;
import com.ibm.bluepages.BluePages;

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
	private final static String ERROR_BAD_DATE_FORMAT = "Please use the following format for dates: YYYY-MM-DD";
	private static final String ERROR_UNKNOW_OWNER = "Please use an Email Address, as specified in Blue Pages";
	private static final String ERROR_UNKONW_CAUSE_CODE = "Unknown alert cause";

	private ECauseCodeReport colIndexes;

	@Autowired
	private AccountService accountService;

	private EntityManager getEntityManager() {
		return em;
	}

	@PersistenceContext
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
	public ByteArrayOutputStream loadSpreadsheet(File file, String remoteUser) {

		ByteArrayOutputStream bos = null;
		try {
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

			boolean error = validateExcelCauseCodeContent(sheet, errorStyle);

			if (!error) {
				saveCauseCode(wb, remoteUser);
			}

			bos = new ByteArrayOutputStream();
			wb.write(bos);

		} catch (FileNotFoundException e) {
			log.error(e.getMessage(), e);
		} catch (IOException e) {
			log.error(e.getMessage(), e);
		}

		return bos;

	}

	private boolean validateExcelCauseCodeContent(HSSFSheet sheet,
			HSSFCellStyle errorStyle) {

		boolean error = false;
		if (colIndexes == null) {
			HSSFCell cell = sheet.getRow(ROW_ALERT_TYPE).createCell(
					colIndexes.getColMessage());
			cell.setCellStyle(errorStyle);
			cell.setCellValue(new HSSFRichTextString(ERROR_UNKONW_TYPE));
			error = true;
		} else {
			Iterator<Row> rowIter = sheet.rowIterator();
			int rowCounter = -1;
			while (rowIter.hasNext()) {
				HSSFRow row = (HSSFRow) rowIter.next();
				rowCounter++;

				if (rowCounter <= ROW_TABLE_HEAD) {
					continue;
				}

				StringBuffer errorMsg = new StringBuffer();
				for (int col = 9; col <= 14; col++) {
					HSSFCell cell = row.getCell(col);

					if (col == colIndexes.getColInternalId()) {
						if (!isCauseCodeExists(cell)) {

							buildErrorMsg(errorMsg,
									colIndexes.getColInternalId(),
									ERROR_INTERNAL_ID_NOT_EXIST);
						}
					}

					if (col == colIndexes.getColCauseCode()) {
						if (!isAlertCauseExists(cell)) {

							buildErrorMsg(errorMsg,
									colIndexes.getColCauseCode(),
									ERROR_UNKONW_CAUSE_CODE);
						}
					}

					if (col == colIndexes.getColTargetDate()) {
						if (!isDateFormat(cell)) {
							buildErrorMsg(errorMsg,
									colIndexes.getColTargetDate(),
									ERROR_BAD_DATE_FORMAT);
						}
					}

					if (col == colIndexes.getColOwner()) {
						if (!isOwnerExistsInBluePage(cell)) {
							buildErrorMsg(errorMsg, colIndexes.getColOwner(),
									ERROR_UNKNOW_OWNER);
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
		return error;
	}

	private void saveCauseCode(HSSFWorkbook wb, String remoteUser) {
		HSSFSheet sheet = wb.getSheetAt(0);
		Iterator<Row> rowIter = sheet.rowIterator();
		int rowCounter = -1;
		while (rowIter.hasNext()) {
			HSSFRow row = (HSSFRow) rowIter.next();
			rowCounter++;

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
			Date colTargetDate = row.getCell(colIndexes.getColTargetDate())
					.getDateCellValue();

			String owner = causeCode.getOwner();
			String colOwner = row.getCell(colIndexes.getColOwner())
					.getStringCellValue().trim();

			boolean changed = false;

			if (!strCompare(causeCodeName, colCauseCode)
					|| !dateCompare(targetDate, colTargetDate)
					|| !strCompare(owner, colOwner)) {
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
						.setParameter("name", colCauseCode).getSingleResult();
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

	private boolean dateCompare(Date dbValue, Date cellValue) {
		if (cellValue == null || "".equals(cellValue)) {
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

		return dbValue.equals(cellValue);
	}

	private boolean strCompare(String dbValue, String cellValue) {
		if (cellValue == null || "".equals(cellValue)) {
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

		return dbValue.equals(cellValue);
	}

	private void buildErrorMsg(StringBuffer result, int columnNo,
			String errorMsg) {
		result.append(" Error: coloumn " + columnNo + " ");
		result.append(errorMsg);
	}

	private boolean isOwnerExistsInBluePage(HSSFCell cell) {
		if (cell.getCellType() == HSSFCell.CELL_TYPE_BLANK) {
			return true;
		}

		if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
			String internetId = cell.getStringCellValue().trim();
			BPResults result = BluePages.getPersonsByInternet(internetId);
			return result.hasColumn("EMPNUM");
		}
		return false;
	}

	private boolean isDateFormat(HSSFCell cell) {
		if (cell.getCellType() == HSSFCell.CELL_TYPE_BLANK) {
			return true;
		}

		if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC
				&& HSSFDateUtil.isCellDateFormatted(cell)) {
			return true;
		}
		return false;
	}

	@SuppressWarnings("unchecked")
	private boolean isAlertCauseExists(HSSFCell cell) {
		// findAlertCauseByName
		String alertCause;
		if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
			alertCause = cell.getStringCellValue();
		} else {
			return false;
		}

		if (alertCause.length() > 64) {
			alertCause = alertCause.substring(0, 64);
		}

		if (alertCause == null || "".equals(alertCause)) {
			return false;
		}

		List<AlertCause> acList = null;
		try {
			acList = getEntityManager()
					.createNamedQuery("findAlertCauseByName")
					.setParameter("name", alertCause).getResultList();
		} catch (Exception e) {
			log.error(e.getMessage(), e);
		}
		return acList.size() >= 1;
	}

	@SuppressWarnings("unchecked")
	private boolean isCauseCodeExists(HSSFCell cell) {

		long causeCodeId;
		if (cell.getCellType() == HSSFCell.CELL_TYPE_STRING) {
			causeCodeId = Long.valueOf(cell.getStringCellValue());
		} else if (cell.getCellType() == HSSFCell.CELL_TYPE_NUMERIC) {
			causeCodeId = Math.round(cell.getNumericCellValue());
		} else {
			return false;
		}

		List<CauseCode> causeCode = getEntityManager()
				.createNamedQuery("getCauseCodeById")
				.setParameter("id", causeCodeId).getResultList();
		return causeCode.size() >= 1;
	}
}

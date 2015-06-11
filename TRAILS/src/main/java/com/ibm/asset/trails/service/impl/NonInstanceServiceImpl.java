package com.ibm.asset.trails.service.impl;

import java.io.ByteArrayOutputStream;
import java.io.FileInputStream;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.ws.rs.core.Response.Status;

import org.apache.commons.lang.StringUtils;
import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFRichTextString;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.hssf.util.HSSFColor;
import org.apache.poi.ss.usermodel.Cell;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.dao.NonInstanceDAO;

import com.ibm.asset.trails.dao.SoftwareDAO;
import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.Manufacturer;
import com.ibm.asset.trails.domain.NonInstance;
import com.ibm.asset.trails.domain.NonInstanceDisplay;
import com.ibm.asset.trails.domain.NonInstanceHDisplay;
import com.ibm.asset.trails.domain.Software;

import com.ibm.asset.trails.service.NonInstanceService;

@Service
public class NonInstanceServiceImpl extends AbstractGenericEntityService<NonInstance, Long> implements NonInstanceService{

	@Autowired
	private NonInstanceDAO dao;
	
	
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public NonInstanceDisplay findNonInstanceDisplayById(Long Id) {
		// TODO Auto-generated method stub
		return dao.findNonInstanceDisplayById(Id);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceDisplay> findNonInstanceDisplays(
			NonInstanceDisplay nonInstanceDisplay) {
		// TODO Auto-generated method stub
		return dao.findNonInstanceDisplays(nonInstanceDisplay);
	}

	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public List<NonInstanceHDisplay> findNonInstanceHDisplays(Long nonInstanceId) {
		// TODO Auto-generated method stub
		return dao.findNonInstanceHDisplays(nonInstanceId);
	}
	
	public void saveNonInstance(NonInstance nonInstance) {
		// TODO Auto-generated method stub
		
	}

	public List<Software> findSoftwareBySoftwareName(String softwareName) {
		// TODO Auto-generated method stub
		return null;
	}

	public List<Manufacturer> findManufacturerByName(String manufacturerName) {
		// TODO Auto-generated method stub
		return null;
	}

	public List<CapacityType> findCapacityTypeByDesc(String description) {
		// TODO Auto-generated method stub
		return null;
	}
	
	@Transactional(readOnly = true, propagation = Propagation.NOT_SUPPORTED)
	public ByteArrayOutputStream parserUpload(FileInputStream fileinput){
        HSSFWorkbook wb = new HSSFWorkbook(fileinput);
      		HSSFSheet sheet = wb.getSheetAt(0);
      		Iterator liRow = null;
      		HSSFRow row = null;
      		NonInstance ni = null;
      		boolean error = false;
      		StringBuffer lsbErrorMessage = null;
      		HSSFCellStyle lcsError = wb.createCellStyle();
      		HSSFCellStyle lcsNormal = wb.createCellStyle();
      		HSSFCellStyle lcsMessage = wb.createCellStyle();
      		HSSFCell cell = null;
      		boolean lbHeaderRow = false;

      		lcsError.setFillForegroundColor(HSSFColor.RED.index);
      		lcsError.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
      		lcsNormal.setFillForegroundColor(HSSFColor.WHITE.index);
      		lcsNormal.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);
      		lcsMessage.setFillForegroundColor(HSSFColor.YELLOW.index);
      		lcsMessage.setFillPattern(HSSFCellStyle.SOLID_FOREGROUND);

      		for (liRow = sheet.rowIterator(); liRow.hasNext();) {
      			row = (HSSFRow) liRow.next();
      			ni = new NonInstance();
      			error = false;
      			lsbErrorMessage = new StringBuffer();
      			lbHeaderRow = false;

      			for (int i = 0; i <= 5; i++) {
      				cell = row.getCell(i);
      				if (cell == null) {
      					cell = row.createCell(i);
      						cell.setCellStyle(lcsError);
      						lsbErrorMessage.append(error ? "\n" : "").append(
      								getErrorMessage(i));
      						error = true;
      				} else {
      					cell.setCellStyle(lcsNormal);

      					try {
      						if (row.getRowNum() == 0 && cell.getColumnIndex() == 0) {
      							lbHeaderRow = true;
      							break;
      						} else {
      							parseCell(cell, ni);
      						}
      					} catch (Exception e) {
      						cell.setCellStyle(lcsError);
      						// e.printStackTrace();
      						lsbErrorMessage.append(error ? "\n" : "").append(
      								e.getMessage());
      						error = true;
      					}
      				}
      			}

      			if (!lbHeaderRow) {
      				if (error) {
      					cell = row.createCell(16);
      					cell.setCellStyle(lcsError);
      					cell.setCellValue(new HSSFRichTextString(lsbErrorMessage
      							.toString()));
      				} else if (ni.getSoftware() != null && ni.getCapacityType() != null
      						) {
      					NonInstance lniExists =  dao.findNonInstancesBySoftwareId(ni.getSoftware().getSoftwareId());
      					if (lniExists != null) {
      						for (NonInstance existsNI : lniExists) {
      							if (existsNI instanceof NonInstance) {
      								if (ni.getCapacityType().toString().equals(existsNI.getCapacityType().toString())) {
      									ni.setId(existsNI.getId());
      								}
      							}
      						}
      					}
      					dao.merge(ni);
      					cell = row.createCell(16);
      					cell.setCellStyle(lcsMessage);
      					cell.setCellValue(new StringBuffer(
      							"YOUR TEMPLATE UPLOAD SUCCESSFULLY").toString());
      				}
      			}
      		}
      		ByteArrayOutputStream bos = new ByteArrayOutputStream();
    		wb.write(bos);

		return bos;
	}
    @SuppressWarnings("null")
	private void parseCell(HSSFCell cell, NonInstance ni) throws Exception {

		switch (cell.getColumnIndex()) {
		case 0: { // Software Name
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Software Name is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Software Name is required.");
			} else {
				ni.setSoftware(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		case 1: { // Manufacturer
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("Manufacturer is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("Manufacturer is required.");
			} else {
				ni.setManufacturer(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		case 2: { // RESTRICTION
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("RESTRICTION is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("RESTRICTION is required.");
			} else {
				ni.setRestriction(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		case 3: { // CAPACITY_TYPE
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("CAPACITY TYPE is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("CAPACITY TYPE is required.");
			} else {
				ni.setCapacityType(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		case 4: { // BASE ONLY
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("BASE ONLY is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("BASE ONLY is required.");
			} else {
				ni.setBaseOnly(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		case 5: { // STATUS
			if (cell.getCellType() != HSSFCell.CELL_TYPE_STRING) {
				throw new Exception("STATUS is not a string.");
			} else if (StringUtils.isEmpty(cell.getRichStringCellValue()
					.getString())) {
				throw new Exception("STATUS is required.");
			} else {
				ni.setStatus(cell.getRichStringCellValue().getString()
						.trim());
			}

			break;
		}
		}

	}

 
	private String getErrorMessage(int piCellIndex) {
		String lsErrorMessage = null;

		switch (piCellIndex) {
		case 0: { // Software Name
			lsErrorMessage = " Software Name is required.";

			break;
		}

		case 1: { // Manufacturer
			lsErrorMessage = "  Manufacturer is required.";
			
			break;
		}

		case 2: { // RESTRICTION
			lsErrorMessage = "RESTRICTION is required.";
			
			break;
		}

		case 3: { // CAPACITY_TYPE_CODE
			lsErrorMessage = " CAPACITY TYPE CODE is required.";
			
			break;
		}

		case 4: { // BASE_ONLY
			lsErrorMessage = " BASE ONLY is required.";
			
			break;
		}

		case 5: { // STATUS
			lsErrorMessage = "STATUS is required.";

			break;
		}
		}

		return lsErrorMessage;
	}
	
	protected BaseEntityDAO<NonInstance, Long> getDao() {
		// TODO Auto-generated method stub
		return dao;
	}
}

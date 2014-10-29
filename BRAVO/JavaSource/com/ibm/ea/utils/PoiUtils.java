package com.ibm.ea.utils;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.text.DecimalFormat;
import java.text.NumberFormat;
import java.util.ArrayList;
import java.util.List;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

public abstract class PoiUtils {
	
	private static NumberFormat decimalFormat = new DecimalFormat("#.##");

	public static List<String[]> getExcelData(String file, int uploadFields) throws Exception {
		List<String[]> list = new ArrayList<String[]>();
		
        HSSFSheet sheet = PoiUtils.getSheet(file);
        int endRow = sheet.getLastRowNum();

        for (int i = 1; i <= endRow; i++) {
        	HSSFRow row = sheet.getRow(i);
            list.add(PoiUtils.getStringFields(row, sheet, uploadFields));
        }
	        
		return list;
	}
	
    public static HSSFSheet getSheet(String fileName) throws IOException, FileNotFoundException {
    	
    	POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(fileName));
    	
    	return new HSSFWorkbook(fs).getSheetAt(0);
	}

    public static String[] getStringFields(HSSFRow row, HSSFSheet sheet, int size) {
        
        String[] fields = new String[size];

        for (int j = 0; j < size; j++) {
            HSSFCell cell = row.getCell((short) j);

            int cellType;

            if (cell == null) {
                cellType = HSSFCell.CELL_TYPE_BLANK;
            }
            else {
                cellType = cell.getCellType();
            }
            
            String value = null;

            if (cellType == HSSFCell.CELL_TYPE_BLANK) {
                value = "";
            }
            else if (cellType == HSSFCell.CELL_TYPE_BOOLEAN) {
                value = cell.getBooleanCellValue() + "";
            }
            else if (cellType == HSSFCell.CELL_TYPE_ERROR) {
                value = "";
            }
            else if (cellType == HSSFCell.CELL_TYPE_FORMULA) {
                value = "";
            }
            else if (cellType == HSSFCell.CELL_TYPE_NUMERIC) {
                value = decimalFormat.format(cell.getNumericCellValue());
            }
            else if (cellType == HSSFCell.CELL_TYPE_STRING) {
                value = cell.getStringCellValue();
            }

            fields[j] = value.trim();
        }

        return fields;
    }
}

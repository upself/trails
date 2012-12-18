/*
 * Created on Jun 4, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.misld.batch;

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.IOException;
import java.util.ListIterator;
import java.util.Vector;

import org.apache.poi.hssf.usermodel.HSSFRow;
import org.apache.poi.hssf.usermodel.HSSFSheet;
import org.apache.poi.hssf.usermodel.HSSFWorkbook;
import org.apache.poi.poifs.filesystem.POIFSFileSystem;

import com.ibm.tap.misld.framework.Constants;

/**
 * @author denglers
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class XlsReportGenerator {

    XlsReportGenerator() {
    }

    @SuppressWarnings("unchecked")
    protected HSSFWorkbook buildXlsReport(XlsReport xlsReport)
            throws FileNotFoundException, IOException {

        POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(
                Constants.SPREAD_IN + xlsReport.getXlsTemplate()));

        HSSFWorkbook wb = new HSSFWorkbook(fs);
        HSSFSheet sheet = wb.getSheetAt((short) 0);

        ListIterator<Vector<String>> i = xlsReport.getXlsReport().listIterator();

        while (i.hasNext()) {
            Vector<String> hardwareBaselineList = (Vector<String>) i.next();
            
            HSSFRow row = sheet.createRow((short) i.nextIndex());
            
            Vector<String> hardwareBaseline = (Vector<String>) hardwareBaselineList;
            
            ListIterator<String> j = hardwareBaseline.listIterator();

            while (j.hasNext()) {
                String cellValue = (String) j.next();
                row.createCell((short) (j.nextIndex() - 1)).setCellValue(
                        cellValue);
            }
        }

        return wb;
    }
}
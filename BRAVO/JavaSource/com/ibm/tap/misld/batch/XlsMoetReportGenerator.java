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
import java.util.Iterator;
import java.util.ListIterator;
import java.util.Map;
import java.util.Vector;

import org.apache.poi.hssf.usermodel.HSSFCell;
import org.apache.poi.hssf.usermodel.HSSFCellStyle;
import org.apache.poi.hssf.usermodel.HSSFFont;
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
public class XlsMoetReportGenerator {

    XlsMoetReportGenerator() {
    }

    @SuppressWarnings("unchecked")
    protected HSSFWorkbook buildXlsReport(MoetXlsReport xlsReport)
            throws FileNotFoundException, IOException {

        POIFSFileSystem fs = new POIFSFileSystem(new FileInputStream(
                Constants.SPREAD_IN + xlsReport.getXlsTemplate()));

        HSSFWorkbook wb = new HSSFWorkbook(fs);
        HSSFSheet sheet = wb.getSheetAt((short) 0);

        HSSFFont font = wb.createFont();
        font.setFontHeightInPoints((short) 22);
        font.setFontName("Tahoma");

        HSSFCellStyle style = wb.createCellStyle();
        style.setFont(font);

        Map xlsHash = xlsReport.getXlsReport();

        Iterator i = xlsHash.keySet().iterator();

        int count = 0;

        while (i.hasNext()) {
            String poNumber = (String) i.next();
            Moet moet = (Moet) xlsHash.get(poNumber);

            HSSFRow row = sheet.createRow((short) (count));
            HSSFCell cell = row.createCell((short) 0);
            cell.setCellValue("Microsoft Volume Licensing Order Sheet");
            cell.setCellStyle(style);

            row.createCell((short) (4)).setCellValue(
                    "PO Template last updated on 2003-08-19");

            row = sheet.createRow((short) (count + 1));
            row.createCell((short) (0)).setCellValue(moet.getLineOneA());
            row.createCell((short) (1)).setCellValue(moet.getPoNumber());
            row.createCell((short) (2)).setCellValue(moet.getLineOneB());
            row.createCell((short) (3)).setCellValue(moet.getPoType());

            row = sheet.createRow((short) (count + 2));
            row.createCell((short) (0)).setCellValue(moet.getLineTwoA());
            row.createCell((short) (1)).setCellValue(moet.getUsageDate());
            row.createCell((short) (2)).setCellValue(moet.getLineTwoB());
            row.createCell((short) (3)).setCellValue(moet.getAgreementNumber());

            row = sheet.createRow((short) (count + 3));
            row.createCell((short) (0)).setCellValue(moet.getLineThreeA());
            row.createCell((short) (2)).setCellValue(moet.getLineThreeB());

            row = sheet.createRow((short) (count + 4));
            row.createCell((short) (0)).setCellValue(moet.getLineFourA());
            row.createCell((short) (2)).setCellValue(moet.getLineFourB());

            row = sheet.createRow((short) (count + 5));
            row.createCell((short) (0)).setCellValue(moet.getLineFiveA());
            row.createCell((short) (2)).setCellValue(moet.getLineFiveB());

            row = sheet.createRow((short) (count + 6));
            row.createCell((short) (0)).setCellValue(moet.getLineSixA());
            row.createCell((short) (2)).setCellValue(moet.getLineSixB());

            row = sheet.createRow((short) (count + 7));
            row.createCell((short) (0)).setCellValue(moet.getLineSevenA());
            row.createCell((short) (2)).setCellValue(moet.getLineSevenB());

            row = sheet.createRow((short) (count + 8));
            row.createCell((short) (0)).setCellValue(moet.getLineEightA());
            row.createCell((short) (2)).setCellValue(moet.getLineEightB());

            row = sheet.createRow((short) (count + 9));
            row.createCell((short) (0)).setCellValue(moet.getLineNineA());
            row.createCell((short) (2)).setCellValue(moet.getLineNineB());

            row = sheet.createRow((short) (count + 10));
            row.createCell((short) (0)).setCellValue(moet.getLineTenA());
            row.createCell((short) (2)).setCellValue(moet.getLineTenB());

            row = sheet.createRow((short) (count + 11));
            row.createCell((short) (0)).setCellValue(moet.getLineElevenA());
            row.createCell((short) (2)).setCellValue(moet.getLineTwelveA());

            row = sheet.createRow((short) (count + 12));
            row.createCell((short) (0)).setCellValue(moet.getLineTwelveA());
            row.createCell((short) (1)).setCellValue(moet.getLineTwelveB());
            row.createCell((short) (2)).setCellValue(moet.getLineTwelveC());
            row.createCell((short) (3)).setCellValue(moet.getLineTwelveD());
            row.createCell((short) (4)).setCellValue(moet.getLineTwelveE());
            row.createCell((short) (5)).setCellValue(moet.getLineTwelveF());
            row.createCell((short) (6)).setCellValue(moet.getLineTwelveG());

            count = count + 13;
            ListIterator<Vector<String>> j = moet.getProductVector().listIterator();

            while (j.hasNext()) {

                Vector<String> hardwareBaselineList = (Vector<String>) j.next();

                row = sheet.createRow((short) count);

                Vector<String> hardwareBaseline = (Vector<String>) hardwareBaselineList;
                ListIterator<String> k = hardwareBaseline.listIterator();

                while (k.hasNext()) {
                    String cellValue = (String) k.next();
                    row.createCell((short) (k.nextIndex() - 1)).setCellValue(
                            cellValue);
                }

                count = count + 1;
            }
        }

        return wb;
    }
}
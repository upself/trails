package com.ibm.ea.bravo.report;

import java.io.File;
import java.io.IOException;
import java.io.OutputStream;
import java.util.Iterator;
import java.util.List;

import javax.servlet.http.HttpServletRequest;

import jxl.Workbook;
import jxl.read.biff.BiffException;
import jxl.write.Label;
import jxl.write.WritableSheet;
import jxl.write.WritableWorkbook;
import jxl.write.WriteException;
import jxl.write.biff.RowsExceededException;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.account.ExceptionAccountAccess;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.framework.report.DownloadReport;
import com.ibm.ea.bravo.framework.report.IReport;

public class AuthorizedAssetsLoaderTemplate extends DownloadReport implements
		IReport {
	private static final Logger logger = Logger
			.getLogger(AuthorizedAssetsLoaderTemplate.class);

	public AuthorizedAssetsLoaderTemplate() {
	}

	public AuthorizedAssetsLoaderTemplate(OutputStream outputStream) {
		this.outputStream = outputStream;
	}

	public void execute(String[] args, HttpServletRequest request)
			throws ExceptionAccountAccess {

		// get the report
		List<String> list = DelegateReport.getReport(this, request);
		logger.debug("list.size = " + list.size());

		Workbook workbook = null;
		try {
			workbook = Workbook.getWorkbook(new File(
					Constants.AUTHORIZED_ASSETS_BLANK_FILE));

			WritableWorkbook copy = Workbook.createWorkbook(outputStream,
					workbook);
			WritableSheet sheet = copy.getSheet(1);

			Iterator<String> i = list.iterator();

			int cellCount = 1;

			while (i.hasNext()) {
				String softwareName = (String) i.next();

				Label label = new Label(0, cellCount, softwareName);
				sheet.addCell(label);

				cellCount++;
			}

			copy.write();
			copy.close();

		} catch (BiffException e) {
			e.printStackTrace();
		} catch (IOException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (RowsExceededException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (WriteException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

	}

}

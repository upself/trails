package com.ibm.asset.trails.batch.swkbt.writer;

import java.io.IOException;
import java.io.Writer;
import java.text.SimpleDateFormat;
import java.util.Calendar;

import org.springframework.batch.item.file.FlatFileHeaderCallback;

public class SwkbtHeaderCallback implements FlatFileHeaderCallback {

	private String csvHeader;

	public void writeHeader(Writer writer) throws IOException {
		SimpleDateFormat lsdfNow = new SimpleDateFormat(
				"MM-dd-yyyy HH:mm:ss");
		writer.write("Report Time: "
				+ lsdfNow.format(Calendar.getInstance().getTime())
						.toString());
		writer.append("\r\n");
		writer.write("IBM Confidential");
		writer.append("\r\n");
		writer.write(csvHeader);
	}

	public void setCsvHeader(String csvHeader) {
		this.csvHeader = csvHeader;
	}

}

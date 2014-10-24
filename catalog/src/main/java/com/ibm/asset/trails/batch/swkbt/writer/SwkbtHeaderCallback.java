package com.ibm.asset.trails.batch.swkbt.writer;

import java.io.IOException;
import java.io.Writer;

import org.springframework.batch.item.file.FlatFileHeaderCallback;

public class SwkbtHeaderCallback implements FlatFileHeaderCallback {

	private String csvHeader;

	public void writeHeader(Writer writer) throws IOException {
		writer.write(csvHeader);
	}

	public void setCsvHeader(String csvHeader) {
		this.csvHeader = csvHeader;
	}

}

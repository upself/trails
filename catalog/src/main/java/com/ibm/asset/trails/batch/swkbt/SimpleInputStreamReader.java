package com.ibm.asset.trails.batch.swkbt;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.util.ArrayList;

public class SimpleInputStreamReader {

	private final InputStream inputStream;

	public SimpleInputStreamReader(InputStream inputStream) {
		if (inputStream == null)
			throw new IllegalArgumentException("inputStream is null");
		this.inputStream = inputStream;
	}

	public ArrayList<String> inputStreamAsArrayList() throws IOException {
		ArrayList<String> lines = new ArrayList<String>();
		BufferedReader bufferedReader = new BufferedReader(
				new InputStreamReader(inputStream));
		for (String line = bufferedReader.readLine(); line != null; line = bufferedReader
				.readLine()) {
			lines.add(line);
		}
		return lines;
	}

}

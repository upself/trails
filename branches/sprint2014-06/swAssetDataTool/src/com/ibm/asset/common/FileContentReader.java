package com.ibm.asset.common;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;

public class FileContentReader {

	public String read(String filePath) {
		BufferedReader reader = null;
		StringBuffer content = new StringBuffer();
		try {
			reader = new BufferedReader(new FileReader(new File(filePath)));
			String line = null;
			while ((line = reader.readLine()) != null) {
				content.append(line);
				content.append("\n");
			}
		} catch (FileNotFoundException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} finally {
			if (reader != null) {
				try {
					reader.close();
				} catch (IOException e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}
			}
		}

		return content.toString();
	}
}

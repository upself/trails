/*
 * Created on Feb 1, 2006
 *
 */
package com.ibm.ea.bravo.parser;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.parser.ParserInstalledSoftware;
import com.ibm.ea.bravo.software.parser.SwScan;



/**
 * @author Thomas
 * 
 */
public class VMImporter implements InterfaceParser {

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.ea.bv.parser.InterfaceParser#parse()
     */
    public boolean parse(SwScan mySwScan) throws IOException {
    	if ( mySwScan.isParsed() ) {
    		return true;
    	}

		BufferedReader in = new BufferedReader(new FileReader(Constants.UPLOAD_DIR + mySwScan.getFileName()));
		String str = null;
		String lparName = null;
		String cpuModelNumber = null;
		String cpuSerialNumber = null;
		while ((str = in.readLine()) != null) {
			if ((str.length() < 44)) {
				// check if this is the line that has the lpar name
				if (str.length() > 14) {
					// looks like we have the LPAR name
					lparName = str.substring(14);
				}
				continue;
			} else {
				ParserInstalledSoftware s = new ParserInstalledSoftware();
				s.setSoftwareId(str.substring(9, 17));
				s.setProductName(str.substring(43));
				s.setCpuSysName(lparName);
				s.setCpuSerialNumber(cpuSerialNumber);
				s.setCpuModelNumber(cpuModelNumber);
				mySwScan.getInstalledSoftware().addElement(s);
			}
		}

		in.close();
		mySwScan.setParsed(true);

		return true;

	}

    public void display(SwScan lpar) {
    	int numberProducts = lpar.getInstalledSoftware().size();
    	int counter = 0;
    	while ( counter < numberProducts ) {
    		++counter;
    	}
    }

}
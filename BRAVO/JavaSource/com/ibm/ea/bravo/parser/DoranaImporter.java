/*
 * Created on Feb 1, 2006
 *
 */
package com.ibm.ea.bravo.parser;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import org.apache.log4j.Logger;

import au.com.bytecode.opencsv.CSVReader;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.parser.ParserInstalledSoftware;
import com.ibm.ea.bravo.software.parser.SwScan;



/**
 * @author Thomas
 * 
 */
public class DoranaImporter implements InterfaceParser {

    /*
     * (non-Javadoc)
     * 
     * @see com.ibm.ea.bv.parser.InterfaceParser#parse()
     */
	private static final Logger logger = Logger
	.getLogger(DoranaImporter.class);

    public boolean parse(SwScan mySwScan ) throws IOException {
    	String errorMessage;
    	if ( mySwScan.isParsed() ) {
    		return true;
    	}
    	
    	CSVReader csvr;
    	logger.debug("Parsing " + mySwScan.getFileName());
   	 
        BufferedReader in = new BufferedReader(new FileReader( Constants.UPLOAD_DIR + mySwScan.getFileName()));
        csvr = new CSVReader(in);
        String[] str = null;
        int line_count = 0;
        int good_lines = 0;
        while (( (str = csvr.readNext()) != null) && (str.length > 9)) {
        	if ( (str.length < 11) ||
					((str[6] == null)) || (str[6].length() < 1 )  ) {
        		errorMessage = "Invalid file format in Dorana Parsing file: " + mySwScan.getFileName() + " at "
				+ line_count;
        		mySwScan.getNotifyMessage().add(errorMessage);
        		logger.warn(errorMessage);
        		++line_count;
        		continue;
        	}
            ParserInstalledSoftware s = new ParserInstalledSoftware();
            s.setSoftwareId(str[2]);
            s.setProductName(str[2]); // grab the all uppercase 9-58 is upper/lower
            s.setVendorId(str[3]);
            s.setVendorName(str[5]);
            s.setCpuSysName(str[6]);
            s.setCpuSerialNumber(str[7]);
            s.setCpuModelNumber(str[8]);
            s.setVersionGroupId(str[9]);
            s.setProductVersion(str[10]);
//            s.setProductRelease(str[11]);
            mySwScan.getInstalledSoftware().addElement(s);
            if ( line_count == 1 ) {
            	mySwScan.setCpuName("00" + s.getCpuSerialNumber());
            	mySwScan.setLparName(s.getCpuSysName());
            	logger.debug("Found " + mySwScan.getCpuName() + " " + mySwScan.getLparName() + " in file.");
            }
			++line_count;
			++good_lines;
        }
        in.close();
        mySwScan.getNotifyMessage().add("Finished parsing file " + mySwScan.getFileName() 
        		+ " with " + mySwScan.getInstalledSoftware().size() + " rows");
        logger.debug(mySwScan.getNotifyMessage().lastElement());
        mySwScan.setParsed(true);
        if ( (good_lines != 0 ) && (line_count == good_lines ) ) {
        	mySwScan.setGoodFile(new Boolean(true));
        } else {
        	errorMessage = "Invalid file -- file will not be processed: " + mySwScan.getFileName();
        	mySwScan.getNotifyMessage().add(errorMessage);
        	logger.warn(errorMessage);
        	mySwScan.setGoodFile(new Boolean(false));
        	mySwScan.setCpuName("BAD");
        	mySwScan.setLparName("BAD");
        }
        return true;

    }

    /* (non-Javadoc)
     * @see com.ibm.ea.bv.parser.InterfaceParser#display()
     */
    public void display(SwScan lpar) {
    	int numberProducts = lpar.getInstalledSoftware().size();
    	int counter = 0;
    	while ( counter < numberProducts ) {
    		++counter;
    	}
    }


}
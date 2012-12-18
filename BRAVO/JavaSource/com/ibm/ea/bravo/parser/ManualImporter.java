/*
 * Created on Feb 1, 2006
 *
 */
package com.ibm.ea.bravo.parser;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.bravo.software.parser.ParserInstalledSoftware;
import com.ibm.ea.bravo.software.parser.SwScan;



/**
 * @author dbryson@us.ibm.ocm
 * 
 */
public class ManualImporter implements InterfaceParser {
	
	private static final Logger logger = Logger.getLogger(ManualImporter.class);

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
		int line_count = 0;
		int data_count = 0;
		// throw away the first line
		str = in.readLine();
		while ((str = in.readLine()) != null) {
			ParserInstalledSoftware s = new ParserInstalledSoftware();
			String [] fields = str.split("\t");
			if ( fields.length > 5 ) {
				if ( fields[0] != null ) {
					s.setAccountId(new Long(fields[0]));
				} else {
					logger.warn("Null Account Number line " + line_count + " " + mySwScan.getFileName());
					++line_count;
					continue;
				}
				if ( fields[1] != null ) {
					s.setCpuSysName(fields[1]);
				} else {
					logger.warn("Null Account Number line " + line_count + " " + mySwScan.getFileName());
					++line_count;
					continue;					
				}
				if ( fields[2] != null ) {
					s.setProcessorCount(new Integer(fields[2]));
				}
				if ( fields[3] != null ) {
					s.setProductName(fields[3]);
				} else {
					logger.warn("Null product name line " + line_count + " " + mySwScan.getFileName());
					++line_count;					
				}
				if ( fields[4] != null ) {
					s.setProductVersion(fields[4]);
				}
				if ( fields[5] != null ) {
					s.setUsers(new Integer(fields[5]));
				}
				mySwScan.getInstalledSoftware().addElement(s);
				++data_count;
			} else {
				logger.warn("File: " + mySwScan.getFileName() + " does not have enough fields at line " + line_count );
			}
			++line_count;
		}

		in.close();
		logger.debug("File: " + mySwScan.getFileName() + " Parsed " + line_count + " lines with good data in: " + data_count);
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
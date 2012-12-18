package com.ibm.ea.bravo.upload;

import org.apache.log4j.Logger;

import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class Tivoli extends UploadBase {

	private static final Logger logger = Logger.getLogger(Tivoli.class);

	private String batchName = "Software Discrepancy Load Batch";
	private String dir = Constants.UPLOAD_DIR_TAR;
	
	public Tivoli () { }
	
	public Tivoli (String filename) {
		this.filename = filename;
	}
	
	public void execute() throws Exception {
		logger.debug("Tivoli.execute - begin");

		logger.debug("Tivoli.execute - end");
	}

	public boolean validate() throws Exception {
		
		if (EaUtils.isBlank(dir))
			return false;
		
		if (EaUtils.isBlank(filename))
			return false;
		
		return true;
	}

	public String getDir() {
		return dir;
	}
	
	public void sendNotify() {
		logger.debug("Tivoli.sendNotify - begin");
		logger.debug("Tivoli.sendNotify - end");
	}

	public void sendNotifyException(Exception e) {
	}

	public String getName() {
		return batchName;
	}
}

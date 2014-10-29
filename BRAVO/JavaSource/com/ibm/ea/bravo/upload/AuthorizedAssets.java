package com.ibm.ea.bravo.upload;

import com.ibm.ea.bravo.framework.batch.IBatch;
import com.ibm.ea.bravo.framework.common.Constants;
import com.ibm.ea.utils.EaUtils;

public class AuthorizedAssets extends UploadBase implements IBatch {
	private String batchName = "Authorized Assets Load Batch";

	private String dir = Constants.UPLOAD_DIR;

	public AuthorizedAssets() {
	}

	public AuthorizedAssets(String filename) {
		this.filename = filename;
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
	public String getName() {
		return batchName;
	}
}

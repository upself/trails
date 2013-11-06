package com.ibm.asset.trails.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;

public interface CauseCodeService {
	ByteArrayOutputStream loadSpreadsheet(File file, String remoteUser)
			throws IOException;

}

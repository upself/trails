package com.ibm.asset.trails.service;

import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.util.List;

import com.ibm.ea.common.State;

public interface CauseCodeService {
	ByteArrayOutputStream loadSpreadsheet(File file, String remoteUser,
			List<State> steps) throws IOException;

}

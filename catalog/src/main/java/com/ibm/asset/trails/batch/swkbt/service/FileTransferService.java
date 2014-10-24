package com.ibm.asset.trails.batch.swkbt.service;

import java.io.IOException;

public interface FileTransferService {
	void sendFile(String localFileName) throws IOException;
}

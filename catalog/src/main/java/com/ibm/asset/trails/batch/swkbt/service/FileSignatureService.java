package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.FileSignatureType;
import com.ibm.asset.trails.domain.FileSignature;

public interface FileSignatureService extends
		SignatureService<FileSignature, FileSignatureType, Long> {

}

package com.ibm.asset.trails.batch.swkbt.service;

import com.ibm.asset.swkbt.schema.ApplicationServerSignatureType;
import com.ibm.asset.trails.domain.ApplicationServerSignature;

public interface ApplicationServerSignatureService
		extends
		SignatureService<ApplicationServerSignature, ApplicationServerSignatureType, Long> {
}

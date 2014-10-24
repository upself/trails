package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;

import com.ibm.asset.swkbt.schema.SignatureType;
import com.ibm.asset.trails.domain.Signature;

public interface SignatureService<E extends Signature, X extends SignatureType, I extends Serializable>
		extends KbDefinitionService<E, X, I> {

}

package com.ibm.asset.trails.dao;

import java.io.Serializable;

import com.ibm.asset.trails.domain.Signature;

public interface SignatureDao<E extends Signature, I extends Serializable>
		extends KbDefinitionDao<E, I> {

}

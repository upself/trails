package com.ibm.asset.trails.dao.jpa;

import java.io.Serializable;

import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.Signature;

public abstract class SignatureDaoJpa<E extends Signature, I extends Serializable>
		extends KbDefinitionDaoJpa<E, I> implements SignatureDao<E, I> {

}

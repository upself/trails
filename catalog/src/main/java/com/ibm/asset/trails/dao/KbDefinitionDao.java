package com.ibm.asset.trails.dao;

import java.io.Serializable;
import java.util.Date;

import com.ibm.asset.trails.domain.KbDefinition;

public interface KbDefinitionDao<E extends KbDefinition, I extends Serializable>
		extends BaseDao<E, I> {

	Date findMaxModificationDate();
}

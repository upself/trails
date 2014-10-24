package com.ibm.asset.trails.dao;

import java.io.Serializable;

import com.ibm.asset.trails.domain.SoftwareItem;

public interface SoftwareItemDao<E extends SoftwareItem, I extends Serializable>
		extends KbDefinitionDao<E, I> {

}

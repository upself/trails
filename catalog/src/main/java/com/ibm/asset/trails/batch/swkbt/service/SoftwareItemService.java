package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;

import com.ibm.asset.swkbt.schema.SoftwareItemType;
import com.ibm.asset.trails.domain.SoftwareItem;

public interface SoftwareItemService<E extends SoftwareItem, X extends SoftwareItemType, I extends Serializable>
		extends KbDefinitionService<E, X, I> {

}

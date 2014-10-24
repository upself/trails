package com.ibm.asset.trails.dao.jpa;

import java.io.Serializable;

import com.ibm.asset.trails.dao.SoftwareItemDao;
import com.ibm.asset.trails.domain.SoftwareItem;

public abstract class SoftwareItemDaoJpa<E extends SoftwareItem, I extends Serializable>
		extends KbDefinitionDaoJpa<E, I> implements SoftwareItemDao<E, I> {

}

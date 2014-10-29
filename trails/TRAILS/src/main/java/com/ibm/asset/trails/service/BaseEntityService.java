package com.ibm.asset.trails.service;

import java.io.Serializable;
import java.util.List;

import com.ibm.asset.trails.domain.AbstractDomainEntity;

public interface BaseEntityService<E extends AbstractDomainEntity, I extends Serializable>
		extends BaseService {

	E findById(I entityId);

	List<E> findAll();
	
	E update(E entity);
}

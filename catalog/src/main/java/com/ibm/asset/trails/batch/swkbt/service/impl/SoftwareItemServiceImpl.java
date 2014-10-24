package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.Serializable;
import java.io.UnsupportedEncodingException;
import java.util.HashSet;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;

import com.ibm.asset.swkbt.schema.SoftwareItemType;
import com.ibm.asset.trails.batch.swkbt.service.PidService;
import com.ibm.asset.trails.batch.swkbt.service.SoftwareItemService;
import com.ibm.asset.trails.domain.Pid;
import com.ibm.asset.trails.domain.SoftwareItem;
import com.ibm.asset.trails.domain.MainframeVersion;

public abstract class SoftwareItemServiceImpl<E extends SoftwareItem, X extends SoftwareItemType, I extends Serializable>
		extends KbDefinitionServiceImpl<E, X, I> implements
		SoftwareItemService<E, X, I> {

	@Autowired
	private PidService pidService;

	@Override
	public E update(E existing, X xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setActivationDate(convertXMLGregorianCalendar(xmlEntity
				.getActivationDate()));
		existing.setEndOfSupportDate(convertXMLGregorianCalendar(xmlEntity
				.getEndOfSupport()));
		existing.setName(xmlEntity.getName());

		existing.setProductRole(xmlEntity.getProductRole());
		existing.setWebsite(xmlEntity.getWebsite());
		Set<Pid> pids = new HashSet<Pid>();
		if (xmlEntity.isDeleted() == null || !xmlEntity.isDeleted()) {
			if( existing instanceof MainframeVersion) {
				pids = pidService.findFromXmlSet(xmlEntity.getProductId());
			}
			else {
				pids = pidService.findFromXmlSet(xmlEntity.getProductIds());
				existing.setProductId(xmlEntity.getProductId());
			}
		}
		existing.getPids().retainAll(pids);
		existing.getPids().addAll(pids);
		return existing;
	}

}

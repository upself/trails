package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.io.Serializable;
import java.util.Date;

import javax.xml.datatype.XMLGregorianCalendar;

import com.ibm.asset.swkbt.schema.KbDefinitionType;
import com.ibm.asset.trails.batch.swkbt.service.KbDefinitionService;
import com.ibm.asset.trails.dao.KbDefinitionDao;
import com.ibm.asset.trails.domain.KbDefinition;

public abstract class KbDefinitionServiceImpl<E extends KbDefinition, X extends KbDefinitionType, I extends Serializable>
		extends GenericService<E, X, I> implements KbDefinitionService<E, X, I> {

	@Override
	protected abstract KbDefinitionDao<E, I> getDao();

	@Override
	public E update(E existing, X xmlEntity) {
		existing.setActive(xmlEntity.isActive());

		Date date = null;
		if (xmlEntity.getCreated() == null) {
			date = new Date();
		} else {
			date = convertXMLGregorianCalendar(xmlEntity.getCreated());
		}
		existing.setCreatedDate(date);
		existing.setCustomField1(xmlEntity.getCustomField1());
		existing.setVendorManaged(xmlEntity.getCustomField2());
		existing.setCustomField3(xmlEntity.getCustomField3());
		existing.setDataInput(xmlEntity.getDataInput());
		existing.setDefinitionSource(xmlEntity.getDefinitionSource());
		//System.out.print("**********" + xmlEntity.getDefinitionSource() +"***********");
		existing.setDeleted(xmlEntity.isDeleted());
		existing.setDescription(xmlEntity.getDescription());
		existing.setExternalId(xmlEntity.getExternalId());
		existing.setGuid(xmlEntity.getGuid());
		existing.setModifiedDate(convertXMLGregorianCalendar(xmlEntity
				.getModified()));
		return existing;
	}

	public Date convertXMLGregorianCalendar(XMLGregorianCalendar xcal) {
		if (xcal == null) {
			return null;
		}
		return xcal.toGregorianCalendar().getTime();
	}
}

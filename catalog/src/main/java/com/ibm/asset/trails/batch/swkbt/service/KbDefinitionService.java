package com.ibm.asset.trails.batch.swkbt.service;

import java.io.Serializable;
import java.util.Date;

import javax.xml.datatype.XMLGregorianCalendar;

import com.ibm.asset.swkbt.schema.KbDefinitionType;
import com.ibm.asset.trails.domain.KbDefinition;

public interface KbDefinitionService<E extends KbDefinition, X extends KbDefinitionType, I extends Serializable>
		extends BaseService<E, X, I> {

	Date convertXMLGregorianCalendar(XMLGregorianCalendar activationDate);
}

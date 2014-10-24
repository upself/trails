package com.ibm.asset.trails.batch.swkbt.writer;

import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLStreamException;

import org.springframework.batch.item.xml.StaxEventItemWriter;
import org.springframework.beans.factory.InitializingBean;

public class WstxStaxEventItemWriter<T> extends StaxEventItemWriter<T>
		implements InitializingBean {

	@Override
	protected void endDocument(XMLEventWriter writer) throws XMLStreamException {
	}
}
package com.ibm.asset.trails.batch.swkbt.writer;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.xml.stream.XMLEventWriter;
import javax.xml.stream.XMLStreamException;

import org.springframework.batch.item.xml.StaxEventItemWriter;
import org.springframework.oxm.XmlMappingException;

import com.ibm.asset.trails.domain.DomainEntity;

public class SwkbtWriterImpl<E extends DomainEntity> extends
		StaxEventItemWriter<E> {

	private String entityClass;

	public void setEntityClass(String entityClass) {
		this.entityClass = entityClass;
	}

	@Override
	public void write(List<? extends E> items) throws XmlMappingException,
			IOException, Exception {
		List<E> newList = new ArrayList<E>();
		for (E item : items) {
			try {
				if (Class.forName(entityClass).isInstance(item)) {
					newList.add(item);
				}
			} catch (ClassNotFoundException e) {
				e.printStackTrace();
			}
		}
		super.write(newList);
	}

	@Override
	protected void endDocument(XMLEventWriter writer) throws XMLStreamException {
	}
}
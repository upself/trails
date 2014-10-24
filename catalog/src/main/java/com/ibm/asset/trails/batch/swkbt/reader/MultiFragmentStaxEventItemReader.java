package com.ibm.asset.trails.batch.swkbt.reader;

import java.util.List;

import javax.xml.namespace.QName;
import javax.xml.stream.XMLEventReader;
import javax.xml.stream.XMLStreamException;
import javax.xml.stream.events.StartElement;

import org.apache.commons.lang.Validate;
import org.apache.log4j.Logger;
import org.springframework.batch.item.xml.StaxEventItemReader;
import org.springframework.beans.factory.InitializingBean;
import org.springframework.dao.DataAccessResourceFailureException;

import com.ibm.asset.trails.batch.swkbt.service.impl.SwkbtLoaderServiceImpl;

public class MultiFragmentStaxEventItemReader<T> extends StaxEventItemReader<T>
		implements InitializingBean {

	private List<String> fragmentRootElementNames;
	private static final Logger logger = Logger
			.getLogger(MultiFragmentStaxEventItemReader.class);

	public void setFragmentRootElementNames(
			List<String> fragmentRootElementNames) {
		this.fragmentRootElementNames = fragmentRootElementNames;
	}

	@Override
	protected boolean moveCursorToNextFragment(XMLEventReader reader) {
		try {
			while (true) {
				while (reader.peek() != null && !reader.peek().isStartElement()) {
					reader.nextEvent();
				}
				if (reader.peek() == null) {
					return false;
				}
				QName startElementName = ((StartElement) reader.peek())
						.getName();
				String elementName = startElementName.getLocalPart();
				logger.debug("In Stax -- element name -- " + elementName);
				if (fragmentRootElementNames.contains(elementName)) {
					return true;
				} else {
					reader.nextEvent();
				}
			}
		} catch (XMLStreamException e) {
			throw new DataAccessResourceFailureException(
					"Error while reading from event reader", e);
		}
	}

	@Override
	public void afterPropertiesSet() throws Exception {
		super.setFragmentRootElementName(fragmentRootElementNames.get(0));
		super.afterPropertiesSet();
		Validate.notNull(fragmentRootElementNames,
				"Property fragmentRootElementNames must not be null");
		Validate.notEmpty(fragmentRootElementNames,
				"Property fragmentRootElementNames must not be empty");
	}
}
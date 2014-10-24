package com.ibm.asset.trails.batch.swkbt.service;

import java.io.FileNotFoundException;
import java.io.IOException;

import javax.xml.bind.JAXBException;
import javax.xml.stream.XMLStreamException;

import com.ibm.asset.trails.batch.swkbt.SwkbtException;

public interface SwkbtService {

	public static final String PROPERTIES_DIR = "/opt/catalog/swkbt/downloads";
	public static final String REQUEST_PROPS = "request.properties";
	public static final String STATUS_PROPS = "status.properties";
	public static final int REQUEST_TRIES = 5;

	void processCanonical(boolean delta, boolean reload)
			throws FileNotFoundException, SwkbtException, InterruptedException,
			XMLStreamException, JAXBException, IOException;
}

package com.ibm.tap.trails.framework;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

public class LicenseCatalogColumnDecorator implements DisplaytagColumnDecorator {

	private static final String MATCH = "//w3.ibm.com/ui/v8/images/icon-system-status-ok.gif";

	private static final String NO_MATCH = "//w3.ibm.com/ui/v8/images/icon-system-status-na.gif";

	public Object decorate(Object columnValue, PageContext pageContext,
			MediaTypeEnum media) throws DecoratorException {

		if (((String) columnValue).equalsIgnoreCase("yes")) {
			return "<img src=" + MATCH + "  alt=\"catalog match\" />";
		} else {
			return "<img src=" + NO_MATCH + " alt=\"no catalog match\" />";
		}
	}

}
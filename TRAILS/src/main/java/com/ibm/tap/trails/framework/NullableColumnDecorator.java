package com.ibm.tap.trails.framework;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

public class NullableColumnDecorator implements DisplaytagColumnDecorator {

	public Object decorate(Object columnValue, PageContext pageContext,
			MediaTypeEnum media) throws DecoratorException {

		if (columnValue == null
				|| (columnValue instanceof String && "".equals((String) columnValue))) {
			return "<div style=\"display:none;\">This cell is empty</div>";
		}
		return columnValue;
	}
}

package com.ibm.tap.trails.framework;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

import com.ibm.asset.trails.domain.AlertTypeCauseId;

public class AlertTypeCauseColumnDecorator implements DisplaytagColumnDecorator {

	public Object decorate(Object columnValue, PageContext pageContext,
			MediaTypeEnum media) throws DecoratorException {

		AlertTypeCauseId id = (AlertTypeCauseId) columnValue;
		String url = "<a href=/TRAILS/admin/alertCause/update.htm?alertCauseId="
				+ id.getAlertCause().getId()
				+ "&alertTypeId="
				+ id.getAlertType().getId()
				+ ">"
				+ id.getAlertCause().getName()
				+ "</a>";

		return url;
	}
}
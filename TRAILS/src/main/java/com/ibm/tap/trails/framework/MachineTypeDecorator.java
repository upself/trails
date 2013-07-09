package com.ibm.tap.trails.framework;

import javax.servlet.jsp.PageContext;

import org.displaytag.decorator.DisplaytagColumnDecorator;
import org.displaytag.exception.DecoratorException;
import org.displaytag.properties.MediaTypeEnum;

public class MachineTypeDecorator implements DisplaytagColumnDecorator {

	private static final String PVU_ID = "pvuId";

	public Object decorate(Object columnValue, PageContext pageContext,
			MediaTypeEnum media) throws DecoratorException {

		if (columnValue != null) {
			String machType = ((String) columnValue).trim();
			StringBuffer url = new StringBuffer();
			url
					.append("<a href=/TRAILS/admin/pvuMapping/updatePvuMap.htm?pvuId=");
			url.append(pageContext.getRequest().getAttribute(PVU_ID));
			url.append("&machineType=");
			url.append(machType);
			url.append(">");
			url.append(machType);
			url.append("</a>");
			return url;

		}

		return null;
	}
}

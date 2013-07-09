package com.ibm.tap.trails.framework;

import org.displaytag.decorator.TableDecorator;

public class LicenseDisplayTagDecorator extends TableDecorator {

	public String addRowClass() {
		return ((String) evaluate("catalogMatch")).equalsIgnoreCase("Yes") ? "yes"
				: "no";
	}

}

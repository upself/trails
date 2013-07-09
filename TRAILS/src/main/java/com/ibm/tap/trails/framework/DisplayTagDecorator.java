package com.ibm.tap.trails.framework;

import org.displaytag.decorator.TableDecorator;

public class DisplayTagDecorator extends TableDecorator {

	public String addRowClass() {
		return ((String) evaluate("scope")).equalsIgnoreCase("yes") ? "yes"
				: "no";
	}

	/* CPA - 3/31/09 - Commenting out for performance reasons
	public String getAlertStatus() {
		AccountSearch as = (AccountSearch) this.getCurrentRowObject();

		if (as.getAlertStatus().equals("Blue")) {
			return "<font class=\"blue-med\">" + as.getAlertStatus()
					+ "</font>";
		} else if (as.getAlertStatus().equals("Red")) {
			return "<font class=\"alert-stop\">" + as.getAlertStatus()
					+ "</font>";
		} else if (as.getAlertStatus().equals("Yellow")) {
			return "<font class=\"orange-med\">" + as.getAlertStatus()
					+ "</font>";
		} else {
			return "<font class=\"alert-go\">" + as.getAlertStatus()
					+ "</font>";
		}
	}
	*/
}

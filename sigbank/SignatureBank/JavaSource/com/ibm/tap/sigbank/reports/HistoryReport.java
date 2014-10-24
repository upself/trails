/*
 * Created on Mar 22, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.reports;

/**
 * @author Thomas
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class HistoryReport {

	public Object unit;

	public Object subUnit;

	public HistoryReport(Object unit) {
		this.unit = unit;
	}

	public HistoryReport(Object unit, Object subUnit) {
		this.unit = unit;
		this.subUnit = subUnit;
	}

	public Object getUnit() {
		return unit;
	}

	public void setUnit(Object unit) {
		this.unit = unit;
	}
}

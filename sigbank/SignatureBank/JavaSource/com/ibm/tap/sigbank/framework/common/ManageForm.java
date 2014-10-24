/*
 * Created on Apr 29, 2004
 *
 * To change the template for this generated file go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
package com.ibm.tap.sigbank.framework.common;

import javax.servlet.http.HttpServletRequest;

import org.apache.struts.action.ActionMapping;
import org.apache.struts.validator.ValidatorActionForm;

/**
 * 
 * @author newtont
 * 
 * To change the template for this generated type comment go to
 * Window&gt;Preferences&gt;Java&gt;Code Generation&gt;Code and Comments
 */
public class ManageForm extends ValidatorActionForm {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	private String action;

	private String search;

	private String order[] = new String[0];

	private String addItem[] = new String[0];

	private String remItem[] = new String[0];

	private String move;

	private String jump;

	private String mapName;

	private String searchType;

	/**
	 * @return Returns the searchType.
	 */
	public String getSearchType() {
		return searchType;
	}

	/**
	 * @param searchType
	 *            The searchType to set.
	 */
	public void setSearchType(String searchType) {
		this.searchType = searchType;
	}

	public String getAction() {
		return action;
	}

	public void setAction(String string) {
		action = string;
	}

	public void reset(ActionMapping mapping, HttpServletRequest request) {

	}

	// public ActionErrors validate(ActionMapping mapping,
	// HttpServletRequest request) {
	//
	// ActionErrors errors = new ActionErrors();
	//
	// return errors;
	// }

	public String[] getOrder() {
		return order;
	}

	public String getSearch() {
		return search;
	}

	public void setOrder(String[] strings) {
		order = strings;
	}

	public void setSearch(String search) {
		this.search = search;
	}

	public int getMoveAsInt() {
		return Integer.parseInt(move);
	}

	public int getJumpAsInt() {
		return Integer.parseInt(jump);
	}

	public String getJump() {
		return jump;
	}

	public String getMove() {
		return move;
	}

	public void setJump(String string) {
		jump = string;
	}

	public void setMove(String string) {
		move = string;
	}

	public String getMapName() {
		return mapName;
	}

	public void setMapName(String string) {
		mapName = string;
	}

	public String[] getAddItem() {
		return addItem;
	}

	public String[] getRemItem() {
		return remItem;
	}

	public void setAddItem(String[] strings) {
		addItem = strings;
	}

	public void setRemItem(String[] strings) {
		remItem = strings;
	}

}
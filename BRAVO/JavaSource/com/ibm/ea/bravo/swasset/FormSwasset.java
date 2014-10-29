package com.ibm.ea.bravo.swasset;

import java.util.List;

import com.ibm.ea.bravo.FormSearch;

public class FormSwasset extends FormSearch {
	/**
	 * 
	 */
	private static final long serialVersionUID = -1694736059256008119L;
	
	private String accountId;
	private List<Swasset> swasset;
	private String[] selected;

	public String getAccountId() {
		return accountId;
	}

	public void setAccountId(String accountId) {
		this.accountId = accountId;
	}

	public List<Swasset> getSwasset() {
		return swasset;
	}

	public void setSwasset(List<Swasset> swasset) {
		this.swasset = swasset;
	}

	public String[] getSelected() {
		return selected;
	}

	public void setSelected(String[] selected) {
		this.selected = selected;
	}
}

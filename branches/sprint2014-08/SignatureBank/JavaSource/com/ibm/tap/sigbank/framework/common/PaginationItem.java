/*
 * Created on Apr 12, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.common;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class PaginationItem {

	private boolean active;

	private int pageNumber;

	private boolean lastPage;

	private boolean next;

	/**
	 * @return Returns the active.
	 */
	public boolean isActive() {
		return active;
	}

	/**
	 * @param active
	 *            The active to set.
	 */
	public void setActive(boolean active) {
		this.active = active;
	}

	/**
	 * @return Returns the pageNumber.
	 */
	public int getPageNumber() {
		return pageNumber;
	}

	/**
	 * @param pageNumber
	 *            The pageNumber to set.
	 */
	public void setPageNumber(int pageNumber) {
		this.pageNumber = pageNumber;
	}

	/**
	 * @return Returns the lastPage.
	 */
	public boolean isLastPage() {
		return lastPage;
	}

	/**
	 * @param lastPage
	 *            The lastPage to set.
	 */
	public void setLastPage(boolean lastPage) {
		this.lastPage = lastPage;
	}

	/**
	 * @return Returns the next.
	 */
	public boolean isNext() {
		return next;
	}

	/**
	 * @param next
	 *            The next to set.
	 */
	public void setNext(boolean next) {
		this.next = next;
	}
}
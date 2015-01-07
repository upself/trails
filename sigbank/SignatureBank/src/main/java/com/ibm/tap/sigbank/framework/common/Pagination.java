/*
 * Created on Apr 12, 2005
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 */
package com.ibm.tap.sigbank.framework.common;

import java.util.Vector;

import javax.servlet.http.HttpServletRequest;

/**
 * @author alexmois
 * 
 * TODO To change the template for this generated type comment go to Window -
 * Preferences - Java - Code Style - Code Templates
 */
public class Pagination {

	private int resultNumber;

	private int currentPageNumber;

	private int previousPageNumber;

	private int resultsPerPage;

	private boolean previous = false;

	private Vector<PaginationItem> paginationItems = new Vector<PaginationItem>(
			10, 10);

	public Pagination(HttpServletRequest request, Integer resultNumber,
			int resultsPerPage) {
		// TODO need to create a table header object for the sort stuff
		String pageNumber = request.getParameter("pageNumber");

		if (Util.isBlankString(pageNumber)) {
			this.currentPageNumber = 1;
		} else {
			this.currentPageNumber = Integer.parseInt(pageNumber);
		}

		this.resultNumber = resultNumber.intValue();
		this.resultsPerPage = resultsPerPage;

		if (currentPageNumber - 5 > 1 && this.getTotalPages() > 10) {
			this.previous = true;
		}

		this.previousPageNumber = this.currentPageNumber - 1;
		int start = this.currentPageNumber;
		int counter = 10;

		if (this.getTotalPages() < 10) {
			counter = this.getTotalPages();
		}

		boolean lastPage = false;

		if (resultNumber.intValue() >= resultsPerPage) {
			for (int i = 0; i < counter; i++) {

				PaginationItem paginationItem = new PaginationItem();

				if (lastPage) {
					paginationItem.setLastPage(true);
					paginationItem.setPageNumber(this.currentPageNumber - i);
					paginationItems.insertElementAt(paginationItem, 0);
				} else {

					if (this.currentPageNumber > 6) {
						paginationItem.setPageNumber(start - 5);
					} else {
						paginationItem.setPageNumber(i + 1);
					}

					if (paginationItem.getPageNumber() == currentPageNumber) {
						paginationItem.setActive(true);
					}

					if (paginationItem.getPageNumber() == this.getTotalPages()) {
						lastPage = true;
					} else {
						start++;
					}

					if (i == 9 && !lastPage) {
						paginationItem.setNext(true);
					}

					paginationItems.add(i, paginationItem);
				}

			}
		}

	}

	/**
	 * @return Returns the currentPageNumber.
	 */
	public int getCurrentPageNumber() {
		return currentPageNumber;
	}

	/**
	 * @param currentPageNumber
	 *            The currentPageNumber to set.
	 */
	public void setCurrentPageNumber(int currentPageNumber) {
		this.currentPageNumber = currentPageNumber;
	}

	/**
	 * @return Returns the nextPageNumber.
	 */
	public int getNextPageNumber() {
		return currentPageNumber + 1;
	}

	/**
	 * @return Returns the numberPages.
	 */
	public int getNumberPages() {
		if ((this.resultNumber / this.resultsPerPage) > 0) {
			return (this.resultNumber / this.resultsPerPage);
		}
		return 0;
	}

	/**
	 * @return Returns the previousPageNumber.
	 */
	public int getPreviousPageNumber() {
		return previousPageNumber;
	}

	/**
	 * @param previousPageNumber
	 *            The previousPageNumber to set.
	 */
	public void setPreviousPageNumber(int previousPageNumber) {
		this.previousPageNumber = previousPageNumber;
	}

	/**
	 * @return Returns the resultNumber.
	 */
	public int getResultNumber() {
		return resultNumber;
	}

	/**
	 * @param resultNumber
	 *            The resultNumber to set.
	 */
	public void setResultNumber(int resultNumber) {
		this.resultNumber = resultNumber;
	}

	/**
	 * @return Returns the resultsPerPage.
	 */
	public int getResultsPerPage() {
		return resultsPerPage;
	}

	/**
	 * @param resultsPerPage
	 *            The resultsPerPage to set.
	 */
	public void setResultsPerPage(int resultsPerPage) {
		this.resultsPerPage = resultsPerPage;
	}

	/**
	 * @return Returns the firstResult.
	 */
	public int getFirstResult() {
		return (this.currentPageNumber - 1) * this.resultsPerPage;
	}

	/**
	 * @param firstResult
	 *            The firstResult to set.
	 */
	public void setFirstResult(int firstResult) {
	}

	/**
	 * @return Returns the totalPages.
	 */
	public int getTotalPages() {
		if (this.resultNumber % this.resultsPerPage > 0) {
			return (this.resultNumber / this.resultsPerPage) + 1;
		}

		return getNumberPages();
	}

	/**
	 * @param totalPages
	 *            The totalPages to set.
	 */
	public void setTotalPages(int totalPages) {
	}

	/**
	 * @return Returns the paginationItems.
	 */
	public Vector getPaginationItems() {
		return paginationItems;
	}

	/**
	 * @param paginationItems
	 *            The paginationItems to set.
	 */
	public void setPaginationItems(Vector<PaginationItem> paginationItems) {
		this.paginationItems = paginationItems;
	}

	/**
	 * @return Returns the previous.
	 */
	public boolean isPrevious() {
		return previous;
	}

	/**
	 * @param previous
	 *            The previous to set.
	 */
	public void setPrevious(boolean previous) {
		this.previous = previous;
	}

	/**
	 * @param nextPageNumber
	 *            The nextPageNumber to set.
	 */
	public void setNextPageNumber(int nextPageNumber) {
	}
}
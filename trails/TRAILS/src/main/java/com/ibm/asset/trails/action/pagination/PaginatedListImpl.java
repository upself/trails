package com.ibm.asset.trails.action.pagination;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.displaytag.properties.SortOrderEnum;

public class PaginatedListImpl implements IExtendedPaginatedList {

	private int index;
	private int pageSize;
	private int fullListSize;
	private List<? extends Object> list;
	private SortOrderEnum sortDirection = SortOrderEnum.ASCENDING;
	private String sort;
	private String dir;
	private String page;
	private String sortCriterion;

	public PaginatedListImpl() {
		// empty constructor
	}

	public PaginatedListImpl(final HttpServletRequest request,
			final int newPageSize) {
		sortCriterion = request
				.getParameter(RequestParametersEnum.SORT.value());
		sortDirection = RequestParametersEnum.DESC.value().equals(
				request.getParameter(RequestParametersEnum.DIRECTION.value())) ? SortOrderEnum.DESCENDING
				: SortOrderEnum.ASCENDING;
		pageSize = newPageSize == 0 ? DEFAULT_PAGE_SIZE : newPageSize;
		final String page = request.getParameter(RequestParametersEnum.PAGE
				.value());
		index = page == null ? 0 : Integer.parseInt(page) - 1;
	}

	public int getFirstRecordIndex() {
		return index * pageSize;
	}

	public int getIndex() {
		return index;
	}

	public void setIndex(final int index) {
		this.index = index;
	}

	public int getPageSize() {
		return pageSize;
	}

	public void setPageSize(final int pageSize) {
		this.pageSize = pageSize;
	}

	public List<? extends Object> getList() {
		return list;
	}

	public void setList(final List<? extends Object> results) {
		this.list = results;
	}

	public int getFullListSize() {
		return fullListSize;
	}

	public void setTotalNumberOfRows(final int total) {
		this.fullListSize = total;
	}

	public int getTotalPages() {
		return (int) Math.ceil(((double) fullListSize) / pageSize);
	}

	public int getObjectsPerPage() {
		return pageSize;
	}

	public int getPageNumber() {
		return index + 1;
	}

	public String getSearchId() {
		return null;
	}

	public String getSortCriterion() {
		return sortCriterion;
	}

	public SortOrderEnum getSortDirection() {
		return sortDirection;
	}

	public void setSortCriterion(final String sortCriterion) {
		this.sortCriterion = sortCriterion;
	}

	public void setSortDirection(final SortOrderEnum sortDirection) {
		this.sortDirection = sortDirection;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(final String sort) {
		this.sort = sort;
	}

	public String getDir() {
		return dir;
	}

	public void setDir(final String dir) {
		this.dir = dir;
	}

	public String getPage() {
		return page;
	}

	public void setPage(final String page) {
		this.page = page;
	}

	public void setFullListSize(final int fullListSize) {
		this.fullListSize = fullListSize;
	}
}

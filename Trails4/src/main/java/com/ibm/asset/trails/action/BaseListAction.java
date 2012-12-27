package com.ibm.asset.trails.action;

import org.displaytag.properties.SortOrderEnum;

import com.ibm.tap.trails.framework.DisplayTagList;
import com.opensymphony.xwork2.Preparable;

public class BaseListAction extends BaseAction implements Preparable {

	private static final long serialVersionUID = 1L;

	private DisplayTagList data = new DisplayTagList();

	private int startIndex;

	private int page = 1;

	private String dir = "desc";

	private String sort;

	public void prepare() {

		if (page > 1) {
			setStartIndex(data.getObjectsPerPage() * (page - 1));
		} else {
			setStartIndex(0);
		}

		if (sort != null) {
			if (dir.equals("desc")) {
				data.setSortDirection(SortOrderEnum.DESCENDING);
			} else {
				data.setSortDirection(SortOrderEnum.ASCENDING);
			}
			data.setSortCriterion(sort);
		} else {
			data.setSortDirection(SortOrderEnum.ASCENDING);
		}

		data.setPageNumber(page);
	}

	public DisplayTagList getData() {
		return data;
	}

	public void setData(DisplayTagList data) {
		this.data = data;
	}

	public String getDir() {
		return dir;
	}

	public void setDir(String dir) {
		this.dir = dir;
	}

	public int getPage() {
		return page;
	}

	public void setPage(int page) {
		this.page = page;
	}

	public String getSort() {
		return sort;
	}

	public void setSort(String sort) {
		this.sort = sort;
	}

	public int getStartIndex() {
		return startIndex;
	}

	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}
}

package com.ibm.asset.trails.action.pagination;

import java.util.List;

import org.displaytag.pagination.PaginatedList;
import org.displaytag.properties.SortOrderEnum;

public interface IExtendedPaginatedList extends PaginatedList {

	int DEFAULT_PAGE_SIZE = 25;

	void setList(List<? extends Object> result);

	void setTotalNumberOfRows(int total);

	void setPageSize(int pageSize);

	void setIndex(int index);

	int getFirstRecordIndex();

	int getPageSize();

	void setSortDirection(SortOrderEnum sortOrderEnum);

	void setSortCriterion(String sortCriterion);
}

package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.AccountSearch;

public interface SearchService {

	public List<AccountSearch> searchAccounts(String searchString,
			boolean nameSearch,
			boolean accountNumberSearch) throws Exception;
}

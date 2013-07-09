package com.ibm.asset.trails.action;

import java.util.List;

import org.apache.struts2.interceptor.validation.SkipValidation;

import com.ibm.asset.trails.domain.AccountSearch;
import com.ibm.asset.trails.form.SearchAccount;
import com.ibm.asset.trails.service.SearchService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Action;
import com.opensymphony.xwork2.validator.annotations.Validations;
import com.opensymphony.xwork2.validator.annotations.VisitorFieldValidator;

public class SearchAccountAction extends BaseAction implements SearchAction {

	private static final long serialVersionUID = 1L;

	private List<AccountSearch> accountSearch;

	private SearchAccount searchAccount;

	private SearchService searchService;

	// setup our form a bit
	@UserRole(userRole = UserRoleType.READER)
	public void prepare() throws Exception {
		if (searchAccount == null) {
			searchAccount = new SearchAccount();
			this.searchAccount.setNameSearch(true);
		}
	}

	@SkipValidation
	@UserRole(userRole = UserRoleType.READER)
	public String execute() {
		return SUCCESS;
	}
	
	@UserRole(userRole = UserRoleType.READER)
	public String home() {
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.READER)
	@Validations(visitorFields = { @VisitorFieldValidator(fieldName = "searchAccount", appendPrefix = false) })
	public String search() throws Exception {
		setAccountSearch(getSearchService().searchAccounts(
				getSearchAccount().getSearchString(),
				getSearchAccount().isOutOfScopeSearch(),
				getSearchAccount().isNameSearch(),
				getSearchAccount().isAccountNumberSearch()));
		return Action.SUCCESS;
	}

	public List<AccountSearch> getAccountSearch() {
		return accountSearch;
	}

	public void setAccountSearch(List<AccountSearch> accountSearch) {
		this.accountSearch = accountSearch;
	}

	public SearchAccount getSearchAccount() {
		return searchAccount;
	}

	public void setSearchAccount(SearchAccount searchAccount) {
		this.searchAccount = searchAccount;
	}

	public SearchService getSearchService() {
		return searchService;
	}

	public void setSearchService(SearchService searchService) {
		this.searchService = searchService;
	}
}

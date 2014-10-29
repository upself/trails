package com.ibm.asset.trails.action;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.tap.trails.framework.UserSession;
import com.opensymphony.xwork2.Preparable;

@Controller
public class AccountBaseAction extends BaseListActionWithSession implements
		Preparable {
	private static final long serialVersionUID = -7581633343527644574L;
	private Long accountId;
	private Account account;
	@Autowired
	private AccountService accountService;

	@Override
	public void prepare() {
		super.prepare();
		UserSession user = getUserSession();
		account = retrieveSessionAccount(user.getAccount());
		user.setAccount(account);
		setUserSession(user);
	}

	private Account retrieveSessionAccount(Account currentAccount) {
		Account result;
		if (currentAccount == null) {
			if (accountId == null) {
				result = currentAccount;
			} else {
				result = accountService.getAccount(accountId);
			}
		} else if (accountId == null) {
			result = currentAccount;
		} else {
			result = accountService.getAccount(accountId);
		}
		return result;
	}

	public Long getAccountId() {
		return accountId;
	}

	public void setAccountId(Long accountId) {
		this.accountId = accountId;
	}

	public Account getAccount() {
		return account;
	}

	public void setAccount(Account account) {
		this.account = account;
	}

	public AccountService getAccountService() {
		return accountService;
	}

	public void setAccountService(AccountService accountService) {
		this.accountService = accountService;
	}
}

package com.ibm.asset.trails.domain;


public class AccountSearch {

	private Long accountId;

	private String accountName;

	private Long account;

	private String scope;

	private String dept;

	private String sector;

	private String type;

	private String dpe;

	// CPA - 3/31/09 - Commenting out for performance reasons
	//private Integer maxAlertAge;

	public AccountSearch() {

	}

	public Long getAccount() {
		return account;
	}

	public void setAccount(Long account) {
		this.account = account;
	}

	public String getDept() {
		return dept;
	}

	public void setDept(String dept) {
		this.dept = dept;
	}

	public String getDpe() {
		return dpe;
	}

	public void setDpe(String dpe) {
		this.dpe = dpe;
	}

	public Long getAccountId() {
		return accountId;
	}

	public void setAccountId(Long accountId) {
		this.accountId = accountId;
	}

	/* CPA - 3/31/09 - Commenting out for performance reasons
	public Integer getMaxAlertAge() {
		return maxAlertAge;
	}

	public void setMaxAlertAge(Integer maxAlertAge) {
		this.maxAlertAge = maxAlertAge;
	}
	*/

	public String getAccountName() {
		return accountName;
	}

	public void setAccountName(String accountName) {
		this.accountName = accountName;
	}

	public String getScope() {
		if (scope == null) {
			return "No";
		}
		return scope;
	}

	public void setScope(String scope) {
		this.scope = scope;
	}

	public String getSector() {
		return sector;
	}

	public void setSector(String sector) {
		this.sector = sector;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	/* CPA - 3/31/09 - Commenting out for performance reasons
	public String getAlertStatus() {

		if (maxAlertAge == null) {
			return "Blue";
		} else if (maxAlertAge > AlertView.red) {
			return "Red";
		} else if (maxAlertAge > AlertView.yellow) {
			return "Yellow";
		}

		return "Green";
	}
	*/
}

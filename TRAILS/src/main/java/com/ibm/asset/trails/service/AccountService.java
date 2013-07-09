package com.ibm.asset.trails.service;

import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.CountryCode;
import com.ibm.asset.trails.domain.Department;
import com.ibm.asset.trails.domain.Geography;
import com.ibm.asset.trails.domain.Region;
import com.ibm.asset.trails.domain.Sector;

public interface AccountService {

	public Account getAccount(Long id);

	public Geography getGeography(Long id);

	public Region getRegion(Long id);

	public CountryCode getCountryCode(Long id);

	public Department getDepartment(Long id);

	public Sector getSector(Long id);

	public Account getAccountByAccountNumber(Long accountNumber);
}

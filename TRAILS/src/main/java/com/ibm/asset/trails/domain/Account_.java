package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.metamodel.SetAttribute;
import javax.persistence.metamodel.SingularAttribute;
import javax.persistence.metamodel.StaticMetamodel;


@StaticMetamodel(Account.class)
public class Account_ {
	public static volatile SingularAttribute<Account, Long> id;
	public static volatile SingularAttribute<Account, Sector> sector;
	public static volatile SingularAttribute<Account, String> name;
	public static volatile SingularAttribute<Account, Long> account;
	public static volatile SingularAttribute<Account, String> status;
	public static volatile SingularAttribute<Account, String> swlm;
	public static volatile SingularAttribute<Account, String> softwareInterlock;
	public static volatile SingularAttribute<Account, String> softwareTracking;
	public static volatile SingularAttribute<Account, String> softwareFinancialManagement;
	public static volatile SingularAttribute<Account, String> softwareComplianceManagement;
	public static volatile SingularAttribute<Account, String> softwareFinancialResponsibility;
	public static volatile SingularAttribute<Account, String> hardwareSupport;
	public static volatile SingularAttribute<Account, Date> contractSignDate;
	public static volatile SingularAttribute<Account, String> softwareSupport;
	public static volatile SingularAttribute<Account, String> accountStr;
	public static volatile SingularAttribute<Account, Department> department;
	public static volatile SingularAttribute<Account, Industry> industry;
	public static volatile SingularAttribute<Account, Dpe> dpe;
	public static volatile SingularAttribute<Account, SoftwareContact> softwareContact;
	public static volatile SingularAttribute<Account, AccountType> accountType;
	public static volatile SingularAttribute<Account, CountryCode> countryCode;
	public static volatile SetAttribute<Account, AccountPool> masterAccounts;
	public static volatile SetAttribute<Account, AlertView> alerts;
	public static volatile SingularAttribute<Account, Integer> scanValidity;
}

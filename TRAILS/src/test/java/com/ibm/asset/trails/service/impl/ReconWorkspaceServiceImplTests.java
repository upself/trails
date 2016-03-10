package com.ibm.asset.trails.service.impl;

import java.lang.reflect.InvocationHandler;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;

import junit.framework.Assert;
import junit.framework.AssertionFailedError;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.dao.DataAccessException;
import org.springframework.jdbc.core.ResultSetExtractor;
import org.springframework.jdbc.core.namedparam.NamedParameterJdbcTemplate;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.BeforeTransaction;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.AlertUnlicensedSoftwareDAO;
import com.ibm.asset.trails.domain.Account;
import com.ibm.asset.trails.domain.AlertUnlicensedSw;
import com.ibm.asset.trails.domain.License;
import com.ibm.asset.trails.domain.Recon;
import com.ibm.asset.trails.domain.ReconWorkspace;
import com.ibm.asset.trails.domain.ReconcileType;
import com.ibm.asset.trails.domain.UsedLicense;
import com.ibm.asset.trails.service.AccountService;
import com.ibm.asset.trails.service.LicenseService;
import com.ibm.asset.trails.service.ReconWorkspaceService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
public class ReconWorkspaceServiceImplTests {

	@Autowired
	private ReconWorkspaceService reconWorkspaceService;

	@Autowired
	private AccountService accountService;

	@Autowired
	private LicenseService licenseService;

	@Autowired
	private AlertUnlicensedSoftwareDAO alertDAO;

	@Autowired
	private NamedParameterJdbcTemplate jdbcTemplate;

	// variables setting up in start.
	private Long expectedClosedAlertId;
	private Long productId;
	private Account testAccount;

	/*
	 * Reset the age of the open alerts for product 'COREL WINZIP' under testing
	 * account 35400.
	 * 
	 * This have to be done before the testing transaction start or the change
	 * into DB won't be affected. The change won't be persisted until the
	 * commit(end) of the transaction. DAO query is not supported outside
	 * transaction so we have to use the JDBC operation directly.
	 */
	@BeforeTransaction
	public void resetAlertsAge() {
		// product id 133253 - 'COREL WINZIP';
		this.productId = Long.valueOf(133253);
		this.testAccount = accountService.getAccount(Long.valueOf(2541));

		// This query extract from
		// AlertUnlicensedSoftwareDAO.findAffectedAlertList(testAccount.getId(),
		// productId, false, false, "ALL", true)
		String queryOpenAlertsId = "SELECT AUS.Id, AUS.CREATION_TIME FROM EAADMIN.Alert_Unlicensed_Sw AUS, EAADMIN.Installed_Software IS, EAADMIN.Software_Lpar SL, EAADMIN.Software SW, EAADMIN.Hw_Sw_Composite HSC WHERE AUS.Open = 1 AND SL.Customer_Id = :customerId AND SW.Software_Id = :productId AND IS.Id = AUS.Installed_Software_Id AND SL.Id = IS.Software_Lpar_Id AND SW.Software_Id = IS.Software_Id AND HSC.Software_Lpar_Id = SL.Id ORDER BY AUS.CREATION_TIME DESC";

		Map<String, Object> params = new HashMap<String, Object>();
		params.put("customerId", this.testAccount.getId());
		params.put("productId", this.productId);

		@SuppressWarnings("unchecked")
		List<Long> openAlertsIds = (List<Long>) this.jdbcTemplate.query(
				queryOpenAlertsId, params, new ResultSetExtractor<Object>() {

					public Object extractData(ResultSet rs)
							throws SQLException, DataAccessException {
						List<Long> result = new ArrayList<Long>();
						while (rs.next()) {
							Long alertId = rs.getLong(1);
							result.add(alertId);
						}
						return result;
					}
				});

		GregorianCalendar calendar = new GregorianCalendar();
		int buffer = -10;
		int i = 1;
		// Stored the id of the oldest alert.
		Long oldestAlertId = -1l;

		for (Long alertId : openAlertsIds) {
			calendar.add(GregorianCalendar.DATE, buffer * i);

			params.clear();
			params.put("creationTime", calendar.getTime());
			params.put("alertId", alertId);
			jdbcTemplate
					.update("update alert_unlicensed_sw set creation_time = :creationTime where id = :alertId",
							params);

			oldestAlertId = alertId;
			i++;
		}

		this.expectedClosedAlertId = oldestAlertId;

	}

	/*
	 * Author: vndwbwan@cn.ibm.com
	 * 
	 * Testing manual recon close by per HWIFL 17231 in Jazz Hub.
	 */
	@Test
	@Transactional
	public void testManualReconGroupForStory17231() throws Throwable {

		// Preparing testing data.
		List<ReconWorkspace> reconWorkspaceList = new ArrayList<ReconWorkspace>();
		ReconWorkspace workspace = new ReconWorkspace();

		workspace.setProductInfoId(productId);
		reconWorkspaceList.add(workspace);

		License license = licenseService.findById(Long.valueOf(294658));
		// force to get the cap type, since it's lazy loading. avoid hibernate
		// session exception thrown.

		List<License> licenseList = new ArrayList<License>();
		licenseList.add(license);

		ReconcileType manualReconcileType = reconWorkspaceService
				.findReconcileType(Long.valueOf(1));

		Recon testRecon = new Recon();
		testRecon.setLicenseList(licenseList);
		testRecon.setList(reconWorkspaceList);
		testRecon.setAutomated(false);
		testRecon.setManual(false);
		testRecon.setPer("HWIFL");
		// Set max licenses equal to available qty , then only one alert will be
		// closed.
		testRecon.setMaxLicenses(license.getAvailableQty());
		testRecon.setReconcileType(manualReconcileType);

		String remoteUser = "JUnit-TRAILS";
		Class<? extends ReconWorkspaceServiceImpl> clazz = ReconWorkspaceServiceImpl.class;

		// End of preparing testing data.

		try {
			// Perform the unit execution.
			@SuppressWarnings("rawtypes")
			Class[] argsManualReconGroup = new Class[] { Account.class,
					String.class, Recon.class, String.class };
			Method methodManualReconGroup = clazz.getDeclaredMethod(
					"manualReconGroup", argsManualReconGroup);
			methodManualReconGroup.setAccessible(true);

			InvocationHandler handlerManualReconGroup = Proxy
					.getInvocationHandler(reconWorkspaceService);
			handlerManualReconGroup.invoke(reconWorkspaceService,
					methodManualReconGroup, new Object[] { testAccount,
							remoteUser, testRecon, "ALL" });
			// End of unit execution.

			// Checking result.
			List<Long> alertList = alertDAO.findAffectedAlertList(
					testAccount.getId(), productId, false, true, "ALL", false);

			AlertUnlicensedSw alert = alertDAO.findById(alertList.get(0));
			alertDAO.refresh(alert);

			String code = alert.getReconcile().getAllocationMethodology()
					.getCode();
			Set<UsedLicense> usedLicenseSet = alert.getReconcile()
					.getUsedLicenses();
			int usedQuantity = 0;

			for (UsedLicense usedLicense : usedLicenseSet) {
				if (null != usedLicense.getUsedQuantity()) {
					usedQuantity += usedLicense.getUsedQuantity();
				}
			}

			Assert.assertEquals("HWIFL", code);
			Assert.assertEquals(10, usedQuantity);
			// End of checking result.

		} finally {
			// Clean the testing data.
			@SuppressWarnings("rawtypes")
			Class[] argsBreakManualGroup = new Class[] { Account.class,
					String.class, List.class, ReconcileType.class, String.class };
			Method methodBreakManualReconGroup = clazz.getDeclaredMethod(
					"breakManualReconGroup", argsBreakManualGroup);
			methodBreakManualReconGroup.setAccessible(true);

			InvocationHandler handlerBreakManualReconGroup = Proxy
					.getInvocationHandler(reconWorkspaceService);
			handlerBreakManualReconGroup.invoke(reconWorkspaceService,
					methodBreakManualReconGroup, new Object[] { testAccount,
							remoteUser, reconWorkspaceList,
							manualReconcileType, "ALL" });

		}
	}

	/*
	 * Author: Yi R Zhang/China/IBM
	 * 
	 * Testing manual recon close the oldest alerts first. Details check story
	 * 16837 in Jazz Hub.
	 */
	@Test
	@Transactional
	public void testManualReconGroupForStory16837() throws Throwable {

		// Preparing testing data.

		List<ReconWorkspace> reconWorkspaceList = new ArrayList<ReconWorkspace>();
		ReconWorkspace workspace = new ReconWorkspace();

		workspace.setProductInfoId(productId);
		reconWorkspaceList.add(workspace);

		License license = licenseService.findById(Long.valueOf(337239));
		// force to get the cap type, since it's lazy loading. avoid hibernate
		// session exception thrown.

		List<License> licenseList = new ArrayList<License>();
		licenseList.add(license);

		ReconcileType manualReconcileType = reconWorkspaceService
				.findReconcileType(Long.valueOf(1));

		Recon testRecon = new Recon();
		testRecon.setLicenseList(licenseList);
		testRecon.setList(reconWorkspaceList);
		testRecon.setAutomated(false);
		testRecon.setManual(false);
		testRecon.setPer("LPAR");
		// Set max licenses equal to available qty , then only one alert will be
		// closed.
		testRecon.setMaxLicenses(license.getAvailableQty());
		testRecon.setReconcileType(manualReconcileType);

		String remoteUser = "JUnit-TRAILS";
		Class<? extends ReconWorkspaceServiceImpl> clazz = ReconWorkspaceServiceImpl.class;

		// End of preparing testing data.

		try {
			// Perform the unit execution.
			@SuppressWarnings("rawtypes")
			Class[] argsManualReconGroup = new Class[] { Account.class,
					String.class, Recon.class, String.class };
			Method methodManualReconGroup = clazz.getDeclaredMethod(
					"manualReconGroup", argsManualReconGroup);
			methodManualReconGroup.setAccessible(true);

			InvocationHandler handlerManualReconGroup = Proxy
					.getInvocationHandler(reconWorkspaceService);
			handlerManualReconGroup.invoke(reconWorkspaceService,
					methodManualReconGroup, new Object[] { testAccount,
							remoteUser, testRecon, "ALL" });
			// End of unit execution.

			// Checking result.
			List<Long> alertList = alertDAO.findAffectedAlertList(
					testAccount.getId(), productId, false, true, "ALL", false);

			Assert.assertNotNull(alertList);
			Assert.assertTrue(alertList.size() > 0);

			AlertUnlicensedSw alert = alertDAO.findById(alertList.get(0));
			alertDAO.refresh(alert);

			// Only one alert will be closed.
			Assert.assertEquals(1, alertList.size());
			Assert.assertEquals(remoteUser, alert.getReconcile()
					.getRemoteUser());
			// Oldest alert will be closed.
			Assert.assertEquals(expectedClosedAlertId, alert.getId());

			// End of checking result.

		} finally {
			// Clean the testing data.
			@SuppressWarnings("rawtypes")
			Class[] argsBreakManualGroup = new Class[] { Account.class,
					String.class, List.class, ReconcileType.class, String.class };
			Method methodBreakManualReconGroup = clazz.getDeclaredMethod(
					"breakManualReconGroup", argsBreakManualGroup);
			methodBreakManualReconGroup.setAccessible(true);

			InvocationHandler handlerBreakManualReconGroup = Proxy
					.getInvocationHandler(reconWorkspaceService);
			handlerBreakManualReconGroup.invoke(reconWorkspaceService,
					methodBreakManualReconGroup, new Object[] { testAccount,
							remoteUser, reconWorkspaceList,
							manualReconcileType, "ALL" });

		}

	}

}

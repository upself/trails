package com.ibm.asset.trails.test.service.impl;

import static org.junit.Assert.*;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.AccountSearch;
import com.ibm.asset.trails.service.SearchService;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/h2/applicationContext-test-h2.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional(propagation = Propagation.REQUIRED)
public class SearchServiceImplTest {

	@Autowired
	private SearchService searchService;

	@Test
	public void testSearchAccounts() throws Exception {
		List<AccountSearch> accountSearchList = searchService.searchAccounts("35400", true, true);
		assertNotNull(accountSearchList);
		assertTrue(accountSearchList.size() > 0);
		assertNotNull(accountSearchList.get(0));
		assertNotNull(accountSearchList.get(0).getScope());
		assertTrue(accountSearchList.get(0).getScope().trim().equalsIgnoreCase("YES"));
		assertNotNull(accountSearchList.get(0).getSwTrackingScope());
		assertTrue(accountSearchList.get(0).getSwTrackingScope().trim().equalsIgnoreCase("YES"));
	}
}

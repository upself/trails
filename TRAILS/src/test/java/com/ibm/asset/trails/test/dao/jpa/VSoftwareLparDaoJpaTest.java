package com.ibm.asset.trails.test.dao.jpa;

import static org.junit.Assert.*;

import org.displaytag.properties.SortOrderEnum;
import org.junit.Before;
import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.VSoftwareLparDAO;
import com.ibm.asset.trails.domain.ReconSetting;
import com.ibm.asset.trails.test.fixtures.AccountFixtures;
import com.ibm.tap.trails.framework.DisplayTagList;

import java.lang.reflect.Method;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class VSoftwareLparDaoJpaTest {

	@Autowired
	private VSoftwareLparDAO vSwLparDAO;
	private int page = 1;
	private String sort = "sw.softwareName";
	private int startIndex = 1;
	private String dir = "ASC";
	
	DisplayTagList data = new DisplayTagList();
	@Autowired
	private AccountFixtures fixtures ;	
	
	ReconSetting reconSetting = new ReconSetting();
	
	public void setStartIndex(int startIndex) {
		this.startIndex = startIndex;
	}
	
	@Before
	public void prepare() {

		String[] softwareNames = new String[1];
		softwareNames[0] = "ICFRU Forward Catalog Recove - ICFRU Forward Catalog Recove - V1";
		reconSetting.setProductInfoNames(softwareNames);
		reconSetting.setAlertStatus("OPEN");
		fixtures.setUp();
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
	
	@Test
	public void test() throws NoSuchMethodException, Exception {	
//		System.out.print(reconSetting.getProductInfoNames()[0].toString());
//		System.out.print(reconSetting.getAlertStatus().toString());
//		System.out.print(fixtures.getTestAccount().getAccountStr());
		vSwLparDAO.paginatedList(data, fixtures.getTestAccount(), reconSetting, startIndex,
				9999, sort , "ASC");
		
		Class<?> noparams[] = {};
        Class<?> cls = Class.forName("com.ibm.asset.trails.domain.ReconWorkspace");
		Method method = cls.getDeclaredMethod("getPid", noparams);
		String pid = (String) method.invoke(data.getList().get(0));
		System.out.print(pid);

		assertEquals(pid,"5798-DXQ");
		
	}

}

package com.ibm.asset.trails.test.dao.jpa;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertNotNull;

import java.util.List;

import org.junit.Test;
import org.junit.runner.RunWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.test.context.ContextConfiguration;
import org.springframework.test.context.junit4.SpringJUnit4ClassRunner;
import org.springframework.test.context.transaction.TransactionConfiguration;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.dao.LicenseDAO;
import com.ibm.asset.trails.domain.License;
import com.ibm.tap.trails.framework.DisplayTagList;

@RunWith(SpringJUnit4ClassRunner.class)
@ContextConfiguration(locations = { "file:src/test/resources/applicationContext-test.xml" })
@TransactionConfiguration(transactionManager = "transactionManager", defaultRollback = true)
@Transactional
public class LicenseDAOJpaTests {

    @Autowired
    private LicenseDAO dao;
    private final DisplayTagList data = new DisplayTagList();
    private final Long accountId = 506L;
    private final int objectsPerPage = 50;

    @Test
    public void testFreePoolWithoutParentPaginatedList() {
        int startIndex = 0;
        String sort = "id";
        String dir = "asc";

        dao.freePoolWithoutParentPaginatedList(data, accountId, startIndex,
                objectsPerPage, sort, dir);

        List list = data.getList();
        for (Object o : list) {
            System.out.println(o.getClass());
        }

        assertEquals(data.getFullListSize(), 1286);
        assertEquals(data.getList().size(), objectsPerPage);
    }

    @Test
    public void testFreePoolWithParentPaginatedList() {
        int startIndex = 0;
        String sort = "quantity";
        String dir = "asc";

        dao.freePoolWithParentPaginatedList(data, accountId, startIndex,
                objectsPerPage, sort, dir);

        assertEquals(data.getFullListSize(), 1286);
        assertEquals(data.getList().size(), objectsPerPage);
    }

    @Test
    public void testPaginatedList() {
        int startIndex = 0;
        String sort = "id";
        String dir = "asc";

        dao.paginatedList(data, accountId, startIndex, objectsPerPage, sort,
                dir);

        assertEquals(data.getFullListSize(), 1286);
        assertEquals(data.getList().size(), objectsPerPage);
    }

    @Test
    public void testGetLicenseIdsByReconcileId() {
        Long reconcileId = 15349300L;
        List<Long> licenseIds = dao.getLicenseIdsByReconcileId(reconcileId);

        assertEquals(licenseIds.size(), 1);
    }

    @Test
    public void testGetLicenseDetails() {
        Long licenseId = 129105L;
        License license = dao.getLicenseDetails(licenseId);

        assertNotNull(license.getId());
    }

}

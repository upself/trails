package com.ibm.asset.trails.dao;

import java.util.List;

import com.ibm.asset.trails.domain.CapacityType;
import com.ibm.asset.trails.domain.License;
import com.ibm.tap.trails.framework.DisplayTagList;

public interface LicenseDAO extends BaseEntityDAO<License, Long> {

    void freePoolWithoutParentPaginatedList(DisplayTagList data,
            Long accountId, int startIndex, int objectsPerPage, String sort,
            String dir);

    void freePoolWithParentPaginatedList(DisplayTagList data, Long accountId,
            int startIndex, int objectsPerPage, String sort, String dir);

    List<CapacityType> getCapacityTypeList();

    License getLicenseDetails(Long id);

    void paginatedList(DisplayTagList data, Long accountId, int piStartIndex,
            int piObjectsPerPage, String psSort, String psDir);

    List<Long> getLicenseIdsByReconcileId(Long reconcileId);

}

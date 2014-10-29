package com.ibm.asset.trails.dao.jpa;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.PVUMapDAO;
import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.PvuMap;

@Repository
public class PVUMapDAOJpa extends AbstractGenericEntityDAOJpa<PvuMap, Long>
        implements PVUMapDAO {

    public PvuMap getPvuMapByBrandAndModelAndMachineTypeId(
            String lsProcessorBrand, String lsProcessorModel,
            MachineType lmtAlert) {
        @SuppressWarnings("unchecked")
        List<PvuMap> results = entityManager
                .createNamedQuery("getPvuMapByBrandAndModelAndMachineTypeId")
                .setParameter("processorBrand", lsProcessorBrand)
                .setParameter("processorModel", lsProcessorModel)
                .setParameter("machineType", lmtAlert).getResultList();
        PvuMap result;
        if (results == null || results.isEmpty()) {
            result = null;
        } else {
            result = results.get(0);
        }
        return result;
    }

}

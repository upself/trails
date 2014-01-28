package com.ibm.asset.trails.service.impl;

import java.util.Date;
import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.ProcessorValueUnit;
import com.ibm.asset.trails.domain.PvuMap;
import com.ibm.asset.trails.domain.ReconPvu;
import com.ibm.asset.trails.service.PvuService;

@Service
public class PvuServiceImpl implements PvuService {

    private EntityManager em;

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<ProcessorValueUnit> getPvuList() {
        return getEntityManager().createNamedQuery("pvuList").getResultList();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<String> getAssetProcessorBrandList() {
        return getEntityManager().createNamedQuery("processorBrandList")
                .getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ProcessorValueUnit findWithInfo(Long id) {
        return (ProcessorValueUnit) getEntityManager()
                .createNamedQuery("pvuWithInfo").setParameter("id", id)
                .getSingleResult();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<String> getAssetModelsWithAssetBrandAndMachineTypeId(
            String psProcessorBrand, Long plMachineTypeId) {
        return getEntityManager()
                .createNamedQuery("modelListUnderBrandAndMachineTypeId")
                .setParameter("processorBrand", psProcessorBrand)
                .setParameter("machineTypeId", plMachineTypeId).getResultList();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<String> getAssetModelsWithAssetBrandAndPvuIdAndMachineTypeId(
            String processorBrand, Long pvuId, Long plMachineTypeId) {
        return getEntityManager()
                .createNamedQuery("modelListUnderBrandAndPvuIdAndMachineTypeId")
                .setParameter("processorBrand", processorBrand)
                .setParameter("pvuId", pvuId)
                .setParameter("machineTypeId", plMachineTypeId).getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void updateModelPvuId(Long pvuId, String processorBrand,
            String processorModel) {
        getEntityManager().createNamedQuery("updateModelPvuId")
                .setParameter("processorBrand", processorBrand)
                .setParameter("pvuId", pvuId)
                .setParameter("processorModel", processorModel).executeUpdate();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<String> getAssetProcessorModelList(String processorBrand) {
        return getEntityManager().createNamedQuery("assetProcessorModels")
                .setParameter("processorBrand", processorBrand).getResultList();
    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public List<MachineType> selectMachineTypeListForProcessorBrand(
            String psProcessorBrand) {
        return getEntityManager()
                .createNamedQuery("machineTypeListForProcessorBrand")
                .setParameter("processorBrand", psProcessorBrand)
                .getResultList();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public MachineType selectMachineTypeDetailsById(Long plMachineTypeId) {
        return (MachineType) getEntityManager()
                .createNamedQuery("machineTypeDetailsById")
                .setParameter("id", plMachineTypeId).getSingleResult();
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void savePvuMap(ProcessorValueUnit pvu, String processorBrand,
            String processorModel, MachineType pMachineType) {

        PvuMap pvuMap = new PvuMap();
        pvuMap.setProcessorValueUnit(pvu);
        pvuMap.setProcessorBrand(processorBrand);
        pvuMap.setProcessorModel(processorModel);
        pvuMap.setMachineType(pMachineType);
        getEntityManager().persist(pvuMap);
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void deleteByUnique(ProcessorValueUnit pvu, String processorBrand,
            String processorModel, MachineType pMachineType) {
        getEntityManager().createNamedQuery("removePvuUnique")
                .setParameter("processorBrand", processorBrand)
                .setParameter("processorModel", processorModel)
                .setParameter("machineType", pMachineType).executeUpdate();
    }

    @Transactional(readOnly = false, propagation = Propagation.NOT_SUPPORTED)
    public ProcessorValueUnit getPvuById(Long id) {
        return getEntityManager().find(ProcessorValueUnit.class, id);
    }

    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void deletePvuMapAll(List<Long> deletePvuMapIdList) {

        for (Long pvuMapId : deletePvuMapIdList) {
            getEntityManager().createNamedQuery("removePvuMapById")
                    .setParameter("id", pvuMapId).executeUpdate();

        }

    }

    @SuppressWarnings("unchecked")
    @Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
    public void updateReconPvu(String brand, String model,
            MachineType pMachineType, String action) {
        List<ReconPvu> reconPvus = getEntityManager()
                .createNamedQuery("getReconPvuByUniqueKeys")
                .setParameter("prcsrBrand", brand)
                .setParameter("prcsrModel", model).getResultList();

        if (!reconPvus.isEmpty()) {
            for (ReconPvu reconPvu : reconPvus) {
                storeReconPvu(action, reconPvu);
            }
        } else {
            ReconPvu reconPvu = new ReconPvu();
            reconPvu.setProcessorBrand(brand);
            reconPvu.setProcessorModel(model);
            reconPvu.setMachineType(pMachineType);
            storeReconPvu(action, reconPvu);
        }
    }

    private void storeReconPvu(String action, ReconPvu reconPvu) {
        reconPvu.setRecordTime(new Date());
        reconPvu.setRemoteUser("TRAILS");
        reconPvu.setAction(action);
        getEntityManager().persist(reconPvu);
    }

    private EntityManager getEntityManager() {
        return em;
    }

    @PersistenceContext(unitName="trailspd")
    public void setEntityManager(EntityManager em) {
        this.em = em;
    }
}

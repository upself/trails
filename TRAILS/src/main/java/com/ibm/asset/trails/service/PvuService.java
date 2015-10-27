package com.ibm.asset.trails.service;

import java.util.List;

import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.ProcessorValueUnit;

public interface PvuService {

	List<ProcessorValueUnit> getPvuList();
	List<ProcessorValueUnit> getPvuList(int startIndex,int objectsPerPage, String sort, String dir);

	void savePvuMap(ProcessorValueUnit pvu, String processorBrand,
			String processorModel, MachineType pMachineType);

	void deletePvuMapAll(List<Long> deletePvuMapIdList);

	void deleteByUnique(ProcessorValueUnit pvu, String processorBrand,
			String processorModel, MachineType pMachineType);

	List<String> getAssetProcessorBrandList();

	ProcessorValueUnit findWithInfo(Long pvuId);

	List<String> getAssetModelsWithAssetBrandAndMachineTypeId(
			String psProcessorBrand, Long plMachineTypeId);

	List<String> getAssetModelsWithAssetBrandAndPvuIdAndMachineTypeId(
			String processorBrand, Long pvuId, Long plMachineTypeId);

	List<String> getAssetProcessorModelList(String processorBrand);

	void updateModelPvuId(Long pvuId, String processorBrand,
			String processorModel);

	void updateReconPvu(String brand, String model, MachineType pMachineType,
			String action);

	List<MachineType> selectMachineTypeListForProcessorBrand(
			String psProcessorBrand);

	MachineType selectMachineTypeDetailsById(Long plMachineTypeId);
}

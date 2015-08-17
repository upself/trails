package com.ibm.asset.trails.action;

import java.util.ArrayList;
import java.util.List;

import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.domain.ProcessorValueUnit;
import com.ibm.asset.trails.service.PvuService;
import com.ibm.tap.trails.annotation.UserRole;
import com.ibm.tap.trails.annotation.UserRoleType;
import com.opensymphony.xwork2.Preparable;

public class PvuMappingAction extends BaseAction implements Preparable {

	private static final long serialVersionUID = 1L;

	private static final String INIT = "init";

	private Long pvuId;

	private PvuService pvuService;

	private ProcessorValueUnit pvu;

	private String processorModel;

	private List<ProcessorValueUnit> pvuArrayList;

	private List<String> processorBrandList;

	private List<String> selectedProcessorModels;

	private List<String> selectedProcessorBrands;

	private List<String> freeProcessorModels;

	private List<String> addCollection;

	private List<String> removeCollection;

	private String currentProcessorBrand;

	private List<String> machineTypeList;

	private String machineTypeId;

	private MachineType machineType;

	public void prepare() throws Exception {
		if (pvuId != null) {
			pvu = pvuService.findWithInfo(pvuId);
		}
		if (machineTypeId != null && !"".equals(machineTypeId)) {
			machineType = pvuService.selectMachineTypeDetailsById(Long
					.valueOf(machineTypeId));
		}
	}

	@UserRole(userRole = UserRoleType.ADMIN)
	public String doListPvu() {
		setPvuArrayList(getPvuService().getPvuList());
		return SUCCESS;
	}

	@UserRole(userRole = UserRoleType.ADMIN)
	public String doUpdatePvuMap() {
		if (isPageInit() && selectedProcessorBrands != null
				&& selectedProcessorBrands.size() == 1) {

			currentProcessorBrand = getSelectedProcessorBrands().get(0);

			if ("".equals(currentProcessorBrand)) {
				return SUCCESS;
			}

			List<String> mappedModelsUnderBrandAndPvuIdAndMachineTypeId = pvuService
					.getAssetModelsWithAssetBrandAndPvuIdAndMachineTypeId(
							currentProcessorBrand, pvu.getId(), Long
									.valueOf(machineTypeId));

			List<String> mappedModelsUnderBrandAndMachineTypeId = pvuService
					.getAssetModelsWithAssetBrandAndMachineTypeId(currentProcessorBrand,
							Long.valueOf(machineTypeId));

			trimStringList(mappedModelsUnderBrandAndPvuIdAndMachineTypeId);
			trimStringList(mappedModelsUnderBrandAndMachineTypeId);

			removeCollection = cloneStringList(mappedModelsUnderBrandAndPvuIdAndMachineTypeId);
			removeCollection.removeAll(getSelectedProcessorModels());

			addCollection = cloneStringList(getSelectedProcessorModels());
			addCollection
					.removeAll(mappedModelsUnderBrandAndPvuIdAndMachineTypeId);

			removePvuMap(removeCollection);
			addPvuMap(addCollection);

			// refresh the page content.
			setSelectedProcessorBrands(getPvuService()
					.getAssetProcessorBrandList());
			setMachineTypeList(new ArrayList<String>());
			getSelectedProcessorModels().clear();
			getFreeProcessorModels().clear();

			return SUCCESS;
		} else if (isPageInit()) {
			setSelectedProcessorBrands(getPvuService()
					.getAssetProcessorBrandList());
			setMachineTypeList(new ArrayList<String>());
			return INIT;
		}

		return ERROR;
	}

	private void removePvuMap(List<String> modellist) {
		for (String processorModel : modellist) {
			PvuService pvuSrvc = getPvuService();
			pvuSrvc.deleteByUnique(pvu, currentProcessorBrand, processorModel,
					machineType);
			pvuSrvc.updateReconPvu(currentProcessorBrand, processorModel,
					machineType, "DEL");
		}
	}

	private void addPvuMap(List<String> modelList) {
		for (String processorModel : modelList) {
			PvuService pvuSrvc = getPvuService();
			pvuSrvc.savePvuMap(pvu, currentProcessorBrand, processorModel,
					machineType);
			pvuSrvc.updateReconPvu(currentProcessorBrand, processorModel,
					machineType, "ADD");
		}
	}

	private List<String> cloneStringList(List<String> src) {
		List<String> newL = new ArrayList<String>();

		for (String s : src) {
			newL.add(s);
		}
		return newL;
	}

	private boolean isPageInit() {
		return pvuId != null;
	}

	private void trimStringList(List<String> org) {
		List<String> temp = new ArrayList<String>();
		for (String model : org) {
			temp.add(model.trim());
		}
		org.clear();
		org.addAll(temp);
	}

	public void setPvuService(PvuService pvuService) {
		this.pvuService = pvuService;
	}

	public PvuService getPvuService() {
		return pvuService;
	}

	private void setPvuArrayList(List<ProcessorValueUnit> pvuArrayList) {
		this.pvuArrayList = pvuArrayList;
	}

	public List<ProcessorValueUnit> getPvuArrayList() {
		return pvuArrayList;
	}

	public void setProcessorBrandList(List<String> processorBrandList) {
		this.processorBrandList = processorBrandList;
	}

	public List<String> getProcessorBrandList() {
		return processorBrandList;
	}

	public void setSelectedProcessorBrands(List<String> selectedProcessorBrands) {
		this.selectedProcessorBrands = selectedProcessorBrands;
	}

	public List<String> getSelectedProcessorBrands() {
		return this.selectedProcessorBrands;
	}

	/**
	 * @return the pvuId
	 */
	public Long getPvuId() {
		return pvuId;
	}

	/**
	 * @param pvuId
	 *            the pvuId to set
	 */
	public void setPvuId(Long pvuId) {
		this.pvuId = pvuId;
	}

	/**
	 * @return the pvu
	 */
	public ProcessorValueUnit getPvu() {
		return pvu;
	}

	/**
	 * @param pvu
	 *            the pvu to set
	 */
	public void setPvu(ProcessorValueUnit pvu) {
		this.pvu = pvu;
	}

	/**
	 * @return the processorModel
	 */
	public String getProcessorModel() {
		return processorModel;
	}

	/**
	 * @param processorModel
	 *            the processorModel to set
	 */
	public void setProcessorModel(String processorModel) {
		this.processorModel = processorModel;
	}

	public void setFreeProcessorModels(List<String> freeProcessorModels) {
		this.freeProcessorModels = freeProcessorModels;
	}

	public List<String> getFreeProcessorModels() {
		if (freeProcessorModels == null) {
			freeProcessorModels = new ArrayList<String>();
		}
		return freeProcessorModels;
	}

	public void setSelectedProcessorModels(List<String> selectedProcessorModels) {
		this.selectedProcessorModels = selectedProcessorModels;
	}

	public List<String> getSelectedProcessorModels() {
		if (selectedProcessorModels == null) {
			selectedProcessorModels = new ArrayList<String>();
		}
		return selectedProcessorModels;
	}

	public List<String> getAddCollection() {
		return addCollection;
	}

	public List<String> getRemoveCollection() {
		return removeCollection;
	}

	public String getCurrentProcessorBrand() {
		return currentProcessorBrand;
	}

	public List<String> getMachineTypeList() {
		return machineTypeList;
	}

	public void setMachineTypeList(List<String> machineTypeList) {
		this.machineTypeList = machineTypeList;
	}

	public String getMachineTypeId() {
		return machineTypeId;
	}

	public void setMachineTypeId(String machineTypeId) {
		this.machineTypeId = machineTypeId;
	}

	public MachineType getMachineType() {
		return machineType;
	}

	public void setMachineType(MachineType machineType) {
		this.machineType = machineType;
	}
}

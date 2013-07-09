package com.ibm.asset.trails.action;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletResponse;

import org.apache.struts2.interceptor.ServletResponseAware;

import com.ibm.asset.trails.domain.MachineType;
import com.ibm.asset.trails.service.PvuService;

public class PvuAjaxAction implements ServletResponseAware {

	private static final String SEPARATOR = "{sep}";

	private HttpServletResponse response;

	// field injected by spring.
	private PvuService pvuService;

	private String processorBrand;

	private Long pvuId;

	private Long machineTypeId;

	public void getAvailableProcessorModels() {
		if (processorBrand != null && pvuId != null && machineTypeId != null) {
			// get processor model from pvu map.
			List<String> mappedModelsUnderBrandAndPvuIdAndMachineTypeId = pvuService
					.getAssetModelsWithAssetBrandAndPvuIdAndMachineTypeId(processorBrand,
							pvuId, machineTypeId);

			List<String> mappedModelsUnderBrandAndMachineTypeId = pvuService
					.getAssetModelsWithAssetBrandAndMachineTypeId(processorBrand,
							machineTypeId);

			// get processor mode from hardware.
			List<String> freeProcessorModelList = pvuService
					.getAssetProcessorModelList(processorBrand);

			trimStringList(mappedModelsUnderBrandAndPvuIdAndMachineTypeId);
			trimStringList(freeProcessorModelList);
			trimStringList(mappedModelsUnderBrandAndMachineTypeId);

			// mappedModelsUnderBrandAndPvuIdAndMachineTypeId is sub set of
			// mappedModelsUnderBrandAndMachineTypeId.
			freeProcessorModelList.removeAll(mappedModelsUnderBrandAndMachineTypeId);

			try {
				StringBuffer result = new StringBuffer();
				constructFeedback(mappedModelsUnderBrandAndPvuIdAndMachineTypeId,
						result);
				result.append(SEPARATOR);
				constructFeedback(freeProcessorModelList, result);

				this.response.getWriter().write(result.toString());
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void getAvailableProcessorModels(List<MachineType> plMachineType) {
		if (processorBrand != null && pvuId != null && machineTypeId != null) {
			// get processor model from pvu map.
			List<String> mappedModelsUnderBrandAndPvuIdAndMachineTypeId = pvuService
					.getAssetModelsWithAssetBrandAndPvuIdAndMachineTypeId(processorBrand,
							pvuId, machineTypeId);

			List<String> mappedModelsUnderBrandAndMachineTypeId = pvuService
					.getAssetModelsWithAssetBrandAndMachineTypeId(processorBrand,
							machineTypeId);

			// get processor mode from hardware.
			List<String> freeProcessorModelList = pvuService
					.getAssetProcessorModelList(processorBrand);

			trimStringList(mappedModelsUnderBrandAndPvuIdAndMachineTypeId);
			trimStringList(freeProcessorModelList);
			trimStringList(mappedModelsUnderBrandAndMachineTypeId);

			// mappedModelsUnderBrandAndPvuIdAndMachineTypeId is sub set of
			// mappedModelsUnderBrandAndMachineTypeId.
			freeProcessorModelList.removeAll(mappedModelsUnderBrandAndMachineTypeId);

			try {
				StringBuffer result = new StringBuffer();
				constructFeedback(mappedModelsUnderBrandAndPvuIdAndMachineTypeId,
						result);
				result.append(SEPARATOR);
				constructFeedback(freeProcessorModelList, result);
				result.append(SEPARATOR);
				constructFeedbackForMachineTypeList(plMachineType, result);

				this.response.getWriter().write(result.toString());
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void getMachineTypes() {
		if (processorBrand != null && pvuId != null) {
			// Get List of MachineType objects for processor brand
			List<MachineType> llMachineType = pvuService
					.selectMachineTypeListForProcessorBrand(processorBrand);

			if (llMachineType.size() == 1) {
				setMachineTypeId(llMachineType.get(0).getId());
				getAvailableProcessorModels(llMachineType);
			} else {
				try {
					StringBuffer lsbResult = new StringBuffer();

					constructFeedbackForMachineTypeList(llMachineType, lsbResult);

					this.response.getWriter().write(lsbResult.toString());
				} catch (IOException e) {
					e.printStackTrace();
				}
			}
		}
	}

	private void constructFeedback(List<String> parameters, StringBuffer result) {
		for (String param : parameters) {
			result.append("<option value='" + param + "'>" + param
					+ "</option>\r");
		}
	}

	private void constructFeedbackForMachineTypeList(
			List<MachineType> plMachineType, StringBuffer psbResult) {
		if (plMachineType.size() > 1) {
			psbResult.append("<option value=''>Please make a selection</option>");
		}

		for (MachineType lmtTemp : plMachineType) {
			psbResult.append("<option value='").append(lmtTemp.getId()).append("'>").append(lmtTemp.getName()).append("</option>\r");
		}
	}

	private void trimStringList(List<String> org) {
		List<String> temp = new ArrayList<String>();
		for (String model : org) {
			temp.add(model.trim());
		}
		org.clear();
		org.addAll(temp);
	}

	// injected by spring.
	public void setPvuService(PvuService pvuService) {
		this.pvuService = pvuService;
	}

	/**
	 * @param processorBrand
	 *						the processorBrand to set
	 */
	public void setProcessorBrand(String processorBrand) {
		this.processorBrand = processorBrand;
	}

	public void setServletResponse(HttpServletResponse response) {
		this.response = response;
	}

	public void setPvuId(Long pvuId) {
		this.pvuId = pvuId;
	}

	public Long getMachineTypeId() {
		return machineTypeId;
	}

	public void setMachineTypeId(Long machineTypeId) {
		this.machineTypeId = machineTypeId;
	}
}

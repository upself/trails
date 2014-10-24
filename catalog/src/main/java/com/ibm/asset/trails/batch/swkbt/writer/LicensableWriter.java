package com.ibm.asset.trails.batch.swkbt.writer;

import java.util.List;
import java.util.Map;

import org.apache.log4j.Logger;
import org.springframework.batch.item.ItemWriter;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.impl.SwkbtLoaderServiceImpl;
import com.ibm.asset.trails.domain.ProductInfo;

/* This entire logic is being ignored for expediency to push the Sprint out my August 2012
 the user is expecting submitting a guid flips the licensable status which is what we changed
 to in the ProductInfoServiceImpl class.
*/
public class LicensableWriter implements ItemWriter<Map<String, Object>> {
	private static final Logger logger = Logger
			.getLogger(LicensableWriter.class);

	@Autowired
	private ProductInfoService service;

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void write(List<? extends Map<String, Object>> items)
			throws Exception {
		processIBMLicensableChanges(items);
	}

	private void processIBMLicensableChanges(
			List<? extends Map<String, Object>> items) {
		logger.debug("processing Licensable Changes");
		for (Map<String, Object> item : items) {
			Long id = (Long) item.get("id");
			int newLicensable = (Integer) item.get("newLicensable");
			ProductInfo pInfo = service.findById(id);
			if (newLicensable == 1 && pInfo.getLicensable() != true) {				
				pInfo.setLicensable(true);
				service.addToRecon(pInfo);
				service.merge(pInfo);
				logger.debug("Set as licensable " + pInfo.toString());
			} else if (!service.licensableOverrideExists(pInfo.getGuid()) && pInfo.getLicensable() != false) {
				pInfo.setLicensable(false);
				service.addToRecon(pInfo);
				service.merge(pInfo);
				logger.debug("Set as non-licensable " + pInfo.toString());
			}
		}
		logger.debug("process Licensable Changes complete");
	}

}

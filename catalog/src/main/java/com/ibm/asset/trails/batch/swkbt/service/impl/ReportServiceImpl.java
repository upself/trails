package com.ibm.asset.trails.batch.swkbt.service.impl;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.trails.batch.swkbt.service.ReportService;
import com.ibm.asset.trails.dao.InstalledFilterDao;
import com.ibm.asset.trails.dao.InstalledSignatureDao;

@Service
public class ReportServiceImpl implements ReportService {
	private static final Log LOG = LogFactory.getLog(ReportServiceImpl.class);

	@Autowired
	private InstalledSignatureDao signatureDao;

	@Autowired
	private InstalledFilterDao filterDao;

	public Long signatureHitCount(Long id) {
		return signatureDao.hitCount(id);
	}

	public Long filterHitCount(Long id) {
		return filterDao.hitCount(id);
	}

	public Boolean filterExists(String filterName, String softwareVersion) {
		LOG.debug("Looking for filterName: " + filterName
				+ ", softwareVersion: " + softwareVersion);
		return filterDao.filterExists(filterName, softwareVersion);
	}

	public Boolean signatureExists(String fileName, Integer fileSize) {
		return signatureDao.signatureExists(fileName, fileSize);
	}

}

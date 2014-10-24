package com.ibm.asset.trails.batch.swkbt.service;

public interface ReportService {

	Long signatureHitCount(Long id);

	Long filterHitCount(Long id);

	Boolean filterExists(String filterName, String softwareVersion);

	Boolean signatureExists(String fileName, Integer fileSize);
}

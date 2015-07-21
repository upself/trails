package com.ibm.asset.trails.batch.swkbt.service.impl;


import org.apache.log4j.Logger;


import java.io.UnsupportedEncodingException;
import java.lang.reflect.InvocationTargetException;
import java.util.Iterator;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.swkbt.schema.AliasType;
import com.ibm.asset.swkbt.schema.ApplicationServerSignatureType;
import com.ibm.asset.swkbt.schema.CVersionIdType;
import com.ibm.asset.swkbt.schema.DistributedProductType;
import com.ibm.asset.swkbt.schema.DistributedReleaseType;
import com.ibm.asset.swkbt.schema.DistributedVersionType;
import com.ibm.asset.swkbt.schema.FileSignatureType;
import com.ibm.asset.swkbt.schema.FileType;
import com.ibm.asset.swkbt.schema.FilterSignatureType;
import com.ibm.asset.swkbt.schema.InstallRegistrySignatureType;
import com.ibm.asset.swkbt.schema.J2EeApplicationSignatureType;
import com.ibm.asset.swkbt.schema.MainframeFeatureType;
import com.ibm.asset.swkbt.schema.MainframeProductType;
import com.ibm.asset.swkbt.schema.MainframeVersionType;
import com.ibm.asset.swkbt.schema.ManufacturerType;
import com.ibm.asset.swkbt.schema.OtherSignatureType;
import com.ibm.asset.swkbt.schema.PartNumberType;
import com.ibm.asset.swkbt.schema.PlatformType;
import com.ibm.asset.swkbt.schema.RegistrySignatureType;
import com.ibm.asset.swkbt.schema.RegistryType;
import com.ibm.asset.swkbt.schema.RelationshipType;
import com.ibm.asset.swkbt.schema.VariationType;
import com.ibm.asset.swkbt.schema.XslmIdSignatureType;
import com.ibm.asset.trails.batch.swkbt.service.AliasService;
import com.ibm.asset.trails.batch.swkbt.service.ApplicationServerSignatureService;
import com.ibm.asset.trails.batch.swkbt.service.CVersionIdService;
import com.ibm.asset.trails.batch.swkbt.service.FileService;
import com.ibm.asset.trails.batch.swkbt.service.FileSignatureService;
import com.ibm.asset.trails.batch.swkbt.service.FilterSignatureService;
import com.ibm.asset.trails.batch.swkbt.service.InstallRegistrySignatureService;
import com.ibm.asset.trails.batch.swkbt.service.J2eeApplicationSignatureService;
import com.ibm.asset.trails.batch.swkbt.service.MainframeFeatureService;
import com.ibm.asset.trails.batch.swkbt.service.MainframeProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.MainframeProductService;
import com.ibm.asset.trails.batch.swkbt.service.MainframeVersionService;
import com.ibm.asset.trails.batch.swkbt.service.ManufacturerService;
import com.ibm.asset.trails.batch.swkbt.service.OtherSignatureService;
import com.ibm.asset.trails.batch.swkbt.service.PartNumberService;
import com.ibm.asset.trails.batch.swkbt.service.PlatformService;
import com.ibm.asset.trails.batch.swkbt.service.ProductInfoService;
import com.ibm.asset.trails.batch.swkbt.service.RegistryService;
import com.ibm.asset.trails.batch.swkbt.service.RegistrySignatureService;
import com.ibm.asset.trails.batch.swkbt.service.RelationshipService;
import com.ibm.asset.trails.batch.swkbt.service.ReleaseService;
import com.ibm.asset.trails.batch.swkbt.service.SwkbtLoaderService;
import com.ibm.asset.trails.batch.swkbt.service.VariationService;
import com.ibm.asset.trails.batch.swkbt.service.VersionService;
import com.ibm.asset.trails.batch.swkbt.service.XslmIdSignatureService;
import com.ibm.asset.trails.domain.File;

@Service
public class SwkbtLoaderServiceImpl<E> implements SwkbtLoaderService<E> {
	private static final Logger logger = Logger
			.getLogger(SwkbtLoaderServiceImpl.class);

	@Value("${consoleMessages}")
	private String consoleMessages;
//	@Value("${writeDatabase}")
//	private String writeDatabase;
	public String writeDatabase = "true";

	@Autowired
	public AliasService aliasService;
	@Autowired
	public ApplicationServerSignatureService applicationServerSignatureService;
	@Autowired
	public CVersionIdService cVersionIdService;
	@Autowired
	public FileService fileService;
	@Autowired
	public FileSignatureService fileSignatureService;
	@Autowired
	public FilterSignatureService filterSignatureService;
	@Autowired
	public InstallRegistrySignatureService installRegistrySignatureService;
	@Autowired
	public J2eeApplicationSignatureService j2eeApplicationSignatureService;
	@Autowired
	public ManufacturerService manufacturerService;
	@Autowired
	public OtherSignatureService otherSignatureService;
	@Autowired
	public PartNumberService partNumberService;
	@Autowired
	public PlatformService platformService;
	@Autowired
	public ProductInfoService productInfoService;
	@Autowired
	public RegistryService registryService;
	@Autowired
	public RegistrySignatureService registrySignatureService;
	@Autowired
	public RelationshipService relationshipService;
	@Autowired
	public ReleaseService releaseService;
	@Autowired
	public VariationService variationService;
	@Autowired
	public VersionService versionService;
	@Autowired
	public XslmIdSignatureService xslmIdSignatureService;
	@Autowired
	public MainframeProductInfoService mainframeProductInfoService;
	@Autowired
	public MainframeFeatureService mainframeFeatureService;
	@Autowired
	public MainframeVersionService mainframeVersionService;

	@Transactional(readOnly = false, propagation = Propagation.REQUIRES_NEW)
	public void batchUpdate(List<? extends E> items, String source)
			throws IllegalArgumentException, SecurityException,
			IllegalAccessException, InvocationTargetException,
			NoSuchMethodException {
		logger.debug("Starting batchUpDate");
		for (E item : items) {
			getClass().getMethod("save", item.getClass()).invoke(this, item);
			logger.debug("Saved " + item.toString());
		//	System.out.print("here we come source "+source);
		}
		aliasService.flush();
	}

	public void save(AliasType xmlEntity) throws Exception {
		logger.debug("Saving Alias");
		if (writeDatabase.contentEquals("true")) {
			logger.debug("Saving Alias " + xmlEntity.getName());
			aliasService.save(xmlEntity);
		} else {
			logger.debug("Saving disabled");
		}
	}

	public void save(ApplicationServerSignatureType xmlEntity) {
		logger.debug("Saving Server Signature");
		if (writeDatabase.contentEquals("true")) {
			logger.debug("Saving Application Server Signature " + xmlEntity.getName());
			applicationServerSignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(CVersionIdType xmlEntity) throws Exception {
		logger.debug("Saving CVersionIdType");
		if (writeDatabase.contentEquals("true")) {
			logger.debug("Saving CVERSIONID " + xmlEntity.getCVersionId());
			cVersionIdService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(FileType xmlEntity) throws Exception {
		logger.debug("Saving FileType");
		if (writeDatabase.contentEquals("true") ) {
			logger.debug("Saving File Type " + xmlEntity.getName());
			fileService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(FileSignatureType xmlEntity) {
		logger.debug("Saving FileSignatureType");
	    List<FileType> fileTypes = xmlEntity.getFile();
		if (writeDatabase.contentEquals("true") && !xmlEntity.getFile().isEmpty()) {
			logger.debug("Saving File Signature Type ");
			fileSignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(FilterSignatureType xmlEntity) {
		logger.debug("Saving FilterSignatureType");
		if (writeDatabase.contentEquals("true") ) {
			logger.debug("Saving Filter Signature Type");
			filterSignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(InstallRegistrySignatureType xmlEntity) {
		logger.debug("Saving InstallRegistrySignatureType");
		if (writeDatabase.contentEquals("true")) {
			logger.debug("Saving Install Registry Signature Type ");
			installRegistrySignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(J2EeApplicationSignatureType xmlEntity) {
		logger.debug("Saving J2EeApplicationSignatureType");
		if (writeDatabase.contentEquals("true") ) {
			j2eeApplicationSignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(ManufacturerType xmlEntity) {
		logger.debug("Saving ManufacturerType");
		logger.info("Saving " + xmlEntity.toString());
		if (writeDatabase.contentEquals("true")) {
			manufacturerService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(OtherSignatureType xmlEntity) {
		logger.debug("Saving OtherSignatureType");
		if (writeDatabase.contentEquals("true")) {
			otherSignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(PartNumberType xmlEntity) {
		logger.debug("Saving PartNumberType");
		if (writeDatabase.contentEquals("true")) {
			partNumberService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(PlatformType xmlEntity) throws Exception {
		logger.debug("Saving PlatformType");
		logger.info("Saving " + xmlEntity.toString());
		if (writeDatabase.contentEquals("true")) {
			platformService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(DistributedProductType xmlEntity) {
		logger.debug("Saving DistributedProductType");
		logger.info("Saving " + xmlEntity.toString());
		if (xmlEntity.isDeleted().equals(null)){
			xmlEntity.setDeleted(false);
		}
		if (writeDatabase.contentEquals("true")) {
			productInfoService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(RegistryType xmlEntity) throws Exception {
		logger.debug("Saving RegistryType");
		if (writeDatabase.contentEquals("true")) {
			registryService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(RegistrySignatureType xmlEntity) {
		logger.debug("Saving RegistrySignatureType");
		if (writeDatabase.contentEquals("true")) {
			registrySignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(RelationshipType xmlEntity) {
		logger.debug("Saving RelationshipType");
		logger.info("Saving " + xmlEntity.toString());
		if (writeDatabase.contentEquals("true")) {
			relationshipService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(DistributedReleaseType xmlEntity) {
		logger.debug("Saving DistributedReleaseType");
		logger.info("Saving " + xmlEntity.toString());
		if (writeDatabase.contentEquals("true")) {

			releaseService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(VariationType xmlEntity) {
		logger.debug("Saving VariationType");
		if (writeDatabase.contentEquals("true")) {

			variationService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(DistributedVersionType xmlEntity) {
		logger.debug("Saving DistributedVersionType");
		if (writeDatabase.contentEquals("true")) {

			versionService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(XslmIdSignatureType xmlEntity) {
		logger.debug("Saving XslmIdSignatureType");
		if (writeDatabase.contentEquals("true")) {

			xslmIdSignatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(MainframeFeatureType xmlEntity) {
		logger.debug("Saving MainframeFeatureType");
		logger.info("Saving " + xmlEntity.toString());
		if (writeDatabase.contentEquals("true")) {

			mainframeFeatureService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(MainframeVersionType xmlEntity) {
		logger.debug("Saving MainframeVersionType");
		logger.info("Saving " + xmlEntity.toString());
		if (writeDatabase.contentEquals("true")) {

			mainframeVersionService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}

	public void save(MainframeProductType xmlEntity) {
		logger.debug("Saving MainframeProductType");
		logger.info("Saving " + xmlEntity.toString());
		if (writeDatabase.contentEquals("true")) {
            if (xmlEntity.isDeleted()== null){
            	xmlEntity.setDeleted(false);
            }
			mainframeProductInfoService.save(xmlEntity);
		}else {
			logger.debug("Saving disabled");
		}
	}
	
}

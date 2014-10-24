package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.ibm.asset.swkbt.schema.FileSignatureType;
import com.ibm.asset.trails.batch.swkbt.service.FileService;
import com.ibm.asset.trails.batch.swkbt.service.FileSignatureService;
import com.ibm.asset.trails.dao.FileSignatureDao;
import com.ibm.asset.trails.dao.SignatureDao;
import com.ibm.asset.trails.domain.File;
import com.ibm.asset.trails.domain.FileSignature;

@Service
public class FileSignatureServiceImpl extends
		SignatureServiceImpl<FileSignature, FileSignatureType, Long> implements
		FileSignatureService {

	@Autowired
	private FileSignatureDao dao;
	@Autowired
	private FileService fileService;

	public void save(FileSignatureType xmlEntity) {
		FileSignature existing = findByNaturalKey(xmlEntity.getGuid());
		if (existing == null) {
			existing = new FileSignature();
			save(existing, xmlEntity);
		} else {
			save(existing, xmlEntity);
		}
	}

	@Override
	public FileSignature update(FileSignature existing,
			FileSignatureType xmlEntity) {
		existing = super.update(existing, xmlEntity);
		existing.setOperator(xmlEntity.getOperator());
		Set<File> newFiles = fileService.findFromXmlSet(xmlEntity.getFile());
		existing.getFiles().retainAll(newFiles);
		existing.getFiles().addAll(newFiles);
		return existing;
	}

	@Override
	public SignatureDao<FileSignature, Long> getDao() {
		return dao;
	}

}

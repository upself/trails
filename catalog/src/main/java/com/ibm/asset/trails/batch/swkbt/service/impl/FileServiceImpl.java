package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.HashSet;
import java.util.List;
import java.util.Set;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.swkbt.schema.FileType;
import com.ibm.asset.trails.batch.swkbt.service.FileService;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.dao.FileDao;
import com.ibm.asset.trails.domain.File;

@Service
public class FileServiceImpl extends GenericService<File, FileType, Long>
		implements FileService {
	
	private static final Log LOG = LogFactory.getLog(ManufacturerServiceImpl.class);
	
	@Autowired
	private FileDao dao;

	@Override
	public File update(File existing, FileType xmlEntity) {
		existing.setName(xmlEntity.getName());
		existing.setSize(xmlEntity.getSize());
		return existing;
	}

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	public void save(FileType xmlEntity) {
		File existing = findByNaturalKey(xmlEntity.getName(),
				xmlEntity.getSize());
		if (existing == null) {
			existing = new File();
			existing = update(existing, xmlEntity);
			dao.persist(existing);
		}
	}

	@Override
	public BaseDao<File, Long> getDao() {
		return dao;
	}

	public Set<File> findFromXmlSet(List<FileType> fileTypes) {
		Set<File> files = new HashSet<File>();
		for (FileType fileType : fileTypes) {
			//LOG.debug("looking at name of file is " + fileType.getName());
			File file = findByNaturalKey(fileType.getName(), fileType.getSize());
			files.add(file);
		}
		return files;
	}

}

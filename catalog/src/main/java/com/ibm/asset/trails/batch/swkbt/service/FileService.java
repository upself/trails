package com.ibm.asset.trails.batch.swkbt.service;

import java.util.List;
import java.util.Set;

import com.ibm.asset.swkbt.schema.FileType;
import com.ibm.asset.trails.domain.File;

public interface FileService extends BaseService<File, FileType, Long> {

	Set<File> findFromXmlSet(List<FileType> fileTypes);

}

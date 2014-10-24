package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.MainframeVersionDao;
import com.ibm.asset.trails.domain.MainframeVersion;

@Repository
public class MainframeVersionDaoJpa extends
		SoftwareItemDaoJpa<MainframeVersion, Long> implements
		MainframeVersionDao {

}

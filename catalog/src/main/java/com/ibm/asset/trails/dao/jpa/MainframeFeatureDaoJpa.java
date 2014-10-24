package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.MainframeFeatureDao;
import com.ibm.asset.trails.domain.MainframeFeature;

@Repository
public class MainframeFeatureDaoJpa extends
		SoftwareItemDaoJpa<MainframeFeature, Long> implements
		MainframeFeatureDao {

}

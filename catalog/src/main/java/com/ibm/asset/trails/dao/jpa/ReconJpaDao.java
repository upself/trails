package com.ibm.asset.trails.dao.jpa;

import org.springframework.stereotype.Repository;

import com.ibm.asset.trails.dao.ReconDao;
import com.ibm.asset.trails.domain.Recon;

@Repository
public class ReconJpaDao extends DaoJpa<Recon, Long> implements ReconDao {

	public Recon findByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

	public Long findIdByNaturalKey(Object... key) {
		// unimplemented
		return null;
	}

}

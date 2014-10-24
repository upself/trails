package com.ibm.asset.trails.batch.swkbt.service.impl;

import java.util.HashSet;
import java.util.Set;

import org.apache.commons.lang.StringUtils;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

import com.ibm.asset.trails.batch.swkbt.service.PidService;
import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.dao.PidDao;
import com.ibm.asset.trails.domain.Pid;

@Service
public class PidServiceImpl implements PidService {

	private static final Log log = LogFactory.getLog(PidServiceImpl.class);
	@Autowired
	private PidDao dao;

	private Pid save(Pid pid) {
		if (pid.getId() == null) {
			pid = dao.merge(pid);
		}
		return pid;
	}

	protected Pid update(Pid existing, Pid xmlEntity) {
		return existing;
	}

	public synchronized Pid find(String key) {
		log.debug("Looking for: " + key);
		return dao.findByNaturalKey(key);
	}

	public synchronized Long findId(String key) {
		log.debug("Looking for: " + key);
		return dao.findIdByNaturalKey(key);
	}

	@Transactional(readOnly = false, propagation = Propagation.MANDATORY)
	public Set<Pid> findFromXmlSet(String productIds) {
		String[] pidArray = StringUtils.splitByWholeSeparator(productIds, null);
		Set<Pid> pids = new HashSet<Pid>();
		if (pidArray != null) {
			for (String string : pidArray) {
				Pid pid = find(string);
				if (pid == null) {
					pid = new Pid();
					pid.setPid(string);
					pid = save(pid);
				}
				pids.add(pid);
			}
		}
		return pids;
	}

	public BaseDao<Pid, Long> getDao() {
		return dao;
	}
}

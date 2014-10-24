package com.ibm.asset.trails.dao.jpa;

import java.io.Serializable;
import java.lang.reflect.ParameterizedType;

import javax.persistence.EntityManager;
import javax.persistence.FlushModeType;
import javax.persistence.PersistenceContext;

import com.ibm.asset.trails.dao.BaseDao;
import com.ibm.asset.trails.domain.DomainEntity;

public abstract class DaoJpa<E extends DomainEntity, I extends Serializable>
		implements BaseDao<E, I> {

	protected EntityManager entityManager;
	protected Class<E> entityClass;

	@SuppressWarnings("unchecked")
	public DaoJpa() {
		ParameterizedType genericSuperclass = (ParameterizedType) getClass()
				.getGenericSuperclass();
		this.entityClass = (Class<E>) genericSuperclass
				.getActualTypeArguments()[0];
	}

	public void persist(E entity) {
		getEntityManager().persist(entity);
	}

	public E merge(E entity) {
		return getEntityManager().merge(entity);
	}

	public void refresh(E entity) {
		getEntityManager().refresh(entity);
	}

	public E findById(I id) {
		return getEntityManager().find(entityClass, id);
	}

	public void flush() {
		getEntityManager().flush();
	}

	public Class<E> getEntityClass() {
		return entityClass;
	}

	@PersistenceContext
	public void setEntityManager(EntityManager entityManager) {
		entityManager.setFlushMode(FlushModeType.COMMIT);
		this.entityManager = entityManager;
	}

	public EntityManager getEntityManager() {
		return entityManager;
	}
}

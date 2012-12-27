package com.ibm.asset.trails.dao.jpa;

import java.io.Serializable;
import java.util.List;

import javax.persistence.Query;

import com.ibm.asset.trails.dao.BaseEntityDAO;
import com.ibm.asset.trails.domain.AbstractDomainEntity;

public abstract class AbstractGenericEntityDAOJpa<E extends AbstractDomainEntity, I extends Serializable>
		extends AbstractGenericDAOJpa<E> implements BaseEntityDAO<E, I> {

	public void persist(final E entity) {
		entityManager.persist(entity);
	}

	public void remove(final E entity) {
		entityManager.remove(entity);
	}

	public E merge(final E entity) {
		return entityManager.merge(entity);
	}

	public void refresh(final E entity) {
		entityManager.refresh(entity);
	}

	public E findById(final I entityId) {
		return entityManager.find(entityClass, entityId);
	}

	public E flush(final E entity) {
		entityManager.flush();
		return entity;
	}

	@SuppressWarnings(UNCHECKED)
	public List<E> findAll() {
		final Query query = entityManager.createQuery("SELECT h FROM "
				+ entityClass.getName() + " h");
		return query.getResultList();
	}

	public Integer removeAll() {
		final Query query = entityManager.createQuery("DELETE FROM "
				+ entityClass.getName() + " h");
		return query.executeUpdate();
	}

}

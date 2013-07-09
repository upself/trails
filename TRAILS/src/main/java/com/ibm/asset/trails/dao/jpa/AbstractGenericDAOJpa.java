package com.ibm.asset.trails.dao.jpa;

import java.lang.reflect.ParameterizedType;
import java.util.Collection;
import java.util.Iterator;
import java.util.StringTokenizer;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.hibernate.Criteria;
import org.hibernate.Session;
import org.hibernate.criterion.CriteriaSpecification;
import org.hibernate.criterion.Restrictions;
import org.hibernate.engine.SessionFactoryImplementor;
import org.hibernate.engine.SessionImplementor;
import org.hibernate.impl.CriteriaImpl;
import org.hibernate.loader.criteria.CriteriaQueryTranslator;

import com.ibm.asset.trails.dao.BaseDAO;

public abstract class AbstractGenericDAOJpa<E> implements BaseDAO<E> {
    protected static final String UNCHECKED = "unchecked";

    @PersistenceContext
    protected transient EntityManager entityManager;
    protected final transient Class<E> entityClass;

    @SuppressWarnings(UNCHECKED)
    public AbstractGenericDAOJpa() {
        super();
        final ParameterizedType genericSuperclass = (ParameterizedType) getClass()
                .getGenericSuperclass();
        this.entityClass = (Class<E>) genericSuperclass
                .getActualTypeArguments()[0];
    }

    protected Criteria getHibernateSessionCriteria() {
        final Session session = (Session) entityManager.getDelegate();
        return session.createCriteria(entityClass);
    }

    protected static String createAlias(Criteria criteria,
            String associationPath) {
        return createAlias(criteria, criteria, criteria.getAlias(),
                associationPath, CriteriaSpecification.INNER_JOIN);
    }

    protected static String createAlias(Criteria criteria,
            String associationPath, int joinType) {
        return createAlias(criteria, criteria, criteria.getAlias(),
                associationPath, joinType);
    }

    private static String createAlias(Criteria rootCriteria,
            Criteria currentSubCriteria, String alias, String associationPath,
            int joinType) {
        StringTokenizer st = new StringTokenizer(associationPath, ".");
        if (st.countTokens() == 1) {
            return alias + "." + associationPath;
        } else {
            String associationPathToken = st.nextToken();
            String newAlias = alias + "_" + associationPathToken;
            Criteria criteriaForAlias = findCriteriaForAlias(rootCriteria,
                    newAlias);
            if (criteriaForAlias == null) {
                currentSubCriteria = currentSubCriteria.createCriteria(
                        associationPathToken, newAlias, joinType);
            } else {
                currentSubCriteria = criteriaForAlias;
            }

            String newKey = associationPath
                    .substring(associationPathToken.length() + 1,
                            associationPath.length());
            return createAlias(rootCriteria, currentSubCriteria, newAlias,
                    newKey, joinType);
        }
    }

    protected static String getSqlAlias(Criteria criteria, String alias) {
        CriteriaImpl criteriaImpl = (CriteriaImpl) criteria;
        SessionImplementor session = ((CriteriaImpl) criteria).getSession();
        SessionFactoryImplementor factory = session.getFactory();
        String[] implementors = factory.getImplementors(criteriaImpl
                .getEntityOrClassName());

        CriteriaQueryTranslator translator = new CriteriaQueryTranslator(
                factory, (CriteriaImpl) criteria, implementors[0],
                CriteriaQueryTranslator.ROOT_SQL_ALIAS);

        String[] split = alias.split("\\.");
        String path = split[0];
        String propertyName = split[1];

        Criteria aliasCriteria = findCriteriaForAlias(criteria, path);

        return translator.getSQLAlias(aliasCriteria) + "." + propertyName;
    }

    protected static Criteria findCriteriaForAlias(Criteria criteria,
            String alias) {
        Iterator subcriterias = ((CriteriaImpl) criteria).iterateSubcriteria();
        while (subcriterias.hasNext()) {
            Criteria subcriteria = (Criteria) subcriterias.next();
            if (subcriteria.getAlias().equals(alias)) {
                return subcriteria;
            }
        }
        return null;
    }

    public static Criteria createCriteria(Session session,
            Class persistentClass, Filter filter) {
        String alias = persistentClass.getSimpleName().toLowerCase();
        Criteria criteria = session.createCriteria(persistentClass, alias);

        if (filter != null) {
            for (FilterCriteria filterCriteria : filter.getFilterCriterias()) {
                String restrictionPath = createAlias(criteria,
                        filterCriteria.getPath());
                if (filterCriteria.getValue() instanceof String) {
                    criteria.add(Restrictions.like(restrictionPath,
                            (String) filterCriteria.getValue(), filterCriteria
                                    .getMatcher().getMatchMode()));
                } else if (Collection.class.isAssignableFrom(filterCriteria
                        .getValue().getClass())) {
                    Collection coll = (Collection) filterCriteria.getValue();
                    criteria.add(Restrictions.in(restrictionPath, coll));
                } else if (Object[].class.isAssignableFrom(filterCriteria
                        .getValue().getClass())) {
                    Object[] coll = (Object[]) filterCriteria.getValue();
                    criteria.add(Restrictions.in(restrictionPath, coll));
                } else {
                    criteria.add(Restrictions.eq(restrictionPath,
                            filterCriteria.getValue()));
                }

            }
        }
        return criteria;
    }

}

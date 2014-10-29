package com.ibm.asset.trails.domain;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

import org.apache.commons.lang.builder.EqualsBuilder;
import org.apache.commons.lang.builder.HashCodeBuilder;

@Entity
@Table(name = "CAPACITY_TYPE")
@org.hibernate.annotations.Entity
@NamedQuery(name = "capacityTypeList", query = "FROM CapacityType ORDER BY code")
public class CapacityType extends AbstractDomainEntity {
    private static final long serialVersionUID = 8312872693905334805L;

    @Id
    @Column(name = "CODE")
    private Integer code;

    @Column(name = "DESCRIPTION")
    private String description;

    @Column(name = "RECORD_TIME")
    private Date recordTime;

    public Integer getCode() {
        return code;
    }

    public String getDescription() {
        return description;
    }

    public Date getRecordTime() {
        return recordTime;
    }

    public void setCode(Integer code) {
        this.code = code;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public void setRecordTime(Date recordTime) {
        this.recordTime = recordTime;
    }

    @Override
    public boolean equals(final Object other) {
        if (!(other instanceof CapacityType))
            return false;
        CapacityType castOther = (CapacityType) other;
        return new EqualsBuilder().append(code, castOther.code).isEquals();
    }

    @Override
    public int hashCode() {
        return new HashCodeBuilder().append(code).toHashCode();
    }
}

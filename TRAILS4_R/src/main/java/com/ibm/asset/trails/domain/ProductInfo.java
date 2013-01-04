package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;

@Entity(name = "ProductInfo")
@org.hibernate.annotations.Entity(mutable = false)
@Table(name = "PRODUCT_INFO")
@NamedQueries({
        @NamedQuery(name = "productInfoBySoftwareName", query = "FROM ProductInfo WHERE UCASE(name) = :name and deleted!=1 order by product_role desc"),
        @NamedQuery(name = "productInfoByAliasName", query = "FROM ProductInfo PI JOIN PI.alias AS A WITH UCASE(A.name) = :name and deleted!=1 order by product_role desc") })
public class ProductInfo extends Product implements Serializable {
    private static final long serialVersionUID = -8798102209513138193L;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "SOFTWARE_CATEGORY_ID")
    private SoftwareCategory softwareCategory;

    @Basic
    @Column(name = "PRIORITY")
    private Integer priority;

    @Basic
    @Column(name = "LICENSABLE")
    private Boolean licensable;

    public Boolean getLicensable() {
        return licensable;
    }

    public void setLicensable(Boolean licensable) {
        this.licensable = licensable;
    }

    public Integer getPriority() {
        return priority;
    }

    public void setPriority(Integer priority) {
        this.priority = priority;
    }

    public SoftwareCategory getSoftwareCategory() {
        return softwareCategory;
    }

    public void setSoftwareCategory(SoftwareCategory softwareCategory) {
        this.softwareCategory = softwareCategory;
    }
}

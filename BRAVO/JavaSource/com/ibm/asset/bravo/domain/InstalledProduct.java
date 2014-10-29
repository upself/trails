package com.ibm.asset.bravo.domain;

import java.io.Serializable;
import java.util.Date;

import com.ibm.ea.sigbank.Software;

public class InstalledProduct implements Serializable {

    private static final long serialVersionUID = -1990288811280198559L;
    private Long              id;
    private Software          product;
    private String            version;
    private Boolean           active;
    private String            comment;
    private String            remoteUser;
    private Date              creationTime;

    public Long getId() {
        return id;
    }

    public void setId(Long id) {
        this.id = id;
    }

    public Software getProduct() {
        return product;
    }

    public void setProduct(Software product) {
        this.product = product;
    }

    public String getVersion() {
        return version;
    }

    public void setVersion(String version) {
        this.version = version;
    }

    public Boolean getActive() {
        return active;
    }

    public void setActive(Boolean active) {
        this.active = active;
    }

    public String getComment() {
        return comment;
    }

    public void setComment(String comment) {
        this.comment = comment;
    }

    public String getRemoteUser() {
        return remoteUser;
    }

    public void setRemoteUser(String remoteUser) {
        this.remoteUser = remoteUser;
    }

    public Date getCreationTime() {
        return creationTime;
    }

    public void setCreationTime(Date creationTime) {
        this.creationTime = creationTime;
    }
}

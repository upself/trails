//
// This file was generated by the JavaTM Architecture for XML Binding(JAXB) Reference Implementation, v3.0-03/04/2009 09:20 AM(valikov)-fcs 
// See <a href="http://java.sun.com/xml/jaxb">http://java.sun.com/xml/jaxb</a> 
// Any modifications to this file will be lost upon recompilation of the source schema. 
// Generated on: 2010.01.15 at 05:31:23 PM EST 
//

package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity(name = "Pid")
@org.hibernate.annotations.Entity(mutable = false)
@Table(name = "PID")
public class Pid implements Serializable {

	private static final long serialVersionUID = -8082450454463732453L;

	@Id
	@Column(name = "ID")
	private Long id;

	@Basic
	@Column(name = "PID", length = 16)
	private String pid;

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public String getPid() {
		return pid;
	}

	public void setPid(String pid) {
		this.pid = pid;
	}

}

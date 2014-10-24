package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "J2EE_APPLICATION_SIGNATURE")
public class J2EeApplicationSignature extends Signature {

	private static final long serialVersionUID = 2814885279344422157L;

	@Basic
	@Column(name = "NAME")
	protected String name;

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((name == null) ? 0 : name.hashCode());
		return result;
	}

	@Override
	public boolean equals(Object obj) {
		if (this == obj) {
			return true;
		}
		if (!super.equals(obj)) {
			return false;
		}
		if (!(obj instanceof J2EeApplicationSignature)) {
			return false;
		}
		J2EeApplicationSignature other = (J2EeApplicationSignature) obj;
		if (name == null) {
			if (other.name != null) {
				return false;
			}
		} else if (!name.equals(other.name)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("J2EeApplicationSignature [name=");
		builder.append(name);
		builder.append("]");
		return builder.toString();
	}

}

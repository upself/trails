package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "APPLICATION_SERVER_SIGNATURE")
public class ApplicationServerSignature extends Signature {

	private static final long serialVersionUID = 1317543999898195583L;

	@Basic
	@Column(name = "NAME")
	protected String name;

	public String getName() {
		return name;
	}

	public void setName(String value) {
		this.name = value;
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
		if (!(obj instanceof ApplicationServerSignature)) {
			return false;
		}
		ApplicationServerSignature other = (ApplicationServerSignature) obj;
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
		builder.append("ApplicationServerSignature [name=");
		builder.append(name);
		builder.append("]");
		return builder.toString();
	}

}

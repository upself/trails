package com.ibm.asset.trails.domain;

import java.util.HashSet;
import java.util.Set;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.EnumType;
import javax.persistence.Enumerated;
import javax.persistence.FetchType;
import javax.persistence.JoinColumn;
import javax.persistence.JoinTable;
import javax.persistence.OneToMany;
import javax.persistence.Table;

import com.ibm.asset.swkbt.schema.SignatureOperatorType;

@Entity
@Table(name = "REGISTRY_SIGNATURE")
public class RegistrySignature extends Signature {

	private static final long serialVersionUID = -7950551995158248457L;

	@OneToMany(targetEntity = Registry.class, cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinTable(name = "REGISTRY_SIGNATURE_REGISTRY", joinColumns = { @JoinColumn(name = "REGISTRY_SIGNATURE_ID") }, inverseJoinColumns = { @JoinColumn(name = "REGISTRY_ID") })
	protected Set<Registry> registry = new HashSet<Registry>();

	@Basic
	@Column(name = "OPERATOR")
	@Enumerated(EnumType.STRING)
	protected SignatureOperatorType operator;

	public Set<Registry> getRegistry() {
		if (registry == null) {
			registry = new HashSet<Registry>();
		}
		return registry;
	}

	public void setRegistry(Set<Registry> registry) {
		this.registry = registry;
	}

	public SignatureOperatorType getOperator() {
		return operator;
	}

	public void setOperator(SignatureOperatorType operator) {
		this.operator = operator;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((operator == null) ? 0 : operator.hashCode());
		result = prime * result
				+ ((registry == null) ? 0 : registry.hashCode());
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
		if (!(obj instanceof RegistrySignature)) {
			return false;
		}
		RegistrySignature other = (RegistrySignature) obj;
		if (operator != other.operator) {
			return false;
		}
		if (registry == null) {
			if (other.registry != null) {
				return false;
			}
		} else if (!registry.equals(other.registry)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("RegistrySignature [registry=");
		builder.append(registry);
		builder.append(", operator=");
		builder.append(operator);
		builder.append("]");
		return builder.toString();
	}

}

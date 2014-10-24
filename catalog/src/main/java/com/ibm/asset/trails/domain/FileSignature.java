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
@Table(name = "FILE_SIGNATURE")
public class FileSignature extends Signature {

	private static final long serialVersionUID = -3556648585304385144L;

	@OneToMany(cascade = { CascadeType.ALL }, fetch = FetchType.EAGER)
	@JoinTable(name = "FILE_SIGNATURE_FILE", joinColumns = { @JoinColumn(name = "FILE_SIGNATURE_ID") }, inverseJoinColumns = { @JoinColumn(name = "FILE_ID") })
	protected Set<File> files = new HashSet<File>();

	@Basic
	@Column(name = "OPERATOR")
	@Enumerated(EnumType.STRING)
	protected SignatureOperatorType operator;

	@Basic
	@Column(name = "SCOPE")
	@Enumerated(EnumType.STRING)
	protected FileSignatureScopeEnum scope;

	public Set<File> getFiles() {
		if (files == null) {
			files = new HashSet<File>();
		}
		return files;
	}

	public void setFiles(Set<File> files) {
		this.files = files;
	}

	public SignatureOperatorType getOperator() {
		return operator;
	}

	public void setOperator(SignatureOperatorType operator) {
		this.operator = operator;
	}

	public FileSignatureScopeEnum getScope() {
		return scope;
	}

	public void setScope(FileSignatureScopeEnum scope) {
		this.scope = scope;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result + ((files == null) ? 0 : files.hashCode());
		result = prime * result
				+ ((operator == null) ? 0 : operator.hashCode());
		result = prime * result + ((scope == null) ? 0 : scope.hashCode());
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
		if (!(obj instanceof FileSignature)) {
			return false;
		}
		FileSignature other = (FileSignature) obj;
		if (files == null) {
			if (other.files != null) {
				return false;
			}
		} else if (!files.equals(other.files)) {
			return false;
		}
		if (operator != other.operator) {
			return false;
		}
		if (scope != other.scope) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("FileSignature [files=");
		builder.append(files);
		builder.append(", operator=");
		builder.append(operator);
		builder.append(", scope=");
		builder.append(scope);
		builder.append("]");
		return builder.toString();
	}

}

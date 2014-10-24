package com.ibm.asset.trails.domain;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Table;

@Entity
@Table(name = "FILTER_SIGNATURE")
public class FilterSignature extends Signature {

	private static final long serialVersionUID = -748060920072595826L;

	@Basic
	@Column(name = "PACKAGE_NAME")
	protected String packageName;

	@Basic
	@Column(name = "PACKAGE_VENDOR")
	protected String packageVendor;

	@Basic
	@Column(name = "PACKAGE_VERSION")
	protected String packageVersion;

	public String getPackageName() {
		return packageName;
	}

	public void setPackageName(String packageName) {
		this.packageName = packageName;
	}

	public String getPackageVendor() {
		return packageVendor;
	}

	public void setPackageVendor(String packageVendor) {
		this.packageVendor = packageVendor;
	}

	public String getPackageVersion() {
		return packageVersion;
	}

	public void setPackageVersion(String packageVersion) {
		this.packageVersion = packageVersion;
	}

	@Override
	public int hashCode() {
		final int prime = 31;
		int result = super.hashCode();
		result = prime * result
				+ ((packageName == null) ? 0 : packageName.hashCode());
		result = prime * result
				+ ((packageVendor == null) ? 0 : packageVendor.hashCode());
		result = prime * result
				+ ((packageVersion == null) ? 0 : packageVersion.hashCode());
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
		if (!(obj instanceof FilterSignature)) {
			return false;
		}
		FilterSignature other = (FilterSignature) obj;
		if (packageName == null) {
			if (other.packageName != null) {
				return false;
			}
		} else if (!packageName.equals(other.packageName)) {
			return false;
		}
		if (packageVendor == null) {
			if (other.packageVendor != null) {
				return false;
			}
		} else if (!packageVendor.equals(other.packageVendor)) {
			return false;
		}
		if (packageVersion == null) {
			if (other.packageVersion != null) {
				return false;
			}
		} else if (!packageVersion.equals(other.packageVersion)) {
			return false;
		}
		return super.equals(obj);
	}

	@Override
	public String toString() {
		StringBuilder builder = new StringBuilder();
		builder.append("FilterSignature [packageName=");
		builder.append(packageName);
		builder.append(", packageVendor=");
		builder.append(packageVendor);
		builder.append(", packageVersion=");
		builder.append(packageVersion);
		builder.append("]");
		return builder.toString();
	}

}

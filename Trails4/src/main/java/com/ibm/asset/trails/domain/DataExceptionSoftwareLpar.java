package com.ibm.asset.trails.domain;

import java.io.Serializable;

import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;


@Entity(name = "AlertSoftwareLparNew")
@Table(name = "ALERT_SOFTWARE_LPAR")
@NamedQueries( { @NamedQuery(name = "getSwlparAlertsByaccountIdRemoteUser", query = "FROM DataException a WHERE a.open=1 AND a.account.id=:customerId AND a.remoteUser=:remoteUser ") })
public class DataExceptionSoftwareLpar extends DataException implements Serializable {

	/**
     * 
     */
	private static final long serialVersionUID = 1L;

	@ManyToOne
	@JoinColumn(name = "SOFTWARE_LPAR_ID")
	protected SoftwareLpar softwareLpar;

	/**
	 * @return the softwareLpar
	 */
	public SoftwareLpar getSoftwareLpar() {
		return softwareLpar;
	}

	/**
	 * @param softwareLpar
	 *            the softwareLpar to set
	 */
	public void setSoftwareLpar(SoftwareLpar softwareLpar) {
		this.softwareLpar = softwareLpar;
	}

}

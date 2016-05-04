package com.ibm.asset.trails.domain;

import java.util.Date;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "SCARLET_RECONCILE")
public class ScarletReconcile extends AbstractDomainEntity {
	private static final long serialVersionUID = -1570160658765275811L;

	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	@Column(name = "ID")
	private Long id;

	@Column(name = "LAST_VALIDATE_TIME")
	private Date lastValidateTime;
	
	@Column(name = "RECONCILE_MD5_HEX")
	private String reconcileMd5Hex;

	
	public ScarletReconcile() {
		
	}

	public ScarletReconcile(Long id, Date lastValidateTime) {
		this.id = id;
		this.lastValidateTime = lastValidateTime;
	}

	public ScarletReconcile(Long id, Date lastValidateTime,
			String reconcileMd5Hex) {
		this.id = id;
		this.lastValidateTime = lastValidateTime;
		this.reconcileMd5Hex = reconcileMd5Hex;
	}

	public Long getId() {
		return id;
	}

	public void setId(Long id) {
		this.id = id;
	}

	public Date getLastValidateTime() {
		return lastValidateTime;
	}

	public void setLastValidateTime(Date lastValidateTime) {
		this.lastValidateTime = lastValidateTime;
	}

	public String getReconcileMd5Hex() {
		return reconcileMd5Hex;
	}

	public void setReconcileMd5Hex(String reconcileMd5Hex) {
		this.reconcileMd5Hex = reconcileMd5Hex;
	}

	
	@Override
	public boolean equals(Object obj) {
		// TODO Auto-generated method stub
		if(null == obj){
			return false;
		} else if(this == obj){
			return true;
		} else if(obj instanceof ScarletReconcile){
			ScarletReconcile other = (ScarletReconcile)obj;
			if(null != this.getId() && null != other.getId() && this.getId().equals(other.getId())){
				return true;
			}else{
				return false;
			}
		} else{
			return false;
		}
	}

	@Override
	public int hashCode() {
	
		return 17 * 37 + (null == id ? 0 : id.hashCode());
	}
}

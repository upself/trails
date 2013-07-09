package com.ibm.asset.trails.domain;

import java.util.Date;

public interface Alert {

	public String getComments();

	public void setComments(String comments);

	public Date getCreationTime();

	public void setCreationTime(Date creationTime);

	public Long getId();

	public void setId(Long id);

	public boolean isOpen();

	public void setOpen(boolean open);

	public Date getRecordTime();

	public void setRecordTime(Date recordTime);

	public String getRemoteUser();

	public void setRemoteUser(String remoteUser);
}

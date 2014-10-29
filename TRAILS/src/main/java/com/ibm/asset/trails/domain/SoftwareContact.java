package com.ibm.asset.trails.domain;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name = "CONTACT")
public class SoftwareContact {

	@Id
	@Column(name = "CONTACT_ID")
	private Long id;

	@Column(name = "FULL_NAME")
	private String name;

	@Column(name = "REMOTE_USER")
	private String email;

	@Column(name = "NOTES_MAIL")
	private String notesMail;

	@Column(name = "SERIAL")
	private String serial;

	public String getEmail() {
		return email;
	}

	public Long getId() {
		return id;
	}

	public String getName() {
		return name;
	}

	public String getNotesMail() {
		return notesMail;
	}

	public String getSerial() {
		return serial;
	}
}

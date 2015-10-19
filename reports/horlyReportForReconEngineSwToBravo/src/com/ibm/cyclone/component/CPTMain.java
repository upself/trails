package com.ibm.cyclone.component;

import java.io.StringWriter;

import org.apache.velocity.Template;
import org.apache.velocity.VelocityContext;
import org.apache.velocity.app.Velocity;
import org.apache.velocity.exception.ParseErrorException;
import org.apache.velocity.exception.ResourceNotFoundException;

public class CPTMain {

	private String name;
	private static final String TEMPLATE = "vms/cpt_main.vm";

	public void setName(String name) {
		this.name = name;
	}

	public String execute() throws ResourceNotFoundException,
			ParseErrorException, Exception {
		VelocityContext context = new VelocityContext();
		context.put("name", this.name);
		Template template = Velocity.getTemplate(TEMPLATE);
		StringWriter writer = new StringWriter();
		template.merge(context, writer);
		return writer.toString();
	}

}

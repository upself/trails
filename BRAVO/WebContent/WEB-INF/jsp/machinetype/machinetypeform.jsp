<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>View/Edit Machine Type Reference</title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
	<h1 class="access">Start of main content</h1>
	<div id="content-head">
		<p id="breadcrumbs"></p>
	</div>
	<div id="content-main">
<!-- START CONTENT HERE -->

		<h1>Edit Existing Machine Type Record</h1>
		<p class="confidential">IBM Confidential</p>
		<br/>

		<html:form action="/admin/machinetype/update">
		<html:hidden property="id" value="${machineType.id}"/>
		<table border="0" width="80%" cellspacing="10" cellpadding="0">
			<tbody>
				<tr>
					<td nowrap="nowrap" >
						<div class="invalid"><html:errors property="update"/></div>
					</td>
				</tr>
				<tr>
					<th nowrap="nowrap">Name:</th>
					<td nowrap="nowrap">
						<html:text property="name" styleClass="input" value="${machineType.name}" disabled="${machineType.locked}"/>
					</td>
				</tr>
				<tr>
					<th>Definition:</th>
					<td nowrap="nowrap" >
						<html:textarea property="definition" rows="4" cols="60" styleClass="input" value="${machineType.definition}"/>
					</td>
				</tr>
				<tr>
					<th>Type:</th>
					<td nowrap="nowrap" >
						<html:select property="type">
  							<html:options name="machineTypeListType"/>
 						</html:select>
					</td>
				</tr>
				<tr>
					<th>Status:</th>
					<td nowrap="nowrap" >
						<html:text property="status" styleClass="input" value="${machineType.status}"/>
                    </td>
				</tr>
				<tr>
					<td nowrap="nowrap" >
						<span class="button-blue">
							<html:submit property="action" value="Update"/>
							<html:cancel property="cancel" value="Cancel"/>		
						</span>
					</td>
				</tr>
			</tbody>
		</table>

        <display:table name="list" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
			<display:setProperty name="basic.empty.showtable" value="true"/>
		
			<display:column title="Type" sortable="false"/>
		</display:table>

		</html:form>
		<br/>
		<br/>
		<br/>


				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
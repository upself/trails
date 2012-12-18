<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title><c:out value="${machineType.action}"/> Machine Type: <c:out value="${machineType.id}"/> - <c:out value="${machineType.name}"/></title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->

	<div id="content-head">
		<p id="date-stamp">New as of 26 June 2006</p>
		<div class="hrule-dots"></div>
		<p id="breadcrumbs">
			<html:link page="/">
				BRAVO
			</html:link>
			&gt;
			<html:link page="/admin/home.do">
				Administration
			</html:link>
			&gt;
			<html:link page="/admin/machinetype/home.do">
				Machine Type
			</html:link>
			&gt;
			<html:link page="/admin/machinetype/quicksearch.do?search=${search}&searchtype=${searchtype}&action=List">
				Search Results
			</html:link>
			&gt;
			<b>Working with Machine Type</b>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1><c:out value="${machineType.action}"/> Machine Type: <font color="#FFD700"><c:out value="${machineType.name}"/></font></h1>
	<p class="confidential">IBM Confidential</p>
	<br/>

	<html:form action="/admin/machinetype/edit">
	<html:hidden property="search"/>
    <html:hidden property="searchtype"/>
	<html:hidden property="context"/>
	<html:hidden property="id"/>
	<table border="0" width="80%" cellspacing="10" cellpadding="0">
	<tbody>
		<tr>
			<td nowrap="nowrap"><label for="name">Name</label></td>
			<td><html:text property="name" styleClass="inputlong" readonly="${machineType.readOnly['name']}"/></td>
			<td class="error"><html:errors property="name"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap"><label for="status">Status</label></td>
			<td>
			     <html:select property="status" styleClass="inputlong" disabled="${machineType.readOnly['status']}">
			      <html:optionsCollection property="statusList"/>
			     </html:select>
			</td>
			<td class="error"><html:errors property="status"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap"><label for="definition">Definition</label></td>
			<td><html:textarea rows="3" cols="60" property="definition" styleClass="inputlong" readonly="${machineType.readOnly['definition']}"/></td>
			<td class="error"><html:errors property="definition"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap"><label for="type">Type</label></td>
			<td>
			     <html:select property="type" styleClass="inputlong" disabled="${machineType.readOnly['type']}">
			      <html:optionsCollection property="typeList"/>
			     </html:select>
			</td>
			<td class="error"><html:errors property="type"/></td>
		</tr>
		<tr>
			<td></td>
			<td nowrap="nowrap">
				<span class="button-blue">
					<html:submit property="action" value="${machineType.action}"/>
					<html:submit property="action" value="Cancel"/>
				</span>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<font color="RED"><html:errors property="db"/></font>
			</td>
		</tr>
	</tbody>
	</table>
	</html:form>
				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="bean"		uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="logic"		uri="http://struts.apache.org/tags-logic" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Welcome to BRAVO</title>
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

		<h1>Account:<c:out value="${accountId}"/> CPU:<c:out value="${scan.cpuName}"/> LPAR:<c:out value="${scan.lparName}"/></h1>
 		<p class="confidential">IBM Confidential</p>

<c:set var="checkAll">
	<input type="checkbox" name="allbox" onclick="checkAll(this.form)"
		style="margin: 0 0 0 4px" />
</c:set>
	<html:form action="/upload/loadScanSubmit" >
	<html:hidden property="scanType" value="${scan.scanType}"/>
	<html:hidden property="parsePreview" value = "checked"/>
	<html:hidden property="accountId" value="${accountId}" />
	<html:hidden property="fileName" value="${scan.fileName}" />
	<html:hidden property="cpuName" value="${scan.cpuName}" />
	<html:hidden property="lparName" value="${scan.lparName}" />
<input type="checkbox" name="submitInternal" checked="checked"/>Submit internal CPU and LPAR information of this file<br>
		<h2>Select Addtional LPARS to apply to the same file</h2>

<display:table name="hardwareLpars" requestURI="" class="bravo" id="tall" >

	<display:setProperty name="basic.empty.showtable" value="true" />
		<display:setProperty name="basic.msg.empty_list_row"
			value='<tr class="empty" align="center"><td colspan="{0}">No hardware Records</td></tr>' />

<display:column title="${checkAll}" headerClass="blue-med">
	<html:multibox property="selected" style="margin: 0 0 0 4px" > 
	<c:out value="${tall.id}" /> 
	</html:multibox>
</display:column>
	<display:column sortProperty="name" title="Name" sortable="true" headerClass="blue-med" value="${tall.name}" />

	<display:column property="hardware.serial" title="Serial" sortable="true" headerClass="blue-med" />

</display:table>
<c:if
	test="${scan.cpuName == 'BAD'}">
Invalid file. Please review scan creation instructions.
</c:if>

<c:if
	test="${scan.cpuName != 'BAD'}">
<span class="button-blue">
	<html:submit property="action" value="Submit File"/>
</span>

</c:if>

</html:form>

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
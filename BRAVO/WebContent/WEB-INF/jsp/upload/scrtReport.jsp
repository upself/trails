<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean"	uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Upload SCRT Report: <c:out value="${account.customer.customerName}"/></title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>

<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->

	<h1 class="access">Start of main content</h1>
	<!-- start content head -->

	<div id="content-head">
		<p id="date-stamp">New as of 16 December 2006</p>
		<div class="hrule-dots"></div>
		<p id="breadcrumbs">
			<html:link page="/">
				BRAVO
			</html:link>
			&gt;
			<html:link page="/account/view.do?accountId=${account.customer.accountNumber}">
				<c:out value="${account.customer.customerName}"/>
			</html:link>
			&gt;
			<html:link page="/upload/scrtReport.do?id=${account.customer.accountNumber}">
				Upload SCRT Report
			</html:link>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<!-- start partial-sidebar -->
	<!-- stop partial-sidebar -->

	<h1>Upload SCRT Report: <font class="green-dark"><c:out value="${account.customer.customerName}"/></font></h1>
	<p class="confidential">IBM Confidential</p>
	<br/><br/>
	
	<html:form action="/upload/upload" enctype="multipart/form-data">
	<html:hidden property="uploadType" value="scrtReport"/>
	<html:hidden property="accountId" value="${account.customer.accountNumber}"/>
	<html:hidden property="hardwareSoftwareId" value="${account.customer.accountNumber}"/>
	
	<table border="0" width="80%" cellspacing="10" cellpadding="0">
	<tbody>
		<tr>
			<td nowrap="nowrap" width="1%">Filename:</td>
			<td><html:file property="file" size="60"/></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td class="error"><html:errors property="error"/></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td nowrap="nowrap">
				<span class="button-blue">
					<html:submit property="action" value="Upload File"/>
				</span>
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


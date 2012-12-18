<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="req"     uri="http://jakarta.apache.org/taglibs/request-1.0" %>

<html lang="en">
<head>
	<title>BRAVO Hardware</title>
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

		<h1>Hardware Error: <font color="RED"><c:out value="${account.customer.accountNumber}"/></font></h1>
		<br/>
		<h2><font color="RED"><c:out value="${account.customer.customerName}"/></font></h2>
		<br/>
		<div class="invalid"><html:errors property="results"/></div>
		<br/>
		<br/>
		<html:form action="/hardware/search">
		<html:hidden property="id" value="${account.customer.accountNumber}"/>
		<table border="0" width="80%" cellspacing="10" cellpadding="0">
			<tbody>
				<tr align="center">
					<td nowrap="nowrap" >
						<div class="invalid"><html:errors property="search"/></div>
					</td>
				</tr>
				<tr align="center">
					<td nowrap="nowrap" >
						<html:text property="search" styleClass="input"/>
					</td>
				</tr>
				<tr align="center">
					<td nowrap="nowrap" >
						<span class="button-blue"><html:submit property="type" value="Hostname"/></span>
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
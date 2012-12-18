<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean"	uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Account: <c:out value="${account.customer.customerName}"/></title>
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
		<p id="date-stamp">New as of 26 June 2006</p>
		<div class="hrule-dots"></div>
		<p id="breadcrumbs">
			<html:link page="/">
				BRAVO
			</html:link>
			&gt;
			<html:link page="/account/view.do?accountId=${account.customer.accountNumber}">
				<c:out value="${account.customer.customerName}"/>
			</html:link>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<!-- start partial-sidebar -->
	<div id="partial-sidebar">
		<h2 class="access">Start of sidebar content</h2>

		<div class="action">
			<h2 class="bar-gray-med-dark">
				Actions
				<html:link page="/help/help.do#H9"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
			</h2>
			<p>
				<!-- Create Hardware Discrepancy -->
				<img alt="" src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13" height="13"/>
				<html:link page="/hardware/create.do?accountId=${account.customer.accountNumber}">Create Hardware Discrepancy</html:link><br/>
		
				<!-- Edit Account Contacts -->
				<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13" height="13"/>
				<html:link page="/contact/view.do?accountId=${account.customer.accountNumber}">Edit Account Contacts</html:link><br/>
			</p>
		</div><br/>
		
		<div class="callout" id="contacts">
			<h2 class="bar-gray-med-dark">Account Contacts</h2>
			<p>
				<a href="#">Bryson, Don</a><br/>
				<a href="#">Creeley, Scott</a><br/>
				<a href="#">Dengler, Sam</a><br/>
				<a href="#">Moise, Alex</a><br/>
			</p>
		</div><br/>

	</div>
	<!-- stop partial-sidebar -->

	<h1>Account Detail: <font class="green-dark"><c:out value="${account.customer.customerName}"/></font></h1>
	<br/>
	
	<tmp:insert template="/WEB-INF/jsp/account/banner.jsp"/>
	
	statistical info, graphs, etc go here
	<br/>
	<br/>
	<html:form action="/hardware/search">
	<html:hidden property="id" value="${account.customer.accountNumber}"/>
	<table border="0" width="65%" cellspacing="10" cellpadding="0">
		<tbody>
			<tr align="center">	
				<td nowrap="nowrap" >
					<div class="invalid"><html:errors property="results"/></div>
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
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>
<%@ taglib prefix="logic"		uri="http://struts.apache.org/tags-logic" %>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Bravo Account: <c:out
	value="${account.customer.customerName}" /></title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>

<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content"><!-- START CONTENT HERE -->

<h1 class="access">Start of main content</h1>
<!-- start content head -->

<div id="content-head">
<p id="date-stamp">New as of 21 January 2009</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/">
				BRAVO
			</html:link> &gt; <html:link
	page="/account/view.do?accountId=${account.customer.accountNumber}">
	<c:out value="${account.customer.customerName}" />
</html:link> &gt; SWASSET Data</p>
</div>
<!-- start main content -->
<div id="content-main">

<h1>SWASSET Data: <font class="green-dark"><c:out
	value="${account.customer.customerName}" /></font></h1>
<p class="confidential">IBM Confidential</p>

<div class="invalid"><html:errors property="status" /></div>

<tmp:insert template="/WEB-INF/jsp/account/banner.jsp" /> 
<html:form
	action="/swasset/search">
	<html:hidden property="context" value="swasset" />
	<html:hidden property="accountId"
		value="${account.customer.accountNumber}" />
	<table border="0" width="65%" cellspacing="10" cellpadding="0">
		<thead>
			<tr>
				<th>SW LPAR Name Search: <html:link page="/help/help.do#H5">
					<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
						width="14" height="14" alt="contextual field help icon" />
				</html:link></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><html:text property="search" styleClass="inputlong" /> <span
					class="button-blue"><html:submit property="type"
					value="Search" /></span></td>
			</tr>
			<tr>
				<td>
				<div class="invalid"><html:errors property="search" /></div>
				</td>
			</tr>
		</tbody>
	</table>
</html:form> 
<c:set var="checkAll">
	<input type="checkbox" name="allBox"
		onclick="checkAll(this.form, 'allBox', 'selected')"
		style="margin: 0 0 0 4px" />
</c:set> 
<html:form action="/swasset/delete">
	<html:hidden property="accountId"
		value="${account.customer.accountNumber}" />
	<html:hidden property="context" value="swasset" />
	<html:hidden property="search" value="${search}" />
	<table class="tableHeader" id="small">
		<tr>
			<th>LPAR List <html:link page="/help/help.do#H6">
				<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
					width="14" height="14" alt="contextual field help icon" />
			</html:link></th>
		</tr>
	</table>
	<display:table name="lpars" requestURI="" class="bravo" id="tall"
		defaultsort="1" defaultorder="ascending">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:column title="${checkAll}" headerClass="blue-med">
			<c:if test="${tall.STATUS == 'In process'}">
				<html:multibox property="selected" style="margin: 0 0 0 4px"
					disabled="true">
					<c:out value="${tall.ID},${tall.NAME},${tall.TYPE}" />
				</html:multibox>
			</c:if>
			<c:if test="${tall.STATUS != 'In process'}">
				<html:multibox property="selected" style="margin: 0 0 0 4px"
					disabled="false">
					<c:out value="${tall.ID},${tall.NAME},${tall.TYPE}" />
				</html:multibox>
			</c:if>

		</display:column>
		<display:column property="NAME" title="SW LPAR Name" sortable="true"
			headerClass="blue-med" />
		<display:column property="STATUS" title="Status" sortable="true"
			headerClass="blue-med" />
		<display:column property="TYPE" title="TYPE" sortable="true"
			headerClass="blue-med" />
	</display:table>
	<div class="indent"><span class="button-blue"> <input
		type="submit" name="action" value="Delete"
		onclick="javascript:return confirm('Are you sure you want to delete these software lpars?')" />
	</span></div>
</html:form></div>
<!-- END CONTENT HERE --></div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

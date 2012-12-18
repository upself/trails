<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Bravo Hardware: <c:out value="${hardware.lparName}" /></title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content"><!-- START CONTENT HERE -->

<div id="content-head">
<p id="date-stamp">New as of 27 June 2006</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/">
				BRAVO
			</html:link> &gt; <html:link
	page="/account/view.do?accountId=${account.customer.accountNumber}">
	<c:out value="${account.customer.customerName}" />
</html:link> &gt; <html:link
	page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}&hwId=${hardware.id}">
	<c:out value="${hardware.lparName}" />
</html:link> &gt; <html:link page="/hardware/home.do?lparId=${hardware.id}">
				Hardware
			</html:link></p>
</div>

<!-- start main content -->
<div id="content-main"><!-- start partial-sidebar -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="action">
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h2>

<%
/*
%> <!-- Edit Hardware Contacts --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
	height="13" /> <!--				<html:link page="/contact/hardware/update.do?lparId=${hardware.id}">Edit HW Contacts</html:link><br/>-->
<a href="#">Edit HW Contacts</a><br />
<%
*/
%> <!-- Edit LPAR Contacts --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
	height="13" /> <html:link
	page="/contact/update.do?accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}&context=LPAR&id=${hardware.id}&lparId=${hardware.id}&customerid=${account.customer.customerId}">Update LPAR Contacts</html:link><br />

<!-- Edit Hardware Contacts --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
	height="13" /> <html:link
	page="/contact/update.do?accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}&context=HDW&id=${hardware.id}&lparId=${hardware.id}&customerid=${account.customer.customerId}">Update Hardware Contacts</html:link><br />

<%
/*
%> <!-- Upload VM Software --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14"
	height="12" /> <html:link page="/upload/vm.do?id=${hardware.id}">Upload VM Software</html:link><br />
<%
*/
%>
<p/>
</div>
<br />

<div class="callout" id="contacts">
<h2 class="bar-gray-med-dark">Hardware Contacts</h2>
<p><c:forEach items="${contactHwList}" var="contact">
	<html:link
		page="/contact/view.do?context=HDW&accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}&customerid=${account.customer.customerId}&id=${contact.contact.id}">
		<c:out value="${contact.contact.name}" />
	</html:link>
	<br />
</c:forEach></p>
</div>
<br />

<div class="callout" id="contacts">
<h2 class="bar-gray-med-dark">LPAR Contacts</h2>
<p><c:forEach items="${contactList}" var="contact">
	<html:link
		page="/contact/view.do?context=LPAR&accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}&customerid=${account.customer.customerId}&id=${contact.contact.id}">
		<c:out value="${contact.contact.name}" />
	</html:link>
	<br />
</c:forEach></p>
</div>
<br />

</div>
<!-- stop partial-sidebar -->

<h1>Hardware Detail: <font class="green-dark"><c:out
	value="${hardware.lparName}" /></font></h1>
<p class="confidential">IBM Confidential</p>

<tmp:insert template="/WEB-INF/jsp/hardware/banner.jsp" /> <br
	clear="all" />
<tmp:insert template="/WEB-INF/jsp/hardware/commentHistory.jsp" /> <!-- END CONTENT HERE -->
</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

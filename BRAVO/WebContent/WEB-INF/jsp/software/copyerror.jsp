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
			&gt;
			<html:link page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${software.softwareLpar.name}&swId=${software.softwareLpar.id}">
				<c:out value="${software.softwareLpar.name}"/>
			</html:link>
			&gt;
			<html:link page="/software/home.do?lparId=${software.softwareLpar.id}">
				Software
			</html:link>
			&gt;
			<html:link page="/software/view.do?id=${software.id}">
				${software.software.softwareName}
			</html:link>
		</p>
	</div>
	<div id="content-main">
<!-- START CONTENT HERE -->
 
  <label for="id_type">This function only apply for Software Lpar .</label>

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
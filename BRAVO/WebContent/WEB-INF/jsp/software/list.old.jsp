<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Hostnames: <c:out value="${account.customer.customerName}"/></title>
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
			<html:link page="/account/view.do?id=${account.customer.accountNumber}">
				<c:out value="${account.customer.customerName}"/>
			</html:link>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1>Hostname List: <font class="green-dark"><c:out value="${account.customer.customerName}"/></font></h1>
	<p class="confidential">IBM Confidential</p>
	<br/>
	
	<tmp:insert template="/WEB-INF/jsp/account/banner.jsp">
		<tmp:put name="customer" value="${account.customer}"/>
	</tmp:insert>
	<br/>

	<display:table name="list" requestURI="" class="bravo">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="statusImage" title="" headerClass="purple" class="status"/>
	  	<display:column property="name" title="Hostname" sortable="true" headerClass="purple"/>
	  	<display:column property="hardwareLparUrl" title="Hardware" headerClass="purple"/>
	  	<display:column property="softwareLparUrl" title="Software" headerClass="purple"/>
	</display:table>
				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
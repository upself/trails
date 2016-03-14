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
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<!-- start partial-sidebar -->
	<div id="partial-sidebar">
		<h2 class="access">Start of sidebar content</h2>

		<div class="search">
		<html:form action="/lpar/search">
			<html:hidden property="context" value="lpar"/>
			<html:hidden property="accountId" value="${account.customer.accountNumber}"/>
			<html:text property="search" styleClass="inputshort" disabled="true"/>
			<span class="button-blue"><html:submit property="type" value="Search" disabled="true"/></span>
		</html:form>
		</div>
		<br/>

		<div class="action">
			<h2 class="bar-gray-med-dark">
				Actions
				<html:link page="/help/help.do#H9"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
			</h2>
		</div><br/>
		
		<div class="callout" id="contacts">
			<h2 class="bar-gray-med-dark">Account Contacts</h2>
		</div><br/>

	</div>
	<!-- stop partial-sidebar -->

	<h1>Account Error: </h1>
	<br/>
	
	<div class="invalid"><html:errors property="error"/></div>
	<html:form action="/lpar/search">
	<html:hidden property="context" value="lpar"/>
	<html:hidden property="accountId" value="${account.customer.accountNumber}"/>
	<table border="0" width="65%" cellspacing="10" cellpadding="0">
		<tbody>
			<tr><td>
			</td></tr>
			<tr><td>
				Lpar Search:
			</td></tr>
			<tr><td>
				<html:text property="search" styleClass="inputlong" disabled="true"/>
				<span class="button-blue"><html:submit property="type" value="Search" disabled="true"/></span>
			</td></tr>
		</tbody>
	</table>
	</html:form>	

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
  </body>
</html>
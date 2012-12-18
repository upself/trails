<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>View/Edit Account Contacts</title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
	<h1 class="access">Start of main content</h1>


    <c:choose>
		<c:when test="${context == 'LPAR'}">
			<div id="content-head">
				<p id="date-stamp">New as of 26 June 2006</p>
				<div class="hrule-dots"></div>
				<p id="breadcrumbs">
					<html:link page="/">
						BRAVO
					</html:link>
					&gt;
					<html:link page="/lpar/view.do?accountId=${accountId}&lparName=${lparName}">
						Back to LPAR Details
					</html:link>
				</p>
			</div>
		</c:when>
		<c:when test="${context == 'HDW'}">
			<div id="content-head">
				<p id="date-stamp">New as of 26 June 2006</p>
				<div class="hrule-dots"></div>
				<p id="breadcrumbs">
					<html:link page="/">
						BRAVO
					</html:link>
					&gt;
					<html:link page="/hardware/home.do?lparId=${lparId}">
						Hardware
					</html:link>
				</p>
			</div>
		</c:when>
		<c:otherwise>
			<div id="content-head">
				<p id="date-stamp">New as of 26 June 2006</p>
				<div class="hrule-dots"></div>
				<p id="breadcrumbs">
					<html:link page="/">
						BRAVO
					</html:link>
					&gt;
					<html:link page="/account/view.do?accountId=${accountId}">
						Back to Account Details
					</html:link>
				</p>
			</div>
		</c:otherwise>
	</c:choose>


	<div id="content-main">
<!-- START CONTENT HERE -->

	<!-- start partial-sidebar -->
	<div id="partial-sidebar">
		<h2 class="access">Start of sidebar content</h2>


    <c:choose>
		<c:when test="${context == 'ACCOUNT'}">

			<div class="action">
			<h2 class="bar-gray-med-dark">
				Actions
				<html:link page="/help/help.do#H9"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
			</h2>
				<p>
					<!-- Refresh Contact -->
					<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13" height="13"/>
					<html:link page="/contact/refresh.do?accountId=${accountId}&lparName=${lparName}&context=ACCOUNT&id=${contact.contact.id}&customerid=${contact.customer.customerId}&email=${contact.contact.email}">Refresh Contact Information from Blue Pages</html:link>
					<br/>
				</p>
			</div><br/>
		</c:when>
		<c:when test="${context == 'HDW'}">

			<div class="action">
				<h2 class="bar-gray-med-dark">
					Actions
					<html:link page="/help/help.do#H9"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
				</h2>
				<p>
					<!-- Refresh Contact -->
					<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13" height="13"/>
					<html:link page="/contact/refresh.do?accountId=${accountId}&lparName=${lparName}&context=HDW&id=${contact.contact.id}&customerid=${customerId}&email=${contact.contact.email}">Refresh Contact Information from Blue Pages</html:link>
					<br/>
				</p>
			</div><br/>
		</c:when>
		<c:otherwise>
			<div class="action">
				<h2 class="bar-gray-med-dark">
					Actions
					<html:link page="/help/help.do#H9"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
				</h2>
				<p>
					<!-- Refresh Contact -->
					<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13" height="13"/>
					<html:link page="/contact/refresh.do?accountId=${accountId}&lparName=${lparName}&context=LPAR&id=${contact.contact.id}&customerid=${customerId}&email=${contact.contact.email}">Refresh Contact Information from Blue Pages</html:link>
					<br/>
				</p>
			</div><br/>
		</c:otherwise>
	</c:choose>


	</div>
	<!-- stop partial-sidebar -->


	<h1>Contact Details:</h1>
	<br/>

	<tmp:insert template="/WEB-INF/jsp/contact/banner.jsp"/>

				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
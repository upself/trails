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

    <label for="id_type">You can not create or update a contact for a null Hardware Lpar</label>
				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
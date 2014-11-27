<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Software: <c:out value="${software.softwareLpar.name}"/></title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->


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
			<html:link page="/software/view.do?lparId=${software.softwareLpar.id}">
				Software
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
				<!-- Create Software Discrepancy -->
				<img alt="" src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13" height="13"/>
				<html:link page="/software/lpar/create.do?lparId=${software.softwareLpar.id}">Add Missing Software Product</html:link>
				<br/>

				<!-- Upload VM Software -->
				<img src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14" height="12"/>
				<a href="#">Upload SW Discrepancies</a>
				<br/>

				<!-- Upload Soft Audit Software -->
				<img src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14" height="12"/>
				<a href="#">Upload SW Tar File</a>
			</p>
		</div><br/>

	</div>
	<!-- stop partial-sidebar -->

	<h1>Software Detail: <font color="green-dark"><c:out value="${software.softwareLpar.name}"/></font></h1>
	<p class="confidential">IBM Confidential</p>

	<tmp:insert template="/WEB-INF/jsp/software/bannerLpar.jsp"/>
	<tmp:insert template="/WEB-INF/jsp/software/statistics.jsp"/>

	<br clear="all"/>
	<div class="indent">
	-- fancy ajax filtering goes here --
	</div>
	
	<div class="indent">
		<h3>
			Software
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<display:table name="list" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="statusImage" title="" headerClass="blue-med"/>
		<display:column property="software.softwareName" title="Name" sortable="true" headerClass="blue-med"/>
	  	<display:column property="software.manufacturer.manufacturerName" title="Manufacturer" sortable="true" headerClass="blue-med"/>
	  	<display:column property="software.level" title="License Level" sortable="true" headerClass="blue-med"/>
	  	<display:column property="discrepancyType.name" title="Discrepancy" sortable="true" headerClass="blue-med"/>
	</display:table>

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
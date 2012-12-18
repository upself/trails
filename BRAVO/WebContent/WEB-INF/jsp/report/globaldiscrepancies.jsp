<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Global Discrepancies Report</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content"><!-- START CONTENT HERE -->

<h1 class="access">Start of main content</h1>
<!-- start content head -->

<div id="content-head">
<p id="date-stamp">New as of 8 September 2008</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/"> BRAVO </html:link> &gt; <html:link
	page="/report/home.do">
				Report
				</html:link> &gt; Global Discrepancies Report</p>
</div>
<div>
<!-- start main content -->
<h1>Global Discrepancies Report</h1>
<p class="confidential">IBM Confidential</p>
<br />
<display:table name="report" requestURI="" class="bravo">
	<display:setProperty name="basic.empty.showtable" value="true" />

	<display:column property="geo" title="GEO"
		headerClass="blue-med" sortable="true" />
	<display:column property="region" title="Region"
		headerClass="blue-med" sortable="true" />
	<display:column property="countryName" title="Country"
		headerClass="blue-med" sortable="true" />
	<display:column property="accountNumber" title="Account Number"
		headerClass="blue-med" sortable="true" />
	<display:column property="customerName" title="Account Name"
		headerClass="blue-med" sortable="true" />
	<display:column property="customerTypeName" title="Account Type"
		headerClass="blue-med" sortable="true" />
	<display:column property="podName" title="Department"
		headerClass="blue-med" sortable="true" />
	<display:column property="hostName" title="Hostname"
		headerClass="blue-med" sortable="true" />
	<display:column property="softwareName" title="Software Name"
		headerClass="blue-med" sortable="true" />
	<display:column property="discrepancyTypeName" title="Discrepancy Type"
		headerClass="blue-med" />
	<display:column property="invalidCategory" title="Invalid Category"
		headerClass="blue-med" />
	<display:column property="remoteUser" title="Last Updated By"
		headerClass="blue-med" />
	<display:column property="recordTime" title="Last Updated On"
		headerClass="blue-med" />
	<display:column property="version" title="Version"
		headerClass="blue-med" />
	<display:column property="researchFlag" title="Research Flag"
		headerClass="blue-med" />
	<display:column property="comment" title="Comment"
		headerClass="blue-med" />
		
</display:table> <!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

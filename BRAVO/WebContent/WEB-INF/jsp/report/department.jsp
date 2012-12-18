<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Department Scan Reports</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content"><!-- START CONTENT HERE -->

<h1 class="access">Start of main content</h1>
<!-- start content head -->

<div id="content-head">
<p id="date-stamp">New as of 26 June 2006</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/"> BRAVO </html:link> &gt; <html:link
	page="/report/home.do">
				Report
				</html:link> &gt; Department Scan</p>
</div>

<!-- start main content -->
<h1>Department Scan</h1>
<p class="confidential">IBM Confidential</p>
<br />
<div id="content-main"><html:form action="/report/department.do">
	<label for="id_podId">Department</label>: <html:select styleId="id_podId" property="id">
		<html:options collection="department" property="podId"
			labelProperty="podName" />
	</html:select>
	<span class="button-blue"><html:submit property="action"
		value="Go" /> </span>
</html:form><br/>
<display:table name="report" requestURI="" class="bravo">
	<display:setProperty name="basic.empty.showtable" value="true" />

	<display:column property="accountNumber" title="Account"
		headerClass="blue-med" sortable="true" href="/BRAVO/account/view.do"
		paramId="accountId" paramProperty="accountNumber"/>
	<display:column property="customerName" title="Customer"
		headerClass="blue-med" sortable="true" />
	<display:column property="customerType" title="Type"
		headerClass="blue-med" sortable="true" />
	<display:column property="swAnalyst" title="SW Analyst"
		headerClass="blue-med" sortable="true" />
	<display:column property="hwAnalyst" title="HW Analyst"
		headerClass="blue-med" sortable="true" />
	<display:column property="swGrFlag" title="GR"
		headerClass="blue-med" sortable="true" />
	<display:column property="assetType" title="Asset Type"
		headerClass="blue-med" sortable="true" />
	<display:column property="swLparWoScan" title="SW No Scan"
		headerClass="blue-med" sortable="true" />
	<display:column property="hwLpars" title="Tot. HW"
		headerClass="blue-med" sortable="true" />
	<display:column property="hwSwComposites" title="Comp."
		headerClass="blue-med" sortable="true" />
	<display:column property="hwScanPercent" title="% HW Scan"
		headerClass="blue-med" sortable="true" />
</display:table> <!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

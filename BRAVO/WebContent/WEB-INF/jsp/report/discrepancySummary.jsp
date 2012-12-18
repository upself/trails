<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Discrepancy Summary Report</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content"><!-- START CONTENT HERE -->

<h1 class="access">Start of main content</h1>
<!-- start content head -->

<div id="content-head">
<p id="date-stamp">New as of 15 September 2008</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/"> BRAVO </html:link> &gt; <html:link
	page="/report/home.do">
				Report
				</html:link> &gt; Discrepancy Summary Report</p>
</div>

<!-- start main content -->
<h1>Discrepancy Summary Report</h1>
<p class="confidential">IBM Confidential</p>
<br />
<display:table name="report" requestURI="" class="bravo">
	<display:setProperty name="basic.empty.showtable" value="true" />

	<display:column property="softwareName" title="Software Name"
		headerClass="blue-med" href="/BRAVO/download/globalDiscrepancies.tsv?name=globalDiscrepancies" 
		paramId="software" paramProperty="softwareId" />
	<display:column property="discrepancyTypeName" title="Discrepancy Type"
		headerClass="blue-med" />
	<display:column property="numProducts" title="# of Products"
		headerClass="blue-med" style="text-align: right" />
		
</display:table> <!-- END CONTENT HERE --></div>

<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>
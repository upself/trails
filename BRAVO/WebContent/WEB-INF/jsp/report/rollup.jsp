<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>GEO Scan Reports</title>
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
				</html:link> &gt; <html:link page="/report/georeport.do">GEO Scan Report</html:link> &gt; Department Roll up</p>
</div>

<!-- start main content -->
<h1>Department Roll up</h1>
<p class="confidential">IBM Confidential</p>
<br />
<display:table name="report" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
	<display:setProperty name="basic.empty.showtable" value="true" />

	<display:column property="customerName" title=""
		headerClass="blue-med" sortable="true" />
	<display:column property="swAnalyst" title="Dept"
		headerClass="blue-med" sortable="true" href="department.do"
		paramId="id" paramProperty="accountNumber" />
	<display:column property="assetType" title="Asset Type"
		headerClass="blue-med" sortable="true" />
	<display:column property="swLparWoScan" title="SW LPAR w/o Scan"
		headerClass="blue-med" sortable="true" />
	<display:column property="hwLpars" title="Tot. HW"
		headerClass="blue-med" sortable="true" />
	<display:column property="hwSwComposites" title="Tot. HW/SW Composite"
		headerClass="blue-med" sortable="true" />
	<display:column property="calculatedPercent" title="% HW Scan"
		headerClass="blue-med" sortable="true" />
</display:table> <!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
 <script type="text/javascript"> var _paq = _paq || []; _paq.push(['trackPageView']); _paq.push(['enableLinkTracking']); (function() { var u="//lexbz181197.cloud.dst.ibm.com:8085/"; _paq.push(['setTrackerUrl', u+'piwik.php']); _paq.push(['setSiteId', 1]); var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s); })(); </script> <noscript><p><img src="//lexbz181197.cloud.dst.ibm.com:8085/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript> </body>
</html>

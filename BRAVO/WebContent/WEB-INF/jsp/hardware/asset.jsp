<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Hardware Asset - S/N: <c:out value="${hardware.serial}"/></title>
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
				<c:if test="${account.customer.customerType.customerTypeName == 'STRATEGIC OUTSOURCING MAINFRAME'}">
					<!-- Upload SCRT Report -->
					<img src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14" height="12"/>
					<html:link page="/upload/scrtReport.do?id=${account.customer.accountNumber}">Upload SCRT Report</html:link><br/>
				</c:if>
				<!-- Link to ATP Record -->
				<!--
				<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13" height="13"/>
				<a href="http://tap.raleigh.ibm.com/ATP/assetDetail.do?machtype=${hardware.machineTypeName}&serial=${hardware.serial}&isocntry=${hardware.country}">Go to ATP Record</a><br/>	
				-->
			</p>
		</div><br/>

	</div>
	<!-- stop partial-sidebar -->
	
	<h1>Hardware Asset Detail: <font class="green-dark"><c:out value="${hardware.machineTypeName}"/> / <c:out value="${hardware.serial}"/></font></h1>
	<p class="confidential">IBM Confidential</p>

	<div class="indent">
		<h3>
			Hardware Asset
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	
	<table class="bravo" id="small">
		<thead>
		<tr>
			<th class="blue-med">Type</th>
			<th class="blue-med">Serial</th>
			<th class="blue-med">Country</th>
			<th class="blue-med">Customer Number</th>
			<th class="blue-med">Processor Count</th>
		</tr>
		</thead>
		<tbody>
		<tr>
			<td><font class="orange-dark"><c:out value="${hardware.machineTypeName}"/></font></td>
			<td><font class="orange-dark"><c:out value="${hardware.serial}"/></font></td>
			<td><font class="orange-dark"><c:out value="${hardware.country}"/></font></td>
			<td><font class="orange-dark"><c:out value="${hardware.customerNumber}"/></font></td>
			<td><font class="orange-dark"><c:out value="${hardware.processorCount}"/></font></td>
		</tr>
		</tbody>
	</table>
	
	<c:if test="${account.customer.customerType.customerTypeName == 'STRATEGIC OUTSOURCING MAINFRAME'}">
		<div class="indent">
			<h3>
				SCRT Records
				<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
			</h3>
		</div>
		
		<display:table name="scrtRecords" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
					<display:setProperty name="basic.empty.showtable" value="true"/>		
					<display:column property="year" title="Report Year" sortable="false" headerClass="blue-med"/>
					<display:column property="month" title="Report Month" sortable="false" headerClass="blue-med"/>
					<display:column property="cpc" title="CPC" sortable="false" headerClass="blue-med"/>
					<display:column property="lpar" title="LPAR" sortable="false" headerClass="blue-med"/>
					<display:column property="msu" title="MSU" sortable="false" headerClass="blue-med"/>
					<display:column property="remoteUser" title="Uploaded By" sortable="false" headerClass="blue-med"/>
					<display:column property="uploadDay" title="Uploaded" sortable="false" headerClass="blue-med"/>
				  	<display:column property="scrtReportFile" title="SCRT Report" sortable="false" headerClass="blue-med" href="/BRAVO/download/scrtReport.${account.customer.accountNumber}.csv?name=scrtReport" paramId="scrtReportFile" paramProperty="scrtReportFile" />
		</display:table>
	</c:if>
<!-- <a href="/BRAVO/download/accountDiscrepancies.${account.customer.accountNumber}.tsv?name=accountDiscrepancies&accountId=${account.customer.accountNumber}">Account Discrepancies</a><br/> -->

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
 <script type="text/javascript"> var _paq = _paq || []; _paq.push(['trackPageView']); _paq.push(['enableLinkTracking']); (function() { var u="//lexbz181197.cloud.dst.ibm.com:8085/"; _paq.push(['setTrackerUrl', u+'piwik.php']); _paq.push(['setSiteId', 1]); var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s); })(); </script> <noscript><p><img src="//lexbz181197.cloud.dst.ibm.com:8085/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript> </body>
</html>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Software: <c:out value="${software.software.softwareName}"/></title>
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
			<html:link page="/software/home.do?lparId=${software.softwareLpar.id}">
				Software
			</html:link>
			&gt;
			<html:link page="/software/view.do?id=${software.id}">
				${software.software.softwareName}
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
				<!-- Update Software Discrepancy -->
				<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13" height="13"/>
				<html:link page="/software/update.do?id=${software.id}">Update Software Discrepancy</html:link><br/>

			</p>
		</div><br/>

		<div class="callout" id="reports">
			<h2 class="bar-gray-med-dark">
				Reports
				<html:link page="/help/help.do#10"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
			</h2>
			<p>
				<!-- Global Discrepancies Report -->
				<img src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14" height="12" alt="email icon"/>
				<html:link page="/download/${software.software.softwareName} on ${account.customer.accountNumber}.tsv?name=accountSoftware&softwareId=${software.software.softwareId}&accountId=${account.customer.accountNumber}">All LPARs With This Software</html:link><br/>
			</p>
		</div><br/>

		<div class="indent">
			<font color="red" size="1">
				Signatures, filters, and product id's are considered IBM confidential intellectual capital. Do NOT share these with outside organizations and customers.
			</font>
		</div><br/>

	</div>
	<!-- stop partial-sidebar -->

	<h1>Software Detail: <font class="green-dark"><c:out value="${software.software.softwareName}"/></font></h1>
	<p class="confidential">IBM Confidential</p>

	<tmp:insert template="/WEB-INF/jsp/software/banner.jsp"/>
	
	<tmp:insert template="/WEB-INF/jsp/software/signatures.jsp"/>

	<tmp:insert template="/WEB-INF/jsp/software/filters.jsp"/>

	<tmp:insert template="/WEB-INF/jsp/software/softAudits.jsp"/>
	
	<tmp:insert template="/WEB-INF/jsp/software/vmProducts.jsp"/>

	<tmp:insert template="/WEB-INF/jsp/software/doranas.jsp"/>
	
	<tmp:insert template="/WEB-INF/jsp/software/tadz.jsp"/>
	
	<tmp:insert template="/WEB-INF/jsp/software/commentHistory.jsp"/>
	
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
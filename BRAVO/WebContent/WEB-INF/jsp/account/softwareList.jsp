<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Bravo Account List</title>
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
<p id="breadcrumbs"><html:link page="/">
				BRAVO
			</html:link></p>
</div>

<!-- start main content -->
<div id="content-main">

<h1>Search results:</h1>
<p class="confidential">IBM Confidential</p>
<br />

<div class="invalid"><html:errors /></div>

<div class="indent">
<h3>Composites <html:link page="/help/help.do#H2">
	<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h3>
</div>
<display:table name="composites" requestURI="" class="bravo" id="tall"
	defaultsort="1" defaultorder="ascending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column sortProperty="name" title="HW name" sortable="true"
		headerClass="blue-med">
		<a
			href="/BRAVO/lpar/view.do?accountId=<c:out value="${tall.customer.accountNumber}"/>&lparName=<c:out value="${tall.name}"/>&hwId=<c:out value="${tall.id}"/>"><c:out
			value="${tall.name}" /></a>
	</display:column>
	<display:column property="softwareLpar.name" title="SW name"
		sortable="true" headerClass="blue-med" />
	<display:column property="customer.accountNumber" title="Acct #"
		sortable="true" headerClass="blue-med" />
	<display:column property="hardware.machineType.type" title="Type"
		sortable="true" headerClass="blue-med" />
	<display:column property="hardware.serial" title="HW serial"
		sortable="true" headerClass="blue-med" />
	<display:column property="softwareLpar.biosSerial" title="SW serial"
		sortable="true" headerClass="blue-med" />
	<display:column property="hardware.hardwareStatus" title="ATP Status"
		sortable="true" headerClass="blue-med" />
</display:table>

<div class="indent">
<h3>Software lpars w/o Hardware <html:link page="/help/help.do#H2">
	<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h3>
</div>
<display:table name="softwareLpars" requestURI="" class="bravo"
	id="tall" defaultsort="2" defaultorder="ascending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column property="statusImage" title="" sortable="true"
		headerClass="blue-med" />
	<display:column sortProperty="name" title="Name" sortable="true"
		headerClass="blue-med">
		<a
			href="/BRAVO/lpar/view.do?accountId=<c:out value="${tall.customer.accountNumber}"/>&lparName=<c:out value="${tall.name}"/>&swId=<c:out value="${tall.id}"/>"><c:out
			value="${tall.name}" /></a>
	</display:column>
	<display:column property="customer.accountNumber" title="Account ID"
		sortable="true" headerClass="blue-med" />
	<display:column property="biosSerial" title="BIOS Serial"
		sortable="true" headerClass="blue-med" />
</display:table> <!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

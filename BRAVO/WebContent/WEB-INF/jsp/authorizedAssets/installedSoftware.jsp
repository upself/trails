<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Bravo Account: <c:out
	value="${account.customer.customerName}" /></title>
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
            </html:link> &gt; <html:link
	page="/account/view.do?accountId=${account.customer.accountNumber}">
	<c:out value="${account.customer.customerName}" />
</html:link> &gt; <html:link
	page="/authorizedAsset/search.do?accountId=${account.customer.accountNumber}">
    Authorized asset search
</html:link>&gt; Authorized assets</p>
</div>

<!-- start main content -->
<div id="content-main">

<h1>Authorized assets for Hardware LPAR: <font class="green-dark"><c:out
	value="${hardwareLpar.name}" /></font></h1>
<p class="confidential">IBM Confidential</p>
<br />
<div class="invalid"><html:errors /></div>
<div class="indent">
<h3>Authorized assets list <html:link page="/help/help.do#H2">
	<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h3>
</div>
<display:table id="row" name="assets" requestURI="" class="bravo"
	defaultsort="1" defaultorder="ascending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column property="product.softwareName" title="Software name"
		sortable="true" headerClass="blue-med" />
	<display:column property="version" title="Version" sortable="true"
		headerClass="blue-med" />
	<display:column property="changeNumber" title="Change #"
		sortable="true" headerClass="blue-med" />
	<display:column property="changeDate" title="Change Date"
		sortable="true" headerClass="blue-med" format="{0,date,long}" />
	<display:column property="creationTime" title="Create Time"
		sortable="true" headerClass="blue-med" format="{0,date,long}" />
	<display:column property="remoteUser" title="Editor" sortable="true"
		headerClass="blue-med" />
	<display:column property="comment" title="Comments" sortable="true"
		headerClass="blue-med" />
	<display:column property="active" title="Active" sortable="true"
		headerClass="blue-med" />
</display:table> <br />

<!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>
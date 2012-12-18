<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>System Status Home</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>

<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />

<!-- BEGIN CONTENT -->
<div id="content">
<h1 class="access">Start of main content</h1>

<!-- BEGIN CONTENT HEAD -->
<div id="content-head">
<p id="date-stamp">New as of 26 January 2009</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/">BRAVO</html:link> &gt; <html:link
	page="/systemStatus/home.do">System status</html:link></p>
</div>

<!-- BEGIN MAIN CONTENT -->
<div id="content-main"><!-- BEGIN PARTIAL-SIDEBAR -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="action">
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="Contextual field help icon" />
</html:link></h2>
</div>
<br />

</div>
<!-- END PARTIAL-SIDEBAR -->

<h1>System status</h1>
<display:table cellspacing="2" cellpadding="0"
	name="systemScheduleStatusList" id="table_system status_row" requestURI="" class="bravo"
	defaultsort="3" defaultorder="descending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column property="name" title="Module" sortable="true"
		headerClass="blue-med" />
	<display:column property="comments" title="Comments" sortable="true"
		headerClass="blue-med" />
	<display:column property="startTime" class="date"
		format="{0,date,MM-dd-yyyy HH:mm:ss}" title="Start time"
		sortable="true" headerClass="blue-med" />
	<display:column property="endTime" class="date"
		format="{0,date,MM-dd-yyyy HH:mm:ss}" title="End time" sortable="true"
		headerClass="blue-med" />
	<display:column property="elapsedTime" title="Elapsed time"
		sortable="false" headerClass="blue-med" style="white-space:nowrap" />
	<display:column property="status" title="Status" sortable="true"
		headerClass="blue-med" />
</display:table>

<h1>Bank account jobs</h1>
<display:table cellspacing="2" cellpadding="0" name="bankAccountJobList"
	id="table_bank_account_jobs_row" requestURI="" class="bravo" defaultsort="4"
	defaultorder="descending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column property="bankAccount.name" title="Bank account name"
		sortable="true" headerClass="blue-med" />
	<display:column property="name" title="Module" sortable="true"
		headerClass="blue-med" />
	<display:column property="comments" title="Comments" sortable="true"
		headerClass="blue-med" />
	<display:column property="startTime" class="date"
		format="{0,date,MM-dd-yyyy HH:mm:ss}" title="Start time"
		sortable="true" headerClass="blue-med" />
	<display:column property="endTime" class="date"
		format="{0,date,MM-dd-yyyy HH:mm:ss}" title="End time" sortable="true"
		headerClass="blue-med" />
	<display:column property="elapsedTime" title="Elapsed time"
		sortable="false" headerClass="blue-med" style="white-space:nowrap" />
	<display:column property="status" title="Status" sortable="true"
		headerClass="blue-med" />
</display:table></div>
<!-- END MAIN CONTENT --></div>
<!-- END CONTENT -->
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

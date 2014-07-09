<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>View/Edit Machine Type Reference</title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->

	<h1 class="access">Start of main content</h1>
	<!-- start content head -->

	<div id="content-head">
		<p id="date-stamp">New as of 26 June 2006</p>
		<div class="hrule-dots"></div>
		<p id="breadcrumbs">
			<html:link page="/">
				BRAVO
			</html:link>
			&gt;
			<html:link page="/admin/home.do">
				Administration
			</html:link>
			&gt;
			<html:link page="/admin/machinetype/home.do">
				Machine Type
			</html:link>
			&gt;
			<b>%<c:out value="${search}"/>%</b>
		</p>
	</div>

	<!-- start partial-sidebar -->
	<div id="partial-sidebar">
		<h2 class="access">Start of sidebar content</h2>

		<div class="action">
			<h2 class="bar-gray-med-dark">
				Actions
				<html:link page="/help/help.do#H9"><img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif" width="14" height="14" alt="contextual field help icon"/></html:link>
			</h2>
			<p>
				<!-- Create Machine Type -->
				<img alt="" src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13" height="13"/>
				<html:link page="/admin/machinetype/create.do?context=list&search=${search}&searchtype=${searchtype}&id=">Create New Machine Type</html:link>
 				<br/>

			</p>
		</div><br/>
	</div>
	<!-- stop partial-sidebar -->



	<!-- start main content -->
	<div id="content-main">
	
	<h1>Machine Type Search Results: </h1>
	<p class="confidential">IBM Confidential</p>
	<br/>
	
	<display:table name="list" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="statusImage" title="" headerClass="blue-med" class="status"/>
	  	<display:column property="name" title="Name" href="/BRAVO/admin/machinetype/view.do?action=View&searchtype=${searchtype}&search=${search}" paramId="id" paramProperty="id" sortable="true" headerClass="blue-med"/>
	  	<display:column property="type" title="Type" headerClass="blue-med"/>
	  	<display:column property="definition" title="Definition" headerClass="blue-med"/>
	</display:table>


				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
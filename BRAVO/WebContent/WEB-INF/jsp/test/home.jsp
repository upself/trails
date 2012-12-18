<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="bean"	uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Test Home</title>
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
			<html:link page="/test/home.do">
				Test
			</html:link>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1>Test Home:</h1>
	<br/>
	
	<h2>Download:</h2>
	<br/>
	
	<display:table name="list" requestURI="" class="bravo">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="name" title="Name" headerClass="blue-med" href="/BRAVO/test/download.do" paramId="id" paramProperty="id"/>
		<display:column property="size" title="Size" sortable="true" headerClass="blue-med"/>
		<display:column property="remoteUser" title="User" sortable="true" headerClass="blue-med"/>
		<display:column property="recordTime" title="Time" sortable="true" headerClass="blue-med"/>
	</display:table>
	<br/>

	<h2>Upload:</h2>
	<br/>
	
	<html:form action="/test/upload" enctype="multipart/form-data">
	
	<table border="0" width="80%" cellspacing="10" cellpadding="0">
	<tbody>
		<tr>
			<td nowrap="nowrap" width="1%">Filename:</td>
			<td><html:file property="file" size="60"/></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td class="error"><html:errors property="error"/></td>
			<td></td>
		</tr>
		<tr>
			<td></td>
			<td nowrap="nowrap">
				<span class="button-blue">
					<html:submit property="action" value="Upload File"/>
				</span>
			</td>
		</tr>
		</tbody>
	</table>
	</html:form>

	
	
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
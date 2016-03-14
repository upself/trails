<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>

<html lang="en">
<head>
	<title>Welcome to BRAVO</title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
	<h1 class="access">Start of main content</h1>
	<div id="content-head">
		<p id="breadcrumbs"></p>
	</div>
	<div id="content-main">
<!-- START CONTENT HERE -->

		<h1>Scan Upload</h1>
		<br/> 

<html:form action="/upload/loadScanLoad" method="post" enctype="multipart/form-data">
<table>
<tr>
<td align="center" colspan="2">
</td>
</tr>

<tr>
<td align="left" colspan="2">
<font color="red"><html:errors property="filename" /></font>
</td>
</tr>



<tr>
<td align="right">
File Name
</td>
<td align="left">
<html:file property="file"/> 
</td>
</tr>


<tr>
<td>
	<input type="checkbox" name="parsePreview" checked="checked"/>Preview Import
</td>
<td align="right">
<html:submit>Upload File</html:submit>
</td>
</tr>
<tr>
</tr>

</table>
<h3>File Type</h3>
	<select size="4" name="scanType">
		<option value="softaudit" selected="selected">SoftAudit Scan</option>
		<option value="vm">VM Scan</option>
		<option value="tivoli">Distributed tar file scan</option>
		<option value="manual">Manual Loader Sheet</option>
	</select>
	<input type="text" name="hardwareSoftwareId" size="20" readonly="readonly" value='<%= request.getParameter("id") %>'/>
</html:form>

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
  </body>
</html>
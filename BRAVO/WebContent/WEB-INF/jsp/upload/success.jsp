<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="bean"		uri="http://struts.apache.org/tags-bean" %>
<%@ taglib prefix="logic"		uri="http://struts.apache.org/tags-logic" %>

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

		<h1>File Uploaded/Submitted</h1>
		<br/>
 
     <logic:present name="parsedAcct"> 
       <logic:iterate id="myCollectionElement" name="parsedAcct"> 
         Product: <bean:write name="myCollectionElement" /><br /> 
       </logic:iterate> 
     </logic:present> 

<
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
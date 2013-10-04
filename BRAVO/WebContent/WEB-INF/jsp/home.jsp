<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="req"
	uri="http://jakarta.apache.org/taglibs/request-1.0"%>

<html lang="en">
<head>
<title>Welcome to BRAVO</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content">
<h1 class="access">Start of main content</h1>
<div id="content-head">
<p id="breadcrumbs"></p>
</div>
<div id="content-main"><!-- START CONTENT HERE -->

<h1>BRAVO Home</h1>
<br />
<html:img alt="Scenic overlook telescope" page="/images/p1_w3v8_19.jpg"
	align="left" hspace="10" vspace="10" /> <br />
<p style="color: #c60" class="caption">Welcome to BRAVO</p>
<br />
Navigate using the toolbar to the left or <strong style="color: #7a3"
	class="caption">search</strong> below.<br />

<br clear="all" />

<html:form action="/search">
	<html:hidden property="context" value="home" />
	<table border="0" width="65%" cellspacing="10" cellpadding="0">
		<div class="invalid"><html:errors /></div>
		<tbody>
			<tr>
				<td><label for="id_type">Search</label>:</td>
				<td><html:select styleId="id_type" property="type"
					styleClass="inputlong">
					<html:option value="ACCOUNT">Account Id/Name/Dept</html:option>
					<!-- 
					<html:option value="SOFTWARELPAR">Software LPAR name/serial</html:option>
					<html:option value="HARDWARELPAR">Hardware LPAR name/serial</html:option>
					 -->
				</html:select><html:link page="/help/help.do#H1">
					<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
						width="14" height="14" alt="contextual field help icon" />
				</html:link></td>
			</tr>
			<tr>
				<td><label for="id_search">Search text</label>:</td>
				<td><html:text styleId="id_search" property="search"
					styleClass="inputlong" /> <span class="button-blue"><html:submit
					property="type" value="Search" /></span></td>
			</tr>
		</tbody>
	</table>
</html:form> <br />
<br />


<br clear="all" />

<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr>
		<td width="40%" style="color: #7a3" class="caption">Quick Links:</td>
		<td style="color: #7a3" class="caption">Help Contacts:</td>
	</tr>
	<tr>
		<td colspan=2>
		<div class="hrule-dots"></div>
		</td>
	</tr>
	<tr>
		<td>
		<%
			/*
		%> <img alt="Action"
			src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
			height="13" /> <html:link page="/access/init.do">Register for access to BRAVO</html:link>
		<br />
		<%
			*/
		%> <!--<img alt="Download"
			src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
			height="12" /> <html:link page="/downloads/BRAVO Overview v1.ppt">BRAVO
		Overview</html:link> <br />

		<img alt="Download"
			src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
			height="12" /> <html:link page="/downloads/Account Baseline.xls">Account
		Scope Listing (AG GEO only)</html:link> <br />

		<img alt="Download"
			src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
			height="12" /> <html:link
			page="/downloads/2006 Americas SW Recon SOW.doc">Americas
		SW Recon Statement of Work (AG GEO only)</html:link> <br />

		</td>
		-->
		<td>Please direct all inquires to:<br />
		</td>
	</tr>
</table>
<br />
<br />

<!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

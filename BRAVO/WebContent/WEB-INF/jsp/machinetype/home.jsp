<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="req"
	uri="http://jakarta.apache.org/taglibs/request-1.0"%>

<html lang="en">
<head>
<title>Machine Type Search</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content">
<h1 class="access">Start of main content</h1>
<div id="content-head">
<p id="date-stamp">New as of 26 June 2006</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/">
				BRAVO
			</html:link> &gt; <html:link page="/admin/home.do">
				Administration
			</html:link> &gt; <html:link page="/admin/machinetype/home.do">
				Machine Types
			</html:link></p>
</div>
<div id="content-main"><!-- START CONTENT HERE -->

<h1>Machine Type Search</h1>
<br />
<html:img alt="Scenic overlook telescope" page="/images/p1_w3v8_19.jpg"
	align="left" hspace="10" vspace="10" /> <br />
<p style="color: #c60" class="caption">Machine Type Search</p>
<br />
Navigate using the toolbar to the left or <b><font
	style="color: #7a3" class="caption">search</font></b> below.<br />

<br clear="all" />

<req:isUserInRole role="com.ibm.ea.bravo.user">
	<html:form action="/search">
		<html:hidden property="context" value="machineType" />
		<table border="0" width="80%" cellspacing="10" cellpadding="0">
			<tbody>
				<tr align="center">
					<td nowrap="nowrap">
					<div class="invalid"><html:errors property="search" /></div>
					</td>
				</tr>
				<tr align="center">
					<td nowrap="nowrap"><html:text property="search"
						styleClass="input" /></td>
				</tr>
				<tr align="center">
					<td nowrap="nowrap"><span class="button-blue"><html:submit
						property="type" value="Name" /></span> <span class="button-blue"><html:submit
						property="type" value="Type" /></span> <span class="button-blue"><html:submit
						property="type" value="Definition" /></span></td>
				</tr>
			</tbody>
		</table>
	</html:form>
</req:isUserInRole> <br />
<br />


<br clear="all" />
<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr>
		<td width="33%"><font style="color: #7a3" class="caption">Quick
		Links:</font></td>
		<td width="33%" style="color: #7a3" class="caption">Quick Search:</td>
		<td width="33%" style="color: #7a3" class="caption">Help
		Contacts:</td>
	</tr>
	<tr>
		<td colspan=3>
		<div class="hrule-dots"></div>
		</td>
	</tr>
	<tr>
		<td><img alt=""
			src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
			height="13" /> <html:link page="/access/init.do">Register for access to BRAVO</html:link>
		<br />
		<br />
		</td>
		<td><img alt=""
			src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
			height="13" /> <html:link
			page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=all">All Active Types</html:link>
		</td>
		<td>Please direct all inquires to:<br />
		</td>
	</tr>
	<tr>
		<td></td>
		<td><img alt=""
			src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
			height="13" /> <html:link
			page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=all">All Records</html:link>
		</td>
		<td></td>
	</tr>
	<tr>
		<td></td>
		<td><img alt=""
			src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
			height="13" /> <html:link
			page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=recentadd">Recently Added Types</html:link>
		</td>
		<td></td>
	</tr>
</table>
<br />
<br />

<!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>
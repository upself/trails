<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>View/Edit Machine Type Reference</title>
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
				Machine Type
			</html:link> &gt; <html:link
	page="/admin/machinetype/quicksearch.do?search=${search}&searchtype=${searchtype}&action=List">
				Search Results
			</html:link> &gt; <b><c:out value="${machineType.name}" /></b></p>
</div>
<div id="content-main"><!-- START CONTENT HERE --> <!-- start partial-sidebar -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="action">
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h2>
<p><!-- Edit Machine Type --> <img alt="Action"
	src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
	height="13" /> <html:link
	page="/admin/machinetype/update.do?search=${search}&searchtype=${searchtype}&id=${machineType.id}">Edit This Machine Type</html:link>
<br />

<!-- Delete Machine Type --> <img alt="Delete"
	src="//w3.ibm.com/ui/v8/images/icon-link-delete-dark.gif" width="13"
	height="13" /> <html:link
	page="/admin/machinetype/delete.do?context=${machineType.id}&search=${search}&searchtype=${searchtype}&id=${machineType.id}">Delete This Machine Type</html:link>
<br />

<!-- Create Machine Type --> <img alt="Add"
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" /> <html:link
	page="/admin/machinetype/create.do?context=${machineType.id}&search=${search}&searchtype=${searchtype}&id=">Create New Machine Type</html:link>
<br />


</p>
</div>
<br />
</div>
<!-- stop partial-sidebar -->


<h1>${action} Machine Type: <font color="#FFD700"><c:out
	value="${machineType.name}" /></font></h1>
<p class="confidential">IBM Confidential</p>
<br />


<tmp:insert template="/WEB-INF/jsp/machinetype/banner.jsp" /> <br />
<br />


<br clear="all" />
<table border="0" cellpadding="2" cellspacing="0" width="100%">
	<tr>
		<td width="33%" font style="color: #7a3" class="caption">Quick
		Search:</td>
		<td width="33%" style="color: #7a3" class="caption">Help
		Contacts:</td>
	</tr>
	<tr>
		<td colspan=2>
		<div class="hrule-dots"></div>
		</td>
	</tr>
	<tr>
		<td><img alt="Action"
			src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
			height="13" /> <html:link
			page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=all">All Active Types</html:link>
		</td>
		<td>Please direct all inquires to:<br />
		</td>
	</tr>
	<tr>
		<td><img alt="Action"
			src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
			height="13" /> <html:link
			page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=all">All Records</html:link>
		</td>
		<td></td>
	</tr>
	<tr>
		<td><img alt="Action"
			src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
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
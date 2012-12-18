<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Report Home</title>
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
			</html:link> &gt; <html:link page="/report/home.do">
				Report
			</html:link></p>
</div>

<!-- start main content -->
<div id="content-main"><!-- start partial-sidebar -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="action">
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help" src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h2>
<p><!-- Department reports --> <img alt=""
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" /> <html:link page="/report/department.do">Department Scan Reports</html:link><br />
<!-- Global scanning reports --> <img alt=""
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" /> <html:link page="/report/georeport.do">Global Scan Report</html:link><br />
<!-- Discrepancy Summary report --> <img alt=""
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" /> <html:link page="/report/discrepancySummary.do">Discrepancy Summary Report</html:link><br />
<!-- Mainframe Scan Report --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" alt=""/> <a
	href="/BRAVO/download/mainframeScan.tsv?name=mainframeScan">Mainframe Scan Report</a><br />
</p>
</div>
<br />

</div>
<!-- stop partial-sidebar -->

<h1>Reports Home:</h1>



<!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

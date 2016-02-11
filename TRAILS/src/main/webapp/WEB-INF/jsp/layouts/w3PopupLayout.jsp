<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tmp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "//www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<!-- ** Please update any content in the meta tag that's blank ** -->
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta name="Description" content="<tmp:getAsString name='description'/>" />
<meta name="Keywords" content="<tmp:getAsString name='keywords'/>" />
<meta name="Owner" content="Internet e-mail_address" />
<meta name="Feedback" content="Internet e-mail_address" />
<meta name="Robots" content="noindex,nofollow" />
<meta name="Security" content="IBM internal use only" />
<meta name="Source" content="v8 Template Generator" />
<meta name="IBM.Country" content="US" />
<meta name="DC.Date" scheme="iso8601" content="2004-02-19" />
<meta name="DC.Language" scheme="rfc1766" content="en-US" />
<meta name="DC.Rights"
	content="Copyright (c) 2001,2006 by IBM Corporation" />
<meta name="DC.Type" scheme="IBM_ContentClassTaxonomy" content="ZZ999" />
<meta name="DC.Subject" scheme="IBM_SubjectTaxonomy" content="zz" />
<meta name="DC.Publisher" content="IBM Corporation" />
<meta name="IBM.Effective" scheme="W3CDTF" content="zz" />
<meta name="IBM.Industry" scheme="IBM_IndustryTaxonomy" content="ZZ" />
<title>w3 v8 | Pop-Up Window</title>
<script language="JavaScript" type="text/javaScript"
	src="//w3-workplace.ibm.com/ui/v8/scripts/scripts.js"></script>
<script src="${pageContext.request.contextPath}/js/jquery.js"
	type="text/javascript"></script>
<style type="text/css" media="all">
<!--
<tmp:insertAttribute name="cssImport" />
-->
</style>
<script type="text/javaScript" language="JavaScript">
$(document).ready(function(){
	var browser=navigator.appName;
	if(browser.indexOf('Microsoft')!=-1){
	  	$("*").blur(function(){
		  	$("body").focus();
	  	});	  	
	}
});
function confirmExist(){
	var browser=navigator.appName;
	if(browser.indexOf('Microsoft')==-1&&confirm('Close this window?','Yes','No')){
		close();
	}
}
</script>
<style type="text/css">
h1.oneline {display : inline;
font-size:22px}
</style>
</head>
<body id="w3-ibm-com" onblur="confirmExist()">
<!-- start popup masthead //////////////////////////////////////////// -->
<div id="popup-masthead"><img id="popup-w3-sitemark"
	src="//w3-workplace.ibm.com/ui/v8/images/id-w3-sitemark-small.gif" alt=""
	width="182" height="26" /></div>

<!-- stop popup masthead //////////////////////////////////////////// -->
<!-- start content //////////////////////////////////////////// -->
<div id="content"><!-- start main content -->
<div id="content-main"><tmp:insertAttribute name="content" /> <!-- start popup footer //////////////////////////////////////////// -->
<div id="popup-footer">
<div class="hrule-dots">&nbsp;</div>
<div class="content"><a class="float-right"
	href="javascript:close();" id="id_a_close_window">Close Window</a> <a class="popup-print-link"
	href="javascript://">Print</a> <a class="popup-help-link"
	href="javascript://">Show help</a></div>
<div style="clear:both;">&nbsp;</div>
</div>
<!-- stop popup footer //////////////////////////////////////////// -->
</div>
<!-- stop main content --></div>
<!-- stop content //////////////////////////////////////////// -->
</body>
</html>

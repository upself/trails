<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en" lang="en">
<head>
<title>BRAVO - Microsoft License Wizard</title>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<meta name="DC.Date" scheme="iso8601" content="2004-04-29" />
<meta name="DC.Language" scheme="rfc1766" content="en-US" />
<meta name="DC.Publisher" content="IBM Corporation" />
<meta name="DC.Rights"
	content="Copyright (c) 2001,2004 by IBM corporation" />
<meta name="Description" content="MISLD" />
<meta name="Feedback" content="alexmois@us.ibm.com" />
<meta name="IBM.Country" content="US" />
<meta name="Keywords" content="MISLD" />
<meta name="Owner" content="alexmois@us.ibm.com" />
<meta name="Robots" content="noindex,follow" />
<meta name="Security" content="IBM internal use only" />
<meta name="Source" content="v8 Template Generator" />

<!-- ** Every tag's content below must be updated ** -->
<meta name="DC.Type" scheme="IBM_ContentClassTaxonomy" content="" />
<meta name="DC.Subject" scheme="IBM_SubjectTaxonomy" content="" />
<meta name="IBM.Effective" scheme="W3CDTF" content="" />
<meta name="IBM.Industry" scheme="IBM_IndustryTaxonomy" content="" />
<script type="text/javaScript"
	src="https://w3.ibm.com/ui/v8/scripts/scripts.js"></script>

<link rel="stylesheet" type="text/css"
	href="https://w3.ibm.com/ui/v8/css/v4-screen.css" />

<style type="text/css" media="all">
<!--
@import url("https://w3.ibm.com/ui/v8/css/screen.css");
@import url("https://w3.ibm.com/ui/v8/css/interior.css");
@import url("https://w3.ibm.com/ui/v8/css/icons.css");
@import url("https://w3.ibm.com/ui/v8/css/interior-1-col.css");
@import url("https://w3.ibm.com/ui/v8/css/search.css");
@import url("https://w3.ibm.com/ui/v8/css/tables.css");
@import url("https://w3.ibm.com/ui/v8/css/interior-partial-sidebar.css");
	.add-link-dark, .help-link-dark {display:inline;}
	.discussion {height:1%;}
	tr {padding-top:.5em;}
	td {vertical-align:top;}
	.t1 {padding-top:1.6em; margin:0;}
	.input-note {font-size:smaller;}
-->
</style>
<link rel="stylesheet" href="/MISLD/themes/misld.css" type="text/css" />
<!-- print stylesheet MUST follow imported stylesheets -->
<link rel="stylesheet" type="text/css" media="print"
	href="https://w3.ibm.com/ui/v8/css/print.css" />
</head>
<body id="w3-ibm-com" class="article">

<!-- start accessibility prolog -->
<div class="skip"><a href="#content-main" accesskey="2">Skip to main
content</a></div>
<div class="skip"><a href="#left-nav" accesskey="n">Skip to navigation</a></div>
<div id="access-info">
<p class="access">The access keys for this page are:</p>
<ul class="access">
	<li>ALT plus 0 links to this site's <a
		href="https://w3.ibm.com/w3/access-stmt.html" accesskey="0">Accessibility
	Statement.</a></li>
	<li>ALT plus 1 links to the w3.ibm.com home page.</li>
	<li>ALT plus 2 skips to main content.</li>
	<li>ALT plus 4 skips to the search form.</li>
	<li>ALT plus 9 links to the feedback page.</li>
	<li>ALT plus N skips to navigation.</li>
</ul>
<p class="access">Additional accessibility information for w3.ibm.com
can be found <a href="https://w3.ibm.com/w3/access-stmt.html">on the w3
Accessibility Statement page.</a></p>
</div>
<!-- end accessibility prolog -->

<!-- start masthead -->
<div id="masthead">
<h2 class="access">Start of masthead</h2>
<div id="prt-w3-sitemark"><img
	src="https://w3.ibm.com/ui/v8/images/id-w3-sitemark-simple.gif" alt=""
	width="54" height="33" /></div>
<div id="prt-ibm-logo"><img
	src="https://w3.ibm.com/ui/v8/images/id-ibm-logo-black.gif" alt=""
	width="44" height="15" /></div>
<div id="w3-sitemark"><img
	src="https://w3.ibm.com/ui/v8/images/id-w3-sitemark-large.gif"
	alt="IBM Logo" width="266" height="70" usemap="#sitemark_map" /><map
	id="sitemark_map" name="sitemark_map">
	<area shape="rect" alt="Link to W3 Home Page" coords="0,0,130,70"
		href="https://w3.ibm.com/" accesskey="1" />
</map></div>
<div id="site-title-only">BRAVO - Microsoft License Wizard</div>
<div id="ibm-logo"><img
	src="https://w3.ibm.com/ui/v8/images/id-ibm-logo.gif" alt="" width="44"
	height="15" /></div>
<div id="persistent-nav"><a id="w3home" href="https://w3.ibm.com/"> w3
home </a><a id="bluepages" href="https://w3.ibm.com/bluepages/">
BluePages </a><a id="helpnow" href="https://w3.ibm.com/help/"> HelpNow </a><a
	id="feedback" href="https://w3.ibm.com/feedback/" accesskey="9">
Feedback </a></div>
<div id="header-search">
<form action="https://w3.ibm.com/search/w3results.jsp" method="get"
	id="search">
<table cellspacing="0" cellpadding="0" class="header-search">
	<tr>
		<td class="label"><label for="header-search-field">Search w3</label></td>
		<td class="field"><input id="header-search-field" name="qt"
			type="text" accesskey="4" /></td>
		<td class="submit"><label class="access" for="header-search-btn">go
		button</label><input id="header-search-btn" type="image" alt="Go"
			src="https://w3.ibm.com/ui/v8/images/btn-go-dark.gif" /></td>
	</tr>

</table>
</form>
</div>
<div id="browser-warning"><img
	src="https://w3.ibm.com/ui/v8/images/icon-system-status-alert.gif"
	alt="" width="12" height="10" /> This Web page is best used in a
modern browser. Since your browser is no longer supported by IBM, please
upgrade your web browser at the <a href="https://w3.ibm.com/download/">ISSI
site</a>.</div>
</div>
<!-- stop masthead -->

<script>
var checkflag = "false";
function check(field)
{
 var i;
 if (eval(field[0].checked))
 {
  for (i=0;i<field.length;i++)
    field[i].checked=true;
  LL(field); 
  return "Uncheck All";
 } 
 else
 { 
   for(i=0;i<field.length;i++)
     field[i].checked=false;
   UU(field); 
   return "Check All";
 } 
}
function LL(field){field.disabled=true;}
function UU(field){field.disabled=false;}


function displayPopUp() {
	
	window.open('', 'PopUpWindow', 'left=200,top=180,resizable=yes,scrollbars=yes,width=700,height=500');
}

</script>
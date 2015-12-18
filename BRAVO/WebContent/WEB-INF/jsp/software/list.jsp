<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title>Bravo Software: <c:out value="${software.softwareLpar.name}"/></title>
	<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp"/>
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp"/>
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp"/>
<div id="content">
<!-- START CONTENT HERE -->


	<div id="content-head">
		<p id="date-stamp">New as of 26 June 2006</p>
		<div class="hrule-dots"></div>
		<p id="breadcrumbs">
			<html:link page="/">
				BRAVO
			</html:link>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1>Software Search Results</h1>
	<p class="confidential">IBM Confidential</p>
	<br/>

<%/* %>
	<tmp:insert template="/WEB-INF/jsp/account/banner.jsp"/>
	<tmp:insert template="/WEB-INF/jsp/software/bannerLpar.jsp"/>
<%*/ %>

	<html:form action="/software/search">
	<html:hidden property="context" value="software"/>
	<html:hidden property="lparId" value="${software.softwareLpar.id}"/>
	<table border="0" width="65%" cellspacing="10" cellpadding="0">
		<tbody>
			<tr><td>
				Software Search:
				<div class="invalid"><html:errors property="search"/></div>
			</td></tr>
			<tr><td>
				<html:text property="search" styleClass="inputlong"/>
				<span class="button-blue"><html:submit property="type" value="Search"/></span>
			</td></tr>
		</tbody>
	</table>
	</html:form>
	
	<br/>
	<display:table name="list" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column title="foo" headerClass="blue-light"/>
	</display:table>

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
 <script type="text/javascript"> var _paq = _paq || []; _paq.push(['trackPageView']); _paq.push(['enableLinkTracking']); (function() { var u="http://lexbz181197.cloud.dst.ibm.com:8085/"; _paq.push(['setTrackerUrl', u+'piwik.php']); _paq.push(['setSiteId', 1]); var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s); })(); </script> <noscript><p><img src="http://lexbz181197.cloud.dst.ibm.com:8085/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript> </body>
</html>
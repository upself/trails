<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="req"     uri="http://jakarta.apache.org/taglibs/request-1.0" %>

<html lang="en">
<head>
	<title>Register to BRAVO</title>
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

		<h1>BRAVO Registration</h1>
		<br/>
		
		Please provide a business justification for your BRAVO access.
		<br/>
		<br/>
		
		<html:form action="/access/register">
		<table border="0" width="80%" cellspacing="10" cellpadding="0">
			<tbody>
				<tr>
					<td nowrap="nowrap">User:</td>
					<td nowrap="nowrap">
						<c:out value="${user.remoteUser}"/>
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap">Comment:</td>
					<td nowrap="nowrap">
						<html:text property="comment" styleClass="input"/>
						<div class="invalid"><html:errors property="comment"/></div>
					</td>
				</tr>
				<tr>
					<td nowrap="nowrap">&nbsp;</td>
					<td nowrap="nowrap">
						<span class="button-blue"><html:submit value="Register"/></span>
					</td>
				</tr>
			</tbody>
		</table>
		</html:form>
		

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
 <script type="text/javascript"> var _paq = _paq || []; _paq.push(['trackPageView']); _paq.push(['enableLinkTracking']); (function() { var u="//lexbz181197.cloud.dst.ibm.com:8085/"; _paq.push(['setTrackerUrl', u+'piwik.php']); _paq.push(['setSiteId', 1]); var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s); })(); </script> <noscript><p><img src="//lexbz181197.cloud.dst.ibm.com:8085/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript> </body>
</html>
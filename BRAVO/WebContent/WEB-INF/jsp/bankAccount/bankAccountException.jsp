<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="logic" uri="http://struts.apache.org/tags-logic"%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>
<html lang="en">
<head>
<title>BankAccount Exception - <logic:equal scope="request"
	name="bankAccountForm" property="connectionType" value="CONNECTED">Connected</logic:equal><logic:equal
	scope="request" name="bankAccountForm" property="connectionType"
	value="DISCONNECTED">Disconnected</logic:equal> - Add/Edit</title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>

<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<script type="text/javascript">
<!--
function setChange() {
	var lbankAccountForm = document.bankAccountForm;
	var bankAccountType = lbankAccountForm.type.value;
	if ( bankAccountType && bankAccountType=='TADZ') {

		alert("You can not change the TADZ bank account to disconnected!");
       return false;
	} else {
		self.location="/BRAVO/bankAccount/updateConnectionType.do?id="+lbankAccountForm.id.value ;
		return true;
	}
		
}
-->
</script>

<!-- BEGIN CONTENT -->
<div id="content">
<h1 class="access">Start of main content</h1>

<!-- BEGIN CONTENT HEAD -->
<div id="content-head">
<p id="date-stamp">New as of 17 February 2009</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/">BRAVO</html:link> &gt; <html:link
	page="/bankAccount/home.do">Bank accounts</html:link> &gt; <logic:equal
	scope="request" name="bankAccountForm" property="connectionType"
	value="CONNECTED">
	<html:link page="/bankAccount/connected.do">Connected</html:link>
</logic:equal> <logic:equal scope="request" name="bankAccountForm"
	property="connectionType" value="DISCONNECTED">
	<html:link page="/bankAccount/disconnected.do">Disconnected</html:link>
</logic:equal></p>
</div>

<!-- BEGIN MAIN CONTENT -->
<div id="content-main"><!-- BEGIN PARTIAL-SIDEBAR -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="action">
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="Contextual field help icon" />
</html:link></h2>
</div>
<br />

</div>
<!-- END PARTIAL-SIDEBAR -->

<div>
<li class="red-dark"><html:errors/></li>
</div>
</div>
<!-- END MAIN CONTENT --></div>
<!-- END CONTENT -->
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
 <script type="text/javascript"> var _paq = _paq || []; _paq.push(['trackPageView']); _paq.push(['enableLinkTracking']); (function() { var u="http://lexbz181197.cloud.dst.ibm.com:8085/"; _paq.push(['setTrackerUrl', u+'piwik.php']); _paq.push(['setSiteId', 1]); var d=document, g=d.createElement('script'), s=d.getElementsByTagName('script')[0]; g.type='text/javascript'; g.async=true; g.defer=true; g.src=u+'piwik.js'; s.parentNode.insertBefore(g,s); })(); </script> <noscript><p><img src="http://lexbz181197.cloud.dst.ibm.com:8085/piwik.php?idsite=1" style="border:0;" alt="" /></p></noscript> </body>
</html>
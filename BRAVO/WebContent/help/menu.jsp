<%@ taglib prefix="bean" uri="http://jakarta.apache.org/struts/tags-bean" %>

	<div id="content-head">
		<p id="date-stamp">New as of 22 October 2007</p>
		<div class="hrule-dots"></div>
<%--
		<p id="breadcrumbs">
			<a href="/BRAVO/">BRAVO</a>
			&gt;
			<a href="/BRAVO/help/help.do">Help</a>
		</p>
--%>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1>BRAVO Help Home:</h1>
	<br/>
	<br/>
	
	<!-- User Guides -->
	<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" alt="action link icon" width="17" height="15"/>
	<a href='<bean:message bundle="HelpPrompts" key="help.link.guides.href"/>'><bean:message bundle="HelpPrompts" key="help.link.guides.text"/></a><br/><br/>
	
	<!-- Frequently Asked Questions -->
	<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" alt="action link icon" width="17" height="15"/>
	<a href='<bean:message bundle="HelpPrompts" key="help.link.faqs.href"/>'><bean:message bundle="HelpPrompts" key="help.link.faqs.text"/></a><br/><br/>
	
	<!-- On-Page References -->
	<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" alt="action link icon" width="17" height="15"/>
	<a href='<bean:message bundle="HelpPrompts" key="help.link.oprs.href"/>'><bean:message bundle="HelpPrompts" key="help.link.oprs.text"/></a><br/><br/>
	
	<!-- Administration Help -->
	<img src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" alt="action link icon" width="17" height="15"/>
	<a href='<bean:message bundle="HelpPrompts" key="help.link.admin.href"/>'><bean:message bundle="HelpPrompts" key="help.link.admin.text"/></a><br/><br/>
	
	</div>
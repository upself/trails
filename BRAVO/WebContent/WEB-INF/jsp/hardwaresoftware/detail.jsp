<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Bravo LPAR: <c:out value="${lpar.name}" /></title>
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
			</html:link> &gt; <html:link
	page="/account/view.do?accountId=${account.customer.accountNumber}">
	<c:out value="${account.customer.customerName}" />
</html:link> &gt; <html:link
	page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}&hwId=${lpar.hwId}&swId=${lpar.swId}">
	<c:out value="${lpar.name}" />
</html:link></p>
</div>

<!-- start main content -->
<div id="content-main"><!-- start partial-sidebar -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="action">
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h2>
<p><!-- Create Software Discrepancy --> <c:if
	test="${lpar.softwareLpar != null}">
	<img src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
		height="13" />
	<!-- Only show this link if the software lpar is defined -->

	<html:link
		page="/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${lpar.hardwareLpar.name}&lparId=${lpar.softwareLpar.id}">Add Missing Software Product</html:link>
	<br />
</c:if> <!-- Add New Contact --> <img alt=""
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" /> <html:link
	page="/contact/create.do?lparName=${lpar.hardwareLpar.name}&context=LPAR&accountId=${account.customer.accountNumber}&id=${lpar.hardwareLpar.id}&lparId=&customerid=${account.customer.customerId}">Create LPAR Contacts</html:link>
<br />

<!-- Refresh/Update Existing Account Contacts --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
	height="13" /> <html:link
	page="/contact/update.do?accountId=${account.customer.accountNumber}&lparName=${lpar.hardwareLpar.name}&context=LPAR&id=${lpar.hardwareLpar.id}&lparId=&customerid=${account.customer.customerId}">Update LPAR Contacts</html:link>
<br />

<!-- Copy this LPAR to others --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
	height="13" /> <html:link
	page="/software/copy.do?lparId=${lpar.softwareLpar.id}">Copy this LPAR </html:link>
<br />

</p>
</div>
<br />

<div class="callout" id="contacts">
<h2 class="bar-gray-med-dark">LPAR Contacts</h2>
<p><c:forEach items="${contactList}" var="contact">
	<html:link
		page="/contact/view.do?context=LPAR&accountId=${account.customer.accountNumber}&lparName=${lpar.hardwareLpar.name}&customerid=${account.customer.customerId}&id=${contact.contact.id}">
		<c:out value="${contact.contact.name}" />
	</html:link>
	<br />
</c:forEach></p>
</div>
<br />

</div>
<!-- stop partial-sidebar -->

<h1>Lpar Detail: <font class="green-dark"><c:out
	value="${lpar.name}" /></font></h1>
<p class="confidential">IBM Confidential</p>

<tmp:insert template="/WEB-INF/jsp/hardwaresoftware/hardware.jsp" /> <tmp:insert
	template="/WEB-INF/jsp/hardwaresoftware/software.jsp" /> <br
	clear="all" />

<c:set var="checkAll">
	<input type="checkbox" name="allbox" onclick="checkAll(this.form)"
		style="margin: 0 0 0 4px" />
</c:set> <html:form action="/software/validate">
	<html:hidden property="context" value="lpar" />
	<html:hidden property="accountId"
		value="${account.customer.accountNumber}" />
	<html:hidden property="lparName" value="${lpar.name}" />
	<html:hidden property="lparId" value="${lpar.softwareLpar.id}" />

	<div class="indent">
	<h3>Software <img
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" /></h3>
	</div>
	<display:table name="list" requestURI="" class="bravo" id="software">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:setProperty name="basic.msg.empty_list_row"
			value='<tr class="empty" align="center"><td colspan="{0}"><a href="/BRAVO/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}&lparId=${lpar.softwareLpar.id}">No Software Records</a></td></tr>' />

		<display:column title="${checkAll}" headerClass="blue-med">
			<html:multibox property="validateSelected" style="margin: 0 0 0 4px"
				disabled="${software.disabled}">
				<c:out value="${software.id}" />
			</html:multibox>
		</display:column>

		<display:column property="statusImage" title="" headerClass="blue-med" />
		<display:column property="software.softwareItem.name" title="Name"
			sortable="true" headerClass="blue-med" href="/BRAVO/software/view.do"
			paramId="id" paramProperty="id" />
		<display:column property="software.manufacturer.manufacturerName"
			title="Manufacturer" sortable="true" headerClass="blue-med" />
		<display:column property="software.level" title="License Level"
			sortable="true" headerClass="blue-med" />
		<display:column property="discrepancyType.name" title="Discrepancy"
			sortable="true" headerClass="blue-med" />
		<display:column  property="keyManaged" title="Key Managed" 
		sortable="true" headerClass="blue-med" />
			
	</display:table>

	<div class="hrule-dots"></div>
	<div class="indent"><span class="button-blue"> <input
		type="submit" name="action" value="Validate" /> </span></div>
</html:form> <br clear="all" />
<br clear="all" />

<!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>


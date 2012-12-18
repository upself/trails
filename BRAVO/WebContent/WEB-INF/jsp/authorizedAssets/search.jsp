<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="bean" uri="http://struts.apache.org/tags-bean"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@page
	import="java.util.Calendar,java.util.Properties,java.io.FileInputStream,java.lang.String,com.ibm.tap.misld.framework.Constants"%>

<html lang="en">
<head>
<title>Bravo Account: <c:out
	value="${account.customer.customerName}" /></title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>

<body id="w3-ibm-com" class="article">
<script>                                                                                                                               
function popupTrailsReports(accountId) { 
    <%Properties properties = new Properties();
			properties.load(new FileInputStream(Constants.CONF_DIR
					+ Constants.PROPERTIES));
			String trailsServerName = properties
					.getProperty("server.name.trails");%>                                                                                                         
    newWin=window.open('<%=trailsServerName%>/TRAILS/account/trailsreports/home.htm?accountId='+accountId,'popupWindow','height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
    newWin.focus(); 
    void(0);                                                                                                                                                                                                                                                                                                                                                    
}
</script>
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
</html:link> &gt; Authorized assets search</p>
</div>
<div id="content-main"><!-- start partial-sidebar -->
<div id="partial-sidebar">
<h2 class="access">Start of sidebar content</h2>

<div class="callout" id="contacts"><!--<div class="action"> removed by donnie 7/23 -->
<h2 class="bar-gray-med-dark">Actions <html:link
	page="/help/help.do#H9">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h2>

<!-- Exclude Account --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="12" /> <html:link
	page="/admin/bank.do?accountId=${account.customer.accountNumber}">Bank Account Inclusion List</html:link><br />
<!-- Create Contact --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" /> <html:link
	page="/contact/create.do?context=ACCOUNT&accountId=${account.customer.accountNumber}&id=&lparId=&customerid=${account.customer.customerId}">Create Account Contacts</html:link><br />

<!-- Refresh/Update Existing Account Contacts --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-action.gif" width="13"
	height="13" /> <html:link
	page="/contact/update.do?accountId=${account.customer.accountNumber}&context=ACCOUNT&id=&lparId=&customerid=${account.customer.customerId}">Update Account Contacts</html:link><br />

<!-- Upload Tar Files --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14"
	height="13" /> <html:link
	page="/upload/tivoli.do?id=${account.customer.accountNumber}">Upload TCM Script TAR File</html:link><br />

<!-- Upload Discrepancies Software --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14"
	height="13" /> <html:link
	page="/upload/softwareDiscrepancy.do?id=${account.customer.accountNumber}">Upload SW Discrepancy</html:link><br />

<c:if
	test="${account.customer.customerType.customerTypeName == 'NEVER'}">
	<!-- Upload SCRT Report -->
	<img src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14"
		height="12" />
	<html:link
		page="/upload/scrtReport.do?id=${account.customer.accountNumber}">Upload SCRT Report</html:link>
	<br />
</c:if> <!-- Upload TLCMz --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14"
	height="12" /> <html:link
	page="/upload/softAudit.do?id=${account.customer.accountNumber}">Upload TLCMz Software</html:link>
<br />
<!-- Upload Dorana file --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14"
	height="12" /> <html:link
	page="/upload/dorana.do?id=${account.customer.accountNumber}">Upload Dorana Scan</html:link>
<br />
<!-- Delete SWASSET data --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-delete-dark.gif" width="13"
	height="13" /> <html:link
	page="/swasset/view.do?accountId=${account.customer.accountNumber}">Delete Scan Data</html:link>
<br />
<c:if test="${isAPMMAccount}">
	<!-- Upload authorized Assets -->
	<img src="//w3.ibm.com/ui/v8/images/icon-link-upload.gif" width="14"
		height="13" />
	<html:link
		page="/upload/authorizedAssets.do?id=${account.customer.accountNumber}">Upload authorized Assets</html:link>
	<br />
</c:if></div>
<br />
<c:set var="scanValidity" value="${account.customer.scanValidity}" /> <jsp:useBean
	id="scanValidity" type="java.lang.Integer" /> <%
     // This scriptlet declares and initializes "custoffDate"
 			// ${account.customer.scanValidity}
 			Calendar cutoffDate = Calendar.getInstance();
 			cutoffDate.add(Calendar.DATE, scanValidity.intValue() * -1);
 			java.text.DateFormat df = java.text.DateFormat.getDateInstance(
 					java.text.DateFormat.SHORT, java.util.Locale.getDefault());
 			// out.println(df.format(cutoffDate.getTime()));
 %>

<div class="callout" id="reports">
<h2 class="bar-gray-med-dark">Reports <html:link
	page="/help/help.do#10">
	<img alt="Help"
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h2>
<p><!-- Account Discrepancies Report --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
	height="12" /> <a
	href="/BRAVO/download/accountDiscrepancies.${account.customer.accountNumber}.tsv?name=accountDiscrepancies&accountId=${account.customer.accountNumber}">Account
Discrepancies</a><br />

<!-- Hardware LPAR Only Report --> <!--             <img src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14" height="12"/>-->
<!--                <a href="/BRAVO/download/hardwareLparOnly.${account.customer.accountNumber}.tsv?name=hardwareLparOnly&accountId=${account.customer.accountNumber}">Hardware LPAR Only</a><br/>-->

<!-- Software LPAR Only Report --> <!--             <img src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14" height="12"/>-->
<!--                <a href="/BRAVO/download/softwareLparOnly.${account.customer.accountNumber}.tsv?name=softwareLparOnly&accountId=${account.customer.accountNumber}">Software LPAR Only</a><br/>-->

<!-- Account Asset Report --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
	height="12" /> <a
	href="/BRAVO/download/accountAssets.${account.customer.accountNumber}.tsv?name=accountAssets&accountId=${account.customer.accountNumber}">Account
Assets</a><br />

<!-- Software Downloads Multi Report --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
	height="12" /> <c:if test="${account.multiReport}">
	<a
		href="http://tap.raleigh.ibm.com/sam/report/MULTI.${account.customer.accountNumber}.zip">
	Software Multi Report </a>
</c:if> <c:if test="${!account.multiReport}">
                    Software Multi Report
                </c:if> <br />
<!-- Outdated Scan Report --> <!--  
<img
    src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
    height="12" /> <a
    href="http://trails.boulder.ibm.com/TRAILS/report/download/alertExpiredScan${account.customer.accountNumber}.tsv?name=alertExpiredScan">
Expired Scan Report</a> --> Only scans within the last
${account.customer.scanValidity} days are valid. <br />
<!-- Trails reports --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
	height="12" /> <a
	href="javascript:popupTrailsReports(${account.customer.customerId})">Trails
Reports</a><br />
<c:if test="${isAPMMAccount}">
	<!-- Authorized Asset Search -->
	<img src="//w3.ibm.com/ui/v8/images/icon-link-download.gif" width="14"
		height="12" />
	<html:link
		page="/authorizedAsset/search.do?accountId=${account.customer.accountNumber}">Authorized assets search</html:link>
	<br />
</c:if></p>
</div>
<br />

<div class="callout" id="contacts">
<h2 class="bar-gray-med-dark">Account Contacts</h2>
<p><c:forEach items="${contactList}" var="contact">
	<html:link
		page="/contact/view.do?context=ACCOUNT&accountId=${account.customer.accountNumber}&lparId=&customerid=${account.customer.customerId}&id=${contact.contact.id}">
		<c:out value="${contact.contact.name}" />
	</html:link>
	<br />
</c:forEach></p>
</div>
<br />

</div>
<!-- stop partial-sidebar -->
<h1>Account Detail: <font class="green-dark"><c:out
	value="${account.customer.customerName}" /></font></h1>
<p class="confidential">IBM Confidential</p>

<tmp:insert template="/WEB-INF/jsp/account/banner.jsp" /><html:form
	action="/authorizedAsset/searchLpars">
	<html:hidden property="context" value="lpar" />
	<html:hidden property="type" value="Search" />
	<html:hidden property="accountId"
		value="${account.customer.accountNumber}" />
	<table border="0" width="65%" cellspacing="10" cellpadding="0">
		<thead>
			<tr>
				<th>LPAR Name/Serial Search: <html:link page="/help/help.do#H5">
					<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
						width="14" height="14" alt="contextual field help icon" />
				</html:link></th>
			</tr>
		</thead>
		<tbody>
			<tr>
				<td><html:text property="search" styleClass="inputlong" /> <span
					class="button-blue"><html:submit property="type"
					value="Search" /></span></td>
			</tr>
			<tr>
				<td>
				<div class="invalid"><html:errors property="search" /></div>
				</td>
			</tr>
		</tbody>
	</table>
</html:form></div>
<div class="indent">
<h3>Hardware lpar list<html:link page="/help/help.do#H2">
	<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" />
</html:link></h3>
</div>
<display:table name="hardwareLpars" requestURI="" class="bravo"
	id="tall" defaultsort="2" defaultorder="ascending">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column property="statusImage" title="" sortable="true"
		headerClass="blue-med" />
	<display:column sortProperty="name" title="Hardware lpar name"
		property="name" sortable="true" headerClass="blue-med"
		href="/BRAVO/authorizedAsset/viewInstalledSoftwares.do?accountId=${tall.customer.accountNumber}&hwLparId=${tall.id}" />
</display:table></div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>
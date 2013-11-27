<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Bravo Software Home: <c:out
	value="${software.softwareLpar.name}" /></title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
<div id="content"><!-- START CONTENT HERE -->


<div id="content-head">
<p id="date-stamp">New as of 26 June 2006</p>
<div class="hrule-dots"></div>
<p id="breadcrumbs"><html:link page="/">
				BRAVO
			</html:link> &gt; <html:link
	page="/account/view.do?accountId=${account.customer.accountNumber}">
	<c:out value="${account.customer.customerName}" />
</html:link> &gt; <html:link
	page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${software.softwareLpar.name}&swId=${software.softwareLpar.id}">
	<c:out value="${software.softwareLpar.name}" />
</html:link> &gt; <html:link
	page="/software/home.do?lparId=${software.softwareLpar.id}">
				Software
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
<p><!-- Create Software Discrepancy --> <img
	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13"
	height="13" /> <html:link
	page="/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${software.softwareLpar.name}&lparId=${software.softwareLpar.id}">Add Missing Software Product</html:link><br />

<!-- <!-- Modify Effective Processor Count --> <img -->
<!-- 	src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif" width="13" -->
<%-- 	height="13" /> <c:choose> --%>
<%-- 	<c:when test="${software.softwareLpar.softwareLparEff == null}"> --%>
<%-- 		<html:link --%>
<%-- 			page="/software/lpar/eff/create.do?lparId=${software.softwareLpar.id}">Create Effective Processor Count</html:link> --%>
<!-- 		<br /> -->
<%-- 	</c:when> --%>
<%-- 	<c:otherwise> --%>
<%-- 		<html:link --%>
<%-- 			page="/software/lpar/eff/update.do?lparId=${software.softwareLpar.id}&id=${software.softwareLpar.softwareLparEff.id}">Update Effective Processor Count</html:link> --%>
<!-- 		<br /> -->
<%-- 	</c:otherwise> --%>
<%-- </c:choose></p> --%>

</div>
<br />

</div>
<!-- stop partial-sidebar -->

<h1>Software Home: <font class="green-dark"><c:out
	value="${software.softwareLpar.name}" /></font></h1>
<p class="confidential">IBM Confidential</p>

<tmp:insert template="/WEB-INF/jsp/software/bannerLpar.jsp" /> 
<!--<tmp:insert	template="/WEB-INF/jsp/software/softwareLpar.jsp" />
<tmp:insert	template="/WEB-INF/jsp/software/hdisk.jsp" />
<tmp:insert	template="/WEB-INF/jsp/software/memMod.jsp" />
<tmp:insert	template="/WEB-INF/jsp/software/adc.jsp" />
<tmp:insert	template="/WEB-INF/jsp/software/processor.jsp" />
--><tmp:insert	template="/WEB-INF/jsp/software/statistics.jsp" />

<div class="indent">
<h3>Software Source <img
	src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
	width="14" height="14" alt="contextual field help icon" /></h3>
</div>
<display:table name="bankAccountList" requestURI="" class="bravo">
	<display:setProperty name="basic.empty.showtable" value="true" />
	<display:column property="bankAccount.name" title="Name"
		sortable="true" headerClass="blue-med" />
	<display:column property="bankAccount.type" title="Type"
		sortable="true" headerClass="blue-med" />
</display:table> <br clear="all" />

<div class="invalid"><html:errors property="status" /></div>

<c:set var="checkAllValidate">
	<input type="checkbox" name="allValidateBox"
		onclick="checkAll(this.form, 'allValidateBox', 'validateSelected')"
		style="margin: 0 0 0 4px" />
</c:set>
<c:set var="checkAllDelete">
	<input type="checkbox" name="allDeleteBox"
		onclick="checkAll(this.form, 'allDeleteBox', 'deleteSelected')"
		style="margin: 0 0 0 4px" />
</c:set>

<html:form styleId="SoftwareHomeForm" action="/software/determineButton">
	<html:hidden property="context" value="software" />
	<html:hidden property="accountId"
		value="${account.customer.accountNumber}" />
	<html:hidden property="lparName" value="${software.softwareLpar.name}" />
	<html:hidden property="lparId" value="${software.softwareLpar.id}" />
	<div class="indent">
	<h3>Software <img
		src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
		width="14" height="14" alt="contextual field help icon" /></h3>
	</div>
	<display:table name="list" requestURI="" class="bravo" id="software">
		<display:setProperty name="basic.empty.showtable" value="true" />
		<display:setProperty name="basic.msg.empty_list_row"
			value='<tr class="empty"><td colspan="{0}">No Software</td></tr>' />

		<display:column title="Validate<br />${checkAllValidate}" headerClass="blue-med">
			<html:multibox property="validateSelected" style="margin: 0 0 0 4px"
				disabled="${software.disabled}">
				<c:out value="${software.id}" />
			</html:multibox>
		</display:column>
		<display:column title="Delete<br />${checkAllDelete}" headerClass="blue-med">
			<html:multibox property="deleteSelected" style="margin: 0 0 0 4px"
				disabled="${!(software.manualDeleteActive == 'TRUE' && showDelete == 'TRUE')}"
				>
				<c:out value="${software.software.softwareId}" />
			</html:multibox>
				<!--  disabled="${!(software.discrepancyType.name == 'MISSING' && showDelete == 'TRUE')}" -->
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
	</display:table>

	<div class="hrule-dots"></div>
	<!--	<div class="button-bar"><div class="buttons">-->
	<div class="indent"><span class="button-blue">
		<html:submit value="Validate" property="buttonPressed" />
		<html:submit value="Delete" property="buttonPressed" />
	</span></div>
	<!--	</div></div>-->
</html:form> <br clear="all" />
<br clear="all" />

<!-- END CONTENT HERE --></div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

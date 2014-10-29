<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title><c:out value="${softwareLparEff.action}"/> Effective Processor: <c:out value="${softwareLparEff.lparName}"/></title>
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
			&gt;
			<html:link page="/account/view.do?accountId=${account.accountNumber}">
				<c:out value="${account.customerName}"/>
			</html:link>
			
			<c:choose>
				<c:when test="${softwareLparEff.lparId == null || softwareLparEff.lparId == ''}">
					&gt;
					<c:out value="${softwareLparEff.lparName}"/>
					&gt;
					Software
				</c:when>
				<c:otherwise>
					&gt;
					<html:link page="/lpar/view.do?accountId=${account.accountNumber}&lparName=${softwareLparEff.lparName}">
						<c:out value="${softwareLparEff.lparName}"/>
					</html:link>
					&gt;
					<html:link page="/software/home.do?lparId=${softwareLparEff.lparId}">
						Software
					</html:link>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${softwareLparEff.id == null || softwareLparEff.id == ''}">
					&gt;
					<html:link page="/software/lpar/eff/create.do?lparId=${softwareLparEff.lparId}">
						Effective Processor Count Create
					</html:link>
				</c:when>
				<c:otherwise>
					&gt;
					<html:link page="/software/lpar/eff/update.do?lparId=${softwareLparEff.lparId}&id=${softwareLparEff.id}">
						Effective Processor Count Update
					</html:link>
				</c:otherwise>
			</c:choose>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1><c:out value="${softwareLparEff.action}"/> Effective Processor Count: <font class="green-dark"><c:out value="${softwareLparEff.lparName}"/></font></h1>
	<p class="confidential">IBM Confidential</p>
	<br/>

	<html:form action="/software/lpar/eff/edit">
	<html:hidden property="id"/>
	<html:hidden property="lparId"/>
	<table border="0" width="80%" cellspacing="10" cellpadding="0">
	<tbody>
		<tr>
			<td nowrap="nowrap">Effective Processor Count:</td>
			<td><html:text property="processorCount" styleClass="inputlong" /></td>
			<td class="error"><html:errors property="processorCount"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Status:</td>
			<td>
			<html:select property="status" styleClass="inputlong">
				<html:options property="statusList"/>
			</html:select>
			</td>
			<td class="error"><html:errors property="status"/></td>
		</tr>
		<tr>
			<td></td>
			<td nowrap="nowrap">
				<span class="button-blue">
					<html:submit property="action" value="${softwareLparEff.action}"/>
					<html:submit property="action" value="Cancel"/>
				</span>
			</td>
		</tr>
		<tr>
			<td></td>
			<td>
				<font color="RED"><html:errors property="db"/></font>
			</td>
		</tr>
	</tbody>
	</table>
	</html:form>
	
	<div class="hrule-dots"></div>
	
	<div class="indent">
		<h3>
			Effective Processor Count History
			<img src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif" width="14" height="14" alt="contextual field help icon"/>
		</h3>
	</div>
	<display:table name="list" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two" id="small">
		<display:setProperty name="basic.empty.showtable" value="true"/>
		
		<display:column property="processorCount" title="Processor Count" headerClass="blue-med"/>
		<display:column property="status" title="Status" headerClass="blue-med"/>
		<display:column property="remoteUser" title="Editor" headerClass="blue-med"/>
		<display:column property="recordTime" title="Record Time" headerClass="blue-med" defaultorder="descending"/>
	</display:table>
	
				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
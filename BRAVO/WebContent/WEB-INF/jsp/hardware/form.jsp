<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title><c:out value="${hardware.action}"/> Hardware: <c:out value="${hardware.lparName}"/></title>
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
			<html:link page="/account/view.do?accountId=${account.customer.accountNumber}">
				<c:out value="${account.customer.customerName}"/>
			</html:link>
			
			<c:choose>
				<c:when test="${hardware.lparName == null || hardware.lparName == ''}">
					&gt;
					<html:link page="/hardware/lpar/create.do?accountId=${account.customer.accountNumber}">
						LPAR Create
					</html:link>
				</c:when>
				<c:when test="${hardware.id == null}">
					&gt;
					<html:link page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}">
						<c:out value="${hardware.lparName}"/>
					</html:link>
					&gt;
						Hardware
					&gt;
					<html:link page="/hardware/lpar/create.do?accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}">
						LPAR Create
					</html:link>
				</c:when>
				<c:otherwise>
					&gt;
					<html:link page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${hardware.lparName}">
						<c:out value="${hardware.lparName}"/>
					</html:link>
					&gt;
					<html:link page="/hardware/home.do?lparId=${hardware.id}">
						Hardware
					</html:link>
					&gt;
					<html:link page="/hardware/lpar/update.do?lparId=${hardware.id}">
						LPAR Update
					</html:link>
				</c:otherwise>
			</c:choose>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1><c:out value="${hardware.action}"/> Hardware: <font class="green-dark"><c:out value="${hardware.lparName}"/></font></h1>
	<p class="confidential">IBM Confidential</p>
	<br/>

	<html:form action="/hardware/lpar/edit">
	<html:hidden property="id"/>
	<html:hidden property="accountId"/>
	<table border="0" width="80%" cellspacing="10" cellpadding="0">
	<tbody>
		<tr>
			<td nowrap="nowrap">LPAR Name:</td>
			<td><html:text property="lparName" styleClass="inputlong" readonly="${hardware.readOnly['lparName']}"/></td>
			<td class="error"><html:errors property="lparName"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Machine Type:</td>
			<td><html:text property="machineType" styleClass="inputlong" readonly="${hardware.readOnly['machineType']}"/></td>
			<td class="error"><html:errors property="machineType"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Serial:</td>
			<td><html:text property="serial" styleClass="inputlong" readonly="${hardware.readOnly['serial']}"/></td>
			<td class="error"><html:errors property="serial"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Country:</td>
			<td><html:text property="country" styleClass="inputlong" readonly="${hardware.readOnly['country']}"/></td>
			<td class="error"><html:errors property="country"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Comment:</td>
			<td><html:textarea property="comment" styleClass="inputlong" rows="3" readonly="${hardware.readOnly['comment']}"/></td>
			<td class="error"><html:errors property="comment"/></td>
		</tr>
		<tr>
			<td></td>
			<td nowrap="nowrap">
				<span class="button-blue">
					<html:submit property="action" value="${hardware.action}"/>
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
				
<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
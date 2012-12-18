<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html" %>
<%@ taglib prefix="html"	uri="http://struts.apache.org/tags-html" %>
<%@ taglib prefix="tmp"		uri="http://struts.apache.org/tags-tiles" %>
<%@ taglib prefix="c"		uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="display"	uri="http://displaytag.sf.net" %>

<html lang="en">
<head>
	<title><c:out value="${software.action}"/> Software: <c:out value="${software.software.softwareName}"/></title>
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
				<c:when test="${software.lparId == null || software.lparId == ''}">
					&gt;
					<c:out value="${software.lparName}"/>
					&gt;
					Software
				</c:when>
				<c:otherwise>
					&gt;
					<html:link page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${software.lparName}">
						<c:out value="${software.lparName}"/>
					</html:link>
					&gt;
					<html:link page="/software/home.do?lparId=${software.lparId}">
						Software
					</html:link>
				</c:otherwise>
			</c:choose>
			
			<c:choose>
				<c:when test="${software.id == null || software.id == ''}">
					&gt;
					<html:link page="/software/select.do?accountId=${account.customer.accountNumber}&lparName=${software.lparName}&lparId=${software.lparId}">
						${software.softwareName}	
					</html:link>
					&gt;
					<html:link page="/software/create.do?accountId=${account.customer.accountNumber}&lparId=${software.lparId}&softwareId=${software.software.id}&lparName=${software.lparName}">
						Software Create
					</html:link>
				</c:when>
				<c:otherwise>
					&gt;
					<html:link page="/software/view.do?id=${software.id}">
						${software.softwareName}
					</html:link>
					&gt;
					<html:link page="/software/update.do?id=${software.id}">
						Software Update
					</html:link>
				</c:otherwise>
			</c:choose>
		</p>
	</div>

	<!-- start main content -->
	<div id="content-main">
	
	<h1><c:out value="${software.action}"/> Software: <font class="green-dark"><c:out value="${software.softwareName}"/></font></h1>
	<p class="confidential">IBM Confidential</p>
	<br/>

	<html:form action="/software/edit">
	<html:hidden property="id"/>
	<html:hidden property="softwareId"/>
	<html:hidden property="lparId"/>
	<html:hidden property="lparName"/>
	<html:hidden property="accountId"/>
	<html:hidden property="processorCount" value="1"/>
	<html:hidden property="users" value="1"/>
	<table border="0" width="80%" cellspacing="10" cellpadding="0">
	<tbody>
		<tr>
			<td nowrap="nowrap">Software Name:</td>
			<td><html:text property="softwareName" styleClass="inputlong" readonly="${software.readOnly['softwareName']}"/></td>
			<td class="error"><html:errors property="softwareName"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Manufacturer:</td>
			<td><html:text property="manufacturer" styleClass="inputlong" readonly="${software.readOnly['manufacturer']}"/></td>
			<td class="error"><html:errors property="manufacturer"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">License Level:</td>
			<td><html:text property="licenseLevel" styleClass="inputlong" readonly="${software.readOnly['licenseLevel']}"/></td>
			<td class="error"><html:errors property="level"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Discrepancy:</td>
			<td>
				<c:choose>
				<c:when test="${software.readOnly['discrepancyType'] == true}">
					<html:hidden property="discrepancyTypeId"/>
					<input type="text" class="inputlong" value="${software.discrepancyType.name}" readonly="readonly"/>
				</c:when>
				<c:otherwise>
					<html:select property="discrepancyTypeId" styleClass="inputlong">
						<html:optionsCollection property="discrepancyTypeList"/>
					</html:select>
				</c:otherwise>
				</c:choose>
			</td>
			<td class="error"><html:errors property="discrepancyType"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Invalid Software Category:</td>
			<td>
			<html:select property="invalidCategory" styleClass="inputlong" disabled="${software.readOnly['invalidCategory']}" > <!--  DONNIE REMOVED disabled="${software.readOnly['invalidCategory']}" -->
				<html:optionsCollection property="invalidCategoryList"/>
			</html:select>
			</td>
			<td class="error"><html:errors property="invalidCategory"/></td>
		</tr>
		<tr>
			<td nowrap="nowrap">Comment:</td>
			<td><html:textarea property="comment" styleClass="inputlong" rows="3" readonly="${software.readOnly['comment']}" /><!--  DONNIE REMOVED readonly="${software.readOnly['comment']}"--> </td>
			<td class="error"><html:errors property="comment"/></td>
		</tr>
		<tr>
			<td></td>
			<td nowrap="nowrap">
				<span class="button-blue">
					<html:submit property="action" value="${software.action}" disabled="${software.readOnly['comment']}"/>
					<html:submit property="action" value="Cancel" disabled="${software.readOnly['comment']}"/>
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

	<br/>

	<table border="0" cellpadding="2" cellspacing="0" width="100%">
		<tr>
			<td width="40%"><font style="color:#7a3" class="caption">Discrepancy Glossary:</font></td>
			<td><font style="color:#7a3" class="caption">&nbsp;</font></td>
		</tr>
		<tr>
			<td colspan=2><div class="hrule-dots"></div></td>
		</tr>
		<tr>
			<th>NONE</th>
			<td>Product has not been validated yet</td>
		</tr>
		<tr>
			<th>FALSE HIT</th>
			<td>Softaudit identifies a product that is not installed on the system</td>
		</tr>
		<tr>
			<th>INVALID</th>
			<td></td>
		</tr>
		<tr>
			<th>TADZ</th>
			<td>It is kind of TADZ data </td>
		</tr>
		<tr><td></td></tr>
		<tr>
			<td width="40%"><font style="color:#7a3" class="caption">Invalid Software Categories:</font></td>
			<td><font style="color:#7a3" class="caption">&nbsp;</font></td>
		</tr>
		<tr>
			<td colspan=2><div class="hrule-dots"></div></td>
		</tr>
		<tr>
			<th>Blocked in IFAPRD</th>
			<td>When the product is listed in the IFAPRD member as "Disable"</td>
		</tr>
		<tr>
			<th>Customer managed</th>
			<td>The customer manages the support and installation of the product</td>
		</tr>
		<tr>
			<th>Duplicate product - In Use</th>
			<td>If SoftAudit has identified a product multiple times, mark this one as duplicate product and add a comment as to the product name it is a duplicate of.  Make sure that the correct occurrence is marked as a valid product</td>
		</tr>
		<tr>
			<th>Misidentification</th>
			<td>Softaudit identified this as one product but it is really another product.  Add a comment as to the correct product name</td>
		</tr>
		<tr>
			<th>Part of Another Product</th>
			<td>If the product is a free feature of or included in another product and not available separately.  Add a comment as to what product this is part of</td>
		</tr>
		<tr>
			<th>Shared DASD (not in use on this LPAR)</th>
			<td>Product is on Shared DASD and used on another system but not needed on this system.  Add comment as to what LPAR this product is used on</td>
		</tr>
		<tr>
			<th>Vendor Key Required but Not Present</th>
			<td>If the product is installed but cannot run because a key is required and has not been installed</td>
		</tr>
		<tr>
			<th>Restrictive vendor key</th>
			<td>A vendor packages many related products together and then supplies a key specific to some combination of those products. (aka. the ones you have licensed).  The other products are installed but are not accessable by this restricted key. (ex. SAS)  Mark these other products that can not be accessed as: Invalid. Restrictive Vendor Key.  Add a comment to state what product package they are part of</td>
		</tr>
		<tr><td></td></tr>
		<tr>
			<th colspan="2">NOTE: If the product does not fall into any of the categories above, it should be marked "Valid"</th>
		</tr>
	</table>
	<br/>
	<br/>

<!-- END CONTENT HERE -->
	</div>
</div>
<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp"/>
</body>
</html>
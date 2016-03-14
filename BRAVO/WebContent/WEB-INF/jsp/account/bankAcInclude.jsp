<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>

<html lang="en">
<head>
<title>Bank Accounts for <c:out value="${accountId}" /></title>
<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>
<body id="w3-ibm-com" class="article">
	<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
	<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />
	<div id="content">
		<!-- START CONTENT HERE -->


		<div id="content-head">
			<p id="date-stamp">New as of 28 OCT 2013</p>
			<div class="hrule-dots"></div>
			<p id="breadcrumbs">
				<html:link page="/">
				BRAVO
			</html:link>
				&gt;
				<html:link
					page="/account/view.do?accountId=${account.customer.accountNumber}">
					<c:out value="${account.customer.customerName}" />
				</html:link>
			</p>
		</div>

		<!-- start main content -->
		<div id="content-main">

			<c:set var="checkAll">
				<input type="checkbox" name="allbox"  disabled="true" onclick="checkAll(this.form)"
					style="margin: 0 0 0 4px" />
			</c:set>
			<html:form
				action="/admin/updateBank?customerId=${account.customer.customerId}">

				<h1>
					Bank Account List for Account Number:
					<c:out value="${accountId}" />
				</h1>
				<p class="confidential">IBM Confidential</p>
				<h1>Included Bank Accounts</h1>

				<display:table name="bankInclude" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two"
					id="includes">
					<display:setProperty name="basic.empty.showtable" value="true"/>
			value='<tr class="empty" align="center"><td colspan="{0}">Nothing found to display</td></tr>' />
					<display:column property="name" title="Name" sortable="true"
						headerClass="blue-med" />
					<display:column property="description" title="Description"
						sortable="true" headerClass="blue-med" />
				</display:table>


				<!-- END CONTENT HERE -->
		</div>
	</div>
	</html:form>

	<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
  </body>
</html>
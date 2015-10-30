<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="schema.DC" href="http://purl.org/DC/elements/1.0/" />
<link rel="SHORTCUT ICON" href="http://www.ibm.com/favicon.ico" />
<meta name="DC.Rights" content="© Copyright IBM Corp. 2011" />
<meta name="Keywords" content="REPLACE" />
<meta name="DC.Date" scheme="iso8601" content="2012-09-19" />
<meta name="Source"
	content="v17 template generator, template 17.02 delivery:IBM  authoring:IBM" />

<meta name="Security" content="Public" />
<meta name="Abstract" content="REPLACE" />
<meta name="IBM.Effective" scheme="W3CDTF" content="2012-09-19" />
<meta name="DC.Subject" scheme="IBM_SubjectTaxonomy" content="REPLACE" />
<meta name="Owner" content="Replace" />
<meta name="DC.Language" scheme="rfc1766" content="en" />
<meta name="IBM.Country" content="ZZ" />
<meta name="Robots" content="index,follow" />
<meta name="DC.Type" scheme="IBM_ContentClassTaxonomy" content="REPLACE" />
<meta name="Description" content="REPLACE" />

<%@ page language="java"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-html"
	prefix="html"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-bean"
	prefix="bean"%>
<%@ taglib uri="http://jakarta.apache.org/struts/tags-logic"
	prefix="logic"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="req"
	uri="http://jakarta.apache.org/taglibs/request-1.0"%>
<%@page
	import="java.util.Calendar,java.util.Properties,java.io.FileInputStream,java.lang.String,com.ibm.tap.misld.framework.Constants"%>

<title>Bravo Account: <c:out
		value="${account.customer.customerName}" /></title>

<link href="//1.w3.s81c.com/common/v17/css/w3.css" rel="stylesheet"
	title="w3" type="text/css" />
<script src="//1.w3.s81c.com/common/js/dojo/w3.js"
	type="text/javascript"></script>
	
<script type="text/javascript" src="/BRAVO/common/project.js"></script>

<script>
	function checkAll(theForm) { // check all the checkboxes in the list
		for (var i = 0; i < theForm.elements.length; i++) {
			var e = theForm.elements[i];
			var eName = e.name;

			if (eName != 'allbox' && (e.type.indexOf("checkbox") == 0)) {
				if (!e.disabled) {
					e.checked = theForm.allbox.checked;
				}
			}
		}
	}
</script>
	
	
</head>
<body id="ibm-com">
	<div id="ibm-top" class="ibm-liquid">

		<!-- v17 SSIs: version 1.1 -->
		<!-- MASTHEAD_BEGIN -->
		<div id="ibm-masthead">
			<div id="ibm-mast-options">
				<ul>
					<li id="ibm-geo"><a
						href="http://www.ibm.com/planetwide/select/selector.html"><span
							class="ibm-access">Select a country/region: </span>Worldwide</a></li>
				</ul>
			</div>
			<div id="ibm-universal-nav">
				<ul id="ibm-unav-links">
					<li id="ibm-home"><a href="http://www.ibm.com/">IBM®</a></li>
				</ul>
				<ul id="ibm-menu-links">
					<li><a href="http://www.ibm.com/sitemap/">Site map</a></li>
				</ul>
				<div id="ibm-search-module">
					<form id="ibm-search-form" action="http://www.ibm.com/Search/"
						method="get">
						<p>
							<label for="q"><span class="ibm-access">Search</span></label> <input
								type="text" maxlength="100" value="" name="q" id="q" /> <input
								type="hidden" value="17" name="v" /> <input type="hidden"
								value="utf" name="en" /> <input type="hidden" value="en"
								name="lang" /> <input type="hidden" value="zz" name="cc" /> <input
								type="submit" id="ibm-search" class="ibm-btn-search"
								value="Submit" />
						</p>
					</form>
				</div>
			</div>
		</div>
		<!-- MASTHEAD_END -->

		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<div id="ibm-leadspace-head" class="ibm-alternate">
					<div id="ibm-leadspace-body">
						<p id="breadcrumbs">
							<html:link page="/">
								BRAVO
							</html:link>
							&gt;
							<html:link
								page="/account/view.do?accountId=${account.customer.accountNumber}">
								<c:out value="${account.customer.customerName}" />
							</html:link>
							&gt; SWASSET Data
						</p>
						<h1>
							SWASSET Data: <font class="green-dark"> <c:out
								value="${account.customer.customerName}" /></font>
						</h1>
						<p class="confidential">IBM Confidential</p>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">

								<div class="invalid">
									<html:errors property="status" />
								</div>

								<div class="indent">
									<h3>
										Account&nbsp;<a class="ibm-question-link" href="help/help.do"></a>
									</h3>
								</div>
								<table
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<thead>
										<tr>
											<th class="blue-med" width="1%"></th>
											<th class="blue-med">ID</th>
											<th class="blue-med">Name</th>
											<th class="blue-med">Type</th>
											<th class="blue-med">Dept</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><c:choose>
													<c:when test="${account.customer.status == 'ACTIVE'}">
														<img alt="ACTIVE"
															src="<c:out value="${account.customer.statusIcon}"/>"
															width="12" height="10" />
													</c:when>
													<c:otherwise>
														<img alt="INACTIVE"
															src="<c:out value="${account.customer.statusIcon}"/>"
															width="12" height="10" />
													</c:otherwise>
												</c:choose></td>
											<td><font class="orange-dark"> <c:out
													value="${account.customer.accountNumber}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${account.customer.customerName}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${account.customer.customerType.customerTypeName}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${account.customer.pod.podName}" /></font></td>
										</tr>
									</tbody>
								</table>



								<html:form action="/swasset/search">
									<html:hidden property="context" value="swasset" />
									<html:hidden property="accountId"
										value="${account.customer.accountNumber}" />
									<table border="0" width="65%" cellspacing="10" cellpadding="0">
										<thead>
											<tr>
												<th>SW LPAR Name Search: <html:link
														page="/BRAVO/help/help.do">
														<img
															src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
															width="14" height="14" alt="contextual field help icon" />
													</html:link></th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td><html:text property="search" styleClass="inputlong" />
													<span class="button-blue"><html:submit
															property="type" value="Search" /></span></td>
											</tr>
											<tr>
												<td>
													<div class="invalid">
														<html:errors property="search" />
													</div>
												</td>
											</tr>
										</tbody>
									</table>
								</html:form>
								<c:set var="checkAll">
									<input type="checkbox" name="allBox"
										onclick="checkAll(this.form, 'allBox', 'selected')"
										style="margin: 0 0 0 4px" />
								</c:set>
								<html:form action="/swasset/delete">
									<html:hidden property="accountId"
										value="${account.customer.accountNumber}" />
									<html:hidden property="context" value="swasset" />
									<html:hidden property="search" value="${search}" />
									<table
										class="ibm-data-table ibm-sortable-table ibm-alternate-two"
										id="small">
										<tr>
											<th>LPAR List <html:link page="/BRAVO/help/help.do">
													<img
														src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
														width="14" height="14" alt="contextual field help icon" />
												</html:link></th>
										</tr>
									</table>
									<display:table name="lpars" requestURI=""
										class="ibm-data-table ibm-sortable-table ibm-alternate-two"
										id="tall" defaultsort="1" defaultorder="ascending">
										<display:setProperty name="basic.empty.showtable" value="true" />
										<display:column title="${checkAll}" headerClass="blue-med">
											<c:if test="${tall.STATUS == 'In process'}">
												<html:multibox property="selected" style="margin: 0 0 0 4px"
													disabled="true">
													<c:out value="${tall.ID},${tall.NAME},${tall.TYPE}" />
												</html:multibox>
											</c:if>
											<c:if test="${tall.STATUS != 'In process'}">
												<html:multibox property="selected" style="margin: 0 0 0 4px"
													disabled="false">
													<c:out value="${tall.ID},${tall.NAME},${tall.TYPE}" />
												</html:multibox>
											</c:if>

										</display:column>
										<display:column property="NAME" title="SW LPAR Name"
											sortable="true" headerClass="blue-med" />
										<display:column property="STATUS" title="Status"
											sortable="true" headerClass="blue-med" />
										<display:column property="TYPE" title="TYPE" sortable="true"
											headerClass="blue-med" />
									</display:table>
									<div class="indent">
										<span class="button-blue"> <input type="submit"
											name="action" value="Delete"
											onclick="javascript:return confirm('Are you sure you want to delete these software lpars?')" />
										</span>
									</div>
								</html:form>




							</div>
						</div>
					</div>



				</div>
				<!-- FEATURES_END -->
				<!-- CONTENT_BODY_END -->
			</div>
			<!-- CONTENT_END -->


			<!-- NAVIGATION_BEGIN -->
			<div id="ibm-navigation">
				<h2 class="ibm-access">Content navigation</h2>
				<ul id="ibm-primary-links">

					<li id="ibm-parent-link"><a href="https://w3-connections.ibm.com/communities/service/html/communitystart?communityUuid=85cfd34a-2938-4667-8823-bf4743894fbc">Asset
							Tools Home</a></li>
					<li id="ibm-overview"><a href="/BRAVO/home.do">BRAVO</a> <a
						href="/BRAVO/mswiz.do">MS Wizard</a> <a href="/BRAVO/help/help.do">Help</a>
						<a href="/BRAVO/report/home.do">Reports</a> <a
						href="/BRAVO/systemStatus/home.do">System status</a></li>


					<%
						boolean lbValidRole = false;
						boolean lbAdminRole = false;
					%>
					<req:isUserInRole role="com.ibm.tap.admin">
						<%
							lbValidRole = true;
								lbAdminRole = true;
						%>
					</req:isUserInRole>

					<req:isUserInRole role="com.ibm.tap.sigbank.admin">
						<%
							lbValidRole = true;
								lbAdminRole = true;
						%>
					</req:isUserInRole>

					<req:isUserInRole role="com.ibm.tap.sigbank.user">
						<%
							lbValidRole = true;
						%>
					</req:isUserInRole>
					<%
						if (lbValidRole) {
					%>
					<li id="ibm-overview"><a href="/BRAVO/bankAccount/home.do">Bank
							accounts</a> <logic:present scope="request" name="bankAccountSection">
							<ul>
								<li><a href="/BRAVO/bankAccount/connected.do">Connected</a>
									<logic:equal scope="request" name="bankAccountSection"
										value="CONNECTED">
										<%
											if (lbAdminRole) {
										%>
										<ul>
											<li><a href="/BRAVO/bankAccount/connectedAddEdit.do">Add</a>
											</li>
										</ul>
										<%
											}
										%>
									</logic:equal></li>

								<li><a href="/BRAVO/bankAccount/disconnected.do">Disconnected</a>

									<logic:equal scope="request" name="bankAccountSection"
										value="DISCONNECTED">
										<%
											if (lbAdminRole) {
										%>
										<ul>
											<li><a href="/BRAVO/bankAccount/disconnectedAddEdit.do">Add</a>
											</li>
										</ul>
										<%
											}
										%>
									</logic:equal></li>
							</ul>
						</logic:present></li>
					<%
						}
					%>

					<%
						boolean validRole = false;
					%>
					<req:isUserInRole role="com.ibm.ea.bravo.admin">
						<%
							validRole = true;
						%>
					</req:isUserInRole>
					<req:isUserInRole role="com.ibm.ea.asset.admin">
						<%
							validRole = true;
						%>
					</req:isUserInRole>
					<req:isUserInRole role="com.ibm.ea.admin">
						<%
							validRole = true;
						%>
					</req:isUserInRole>
					<req:isUserInRole role="com.ibm.tap.admin">
						<%
							validRole = true;
						%>
					</req:isUserInRole>
					<%
						if (validRole) {
					%>
					<li id="ibm-overview"><a href="/BRAVO/admin/home.do">Administration</a>
					</li>
					<%
						}
					%>
				</ul>

				<div id="ibm-secondary-navigation">
					<!-- SECONDARY NAVIGATION SECTION -->
					<br /> Legend:
					<hr />
					<span class="ibm-check-link">Active</span><br /> <span
						class="ibm-incorrect-link">Inactive</span><br /> <span
						class="ibm-caution-link">Alert</span>
				</div>

			</div>
			<!-- NAVIGATION_END -->
		</div>


		<div id="ibm-related-content"></div>

		<!-- v17 SSIs: version 1.1 -->
		<!-- FOOTER_BEGIN -->
		<div id="ibm-footer-module"></div>
		<div id="ibm-footer">
			<h2 class="ibm-access">Footer links</h2>
			<ul>
				<li><a href="http://www.ibm.com/contact/">Contact</a></li>
				<li><a href="http://www.ibm.com/privacy/">Privacy</a></li>
				<li><a href="http://www.ibm.com/legal/">Terms of use</a></li>
			</ul>
		</div>
		<!-- FOOTER_END -->
		<div id="ibm-metrics">
			<script src="//www.ibm.com/common/stats/stats.js"
				type="text/javascript">
				//
			</script>
		</div>
	</div>
</body>
</html>
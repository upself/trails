<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="schema.DC" href="http://purl.org/DC/elements/1.0/" />
<link rel="SHORTCUT ICON" href="http://www.ibm.com/favicon.ico" />
<meta name="DC.Rights" content="?Copyright IBM Corp. 2011" />
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

<title>Bravo Software Home: <c:out
		value="${software.softwareLpar.name}" /></title>
<link href="//1.w3.s81c.com/common/v17/css/w3.css" rel="stylesheet"
	title="w3" type="text/css" />
<script src="//1.w3.s81c.com/common/js/dojo/w3.js"
	type="text/javascript"></script>
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
					<li id="ibm-home"><a href="http://www.ibm.com/">IBM?/a></li>
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
							&gt;
							<html:link
								page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${software.softwareLpar.name}&swId=${software.softwareLpar.id}">
								<c:out value="${software.softwareLpar.name}" />
							</html:link>
							&gt;
							<html:link
								page="/software/home.do?lparId=${software.softwareLpar.id}">
								Software
							</html:link>
						</p>

						<h1>
							Software Home: <font class="green-dark"> <c:out
								value="${software.softwareLpar.name}" /></font>
						</h1>
						<p class="confidential">IBM Confidential</p>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">

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

								<div class="indent">
									<h3>
										Software <a class="ibm-question-link"
											href="BRAVO/help/help.do"></a>
									</h3>
								</div>

								<table
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<thead>
										<tr>
											<th class="blue-med" width="1%"></th>
											<th class="blue-med">Name</th>
											<th class="blue-med">Processors</th>
											<th class="blue-med">BIOS Serial</th>
											<%-- 			<c:if --%>
											<%-- 				test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}"> --%>
											<th class="blue-med">SW_TI_ID</th>
											<%-- 			</c:if> --%>
											<th class="blue-med">Scan Time</th>
											<th class="blue-med">Acquisition Time</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><img
												src="<c:out value="${software.softwareLpar.statusIcon}"/>"
												width="12" height="10" /></td>
											<td><font class="orange-dark"> <c:out
													value="${software.softwareLpar.name}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${software.softwareLpar.processorCount}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${software.softwareLpar.biosSerial}" /></font></td>
											<%-- 			<c:if --%>
											<%-- 				test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}"> --%>
											<td><font class="orange-dark"> <c:out
													value="${software.softwareLpar.sw_ti_id}" /></font></td>
											<%-- 			</c:if> --%>

											<td><font class="orange-dark"> <c:out
													value="${software.softwareLpar.scantimeDate}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${software.softwareLpar.acquisitionDate}" /></font></td>
										</tr>
									</tbody>
								</table>

								<div class="indent">
									<h3>
										Software Statistics <a class="ibm-question-link"
											href="BRAVO/help/help.do"></a>
									</h3>
								</div>
								<table
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<thead>
										<tr>
											<th class="blue-med">Total Active Installed Software</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><font class="orange-dark"> <c:out
													value="${softwareStatistics.installedSoftwareCount}" /></font></td>
										</tr>
									</tbody>
								</table>


								<div class="indent">
									<h3>
										Software Source <a class="ibm-question-link"
											href="BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="bankAccountList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two">
									<display:setProperty name="basic.empty.showtable" value="true" />
									<display:column property="bankAccount.name" title="Name"
										sortable="true" headerClass="blue-med" />
									<display:column property="bankAccount.type" title="Type"
										sortable="true" headerClass="blue-med" />
								</display:table>

								<div class="invalid">
									<html:errors property="status" />
								</div>

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

								<html:form styleId="SoftwareHomeForm"
									action="/software/determineButton">
									<html:hidden property="context" value="software" />
									<html:hidden property="accountId"
										value="${account.customer.accountNumber}" />
									<html:hidden property="lparName"
										value="${software.softwareLpar.name}" />
									<html:hidden property="lparId"
										value="${software.softwareLpar.id}" />
									<div class="indent">
										<h3>
											Software <a class="ibm-question-link"
												href="BRAVO/help/help.do"></a>
										</h3>
									</div>
									<display:table name="list" requestURI=""
										class="ibm-data-table ibm-sortable-table ibm-alternate-two"
										id="software">
										<display:setProperty name="basic.empty.showtable" value="true" />
										<display:setProperty name="basic.msg.empty_list_row"
											value='<tr class="empty"><td colspan="{0}">No Software</td></tr>' />

										<display:column title="Validate<br />${checkAllValidate}"
											headerClass="blue-med">
											<html:multibox property="validateSelected"
												style="margin: 0 0 0 4px" disabled="${software.disabled}">
												<c:out value="${software.id}" />
											</html:multibox>
										</display:column>
										<display:column title="Delete<br />${checkAllDelete}"
											headerClass="blue-med">
											<html:multibox property="deleteSelected"
												style="margin: 0 0 0 4px"
												disabled="${!(software.manualDeleteActive == 'TRUE' && showDelete == 'TRUE')}">
												<c:out value="${software.software.softwareId}" />
											</html:multibox>
											<!--  disabled="${!(software.discrepancyType.name == 'MISSING' && showDelete == 'TRUE')}" -->
										</display:column>
										<display:column property="statusImage" title=""
											headerClass="blue-med" />
										<display:column property="software.softwareItem.name"
											title="Name" sortable="true" headerClass="blue-med"
											href="/BRAVO/software/view.do" paramId="id"
											paramProperty="id" />
										<display:column
											property="software.manufacturer.manufacturerName"
											title="Manufacturer" sortable="true" headerClass="blue-med" />
										<display:column property="software.level"
											title="License Level" sortable="true" headerClass="blue-med" />
										<display:column property="discrepancyType.name"
											title="Discrepancy" sortable="true" headerClass="blue-med" />
									</display:table>

									<div class="hrule-dots"></div>
									<div class="indent">
										<span class="ibm-btn-view-pri"> <html:submit
												value="Validate" property="buttonPressed"
												styleClass="ibm-btn-view-pri" /> <html:submit
												value="Delete" property="buttonPressed"
												styleClass="ibm-btn-view-pri" />
										</span>
									</div>
									<!--	</div></div>-->
								</html:form>

							</div>
						</div>
					</div>


					<!-- FEATURES_BEGIN -->
					<div id="ibm-content-sidebar">
						<div class="ibm-container">
							<h2 class="ibm-rule">
								Actions <a class="ibm-question-link" href="BRAVO/help/help.do"></a>
							</h2>
							<div class="ibm-container-body">
								<ul class="ibm-link-list">

									<!-- Create Software Discrepancy (Add Missing Software Product) -->
									<li><a class="ibm-add1-link"
										href="/BRAVO/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${software.softwareLpar.name}&lparId=${software.softwareLpar.id}">Add
											Missing Software Product</a></li>
								</ul>

							</div>
						</div>
						<!-- stop partial-sidebar -->
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

					<li id="ibm-parent-link"><a href="http://tap.raleigh.ibm.com">Asset
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
					<h2>Related links</h2>
					<ul id="ibm-related-links">
						<li><a
							href="http://www-03.ibm.com/procurement/proweb.nsf/ContentDocsByTitle/United+States~Global+Procurement">IBM
								Global Procurement</a></li>
						<li><a href="//www.ibm.com/ibm/ibmgives/">Corporate
								citizenship</a></li>
						<li><a href="http://www.ibm.com/ibm/responsibility/">Corporate
								Responsibility Report</a></li>

					</ul>
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
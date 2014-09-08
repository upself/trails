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

<title>Bravo Account List</title>

<link href="//1.w3.s81c.com/common/v17/css/w3.css" rel="stylesheet"
	title="w3" type="text/css" />
<script src="//1.w3.s81c.com/common/js/dojo/w3.js"
	type="text/javascript"></script>

<script>                                                                                                                               
function popupTrailsReports(accountId) { 
	<%Properties properties = new Properties();
			properties.load(new FileInputStream(Constants.CONF_DIR
					+ Constants.PROPERTIES));
			String trailsServerName = properties
					.getProperty("server.name.trails");%>                                                                                                         
	newWin=window.open('<%=trailsServerName%>
	/TRAILS/account/trailsreports/home.htm?accountId='
								+ accountId,
						'popupWindow',
						'height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
		newWin.focus();
		void (0);
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
						</p>

						<h1>Search results:</h1>
						<p class="confidential">IBM Confidential</p>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">

								<div class="invalid">
									<html:errors />
								</div>

								<div class="indent">
									<h3>
										Composites
										<html:link page="/help/help.do#H2">
											<img
												src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
												width="14" height="14" alt="contextual field help icon" />
										</html:link>
									</h3>
								</div>
								<display:table name="composites" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="tall" defaultsort="1" defaultorder="ascending">
									<display:setProperty name="basic.empty.showtable" value="true" />
									<display:column sortProperty="name" title="HW name"
										sortable="true" headerClass="blue-med">
										<a
											href="/BRAVO/lpar/view.do?accountId=<c:out value="${tall.customer.accountNumber}"/>&lparName=<c:out value="${tall.name}"/>&hwId=<c:out value="${tall.id}"/>"><c:out
												value="${tall.name}" /></a>
									</display:column>
									<display:column property="softwareLpar.name" title="SW name"
										sortable="true" headerClass="blue-med" />
									<display:column property="customer.accountNumber"
										title="Acct #" sortable="true" headerClass="blue-med" />
									<display:column property="hardware.machineType.type"
										title="Type" sortable="true" headerClass="blue-med" />
									<display:column property="hardware.serial" title="HW serial"
										sortable="true" headerClass="blue-med" />
									<display:column property="softwareLpar.biosSerial"
										title="SW serial" sortable="true" headerClass="blue-med" />
									<display:column property="hardware.hardwareStatus"
										title="ATP Status" sortable="true" headerClass="blue-med" />
								</display:table>

								<div class="indent">
									<h3>
										Hardware lpars w/o Software
										<html:link page="/help/help.do#H2">
											<img
												src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
												width="14" height="14" alt="contextual field help icon" />
										</html:link>
									</h3>
								</div>
								<display:table name="hardwareLpars" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="tall" defaultsort="2" defaultorder="ascending">
									<display:setProperty name="basic.empty.showtable" value="true" />
									<display:column property="statusImage" title="" sortable="true"
										headerClass="blue-med" />
									<display:column sortProperty="name" title="Name"
										sortable="true" headerClass="blue-med">
										<a
											href="/BRAVO/lpar/view.do?accountId=<c:out value="${tall.customer.accountNumber}"/>&lparName=<c:out value="${tall.name}"/>&hwId=<c:out value="${tall.id}"/>"><c:out
												value="${tall.name}" /></a>
									</display:column>
									<display:column property="customer.accountNumber"
										title="Acct #" sortable="true" headerClass="blue-med" />
									<display:column property="hardware.machineType.type"
										title="Type" sortable="true" headerClass="blue-med" />
									<display:column property="hardware.serial" title="Serial"
										sortable="true" headerClass="blue-med" />
									<display:column property="hardware.hardwareStatus"
										title="ATP Status" sortable="true" headerClass="blue-med" />
								</display:table>

								<div class="indent">
									<h3>
										Hardware w/o hardware lpar
										<html:link page="/help/help.do#H2">
											<img
												src="//w3.ibm.com/ui/v8/images/icon-help-contextual-dark.gif"
												width="14" height="14" alt="contextual field help icon" />
										</html:link>
									</h3>
								</div>
								<display:table name="hardware" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="tall" defaultsort="2" defaultorder="ascending">
									<display:setProperty name="basic.empty.showtable" value="true" />
									<display:column property="statusImage" title="" sortable="true"
										headerClass="blue-med" />
									<display:column property="serial" title="Serial"
										sortable="true" headerClass="blue-med" />
									<display:column property="machineType.type" title="Type"
										sortable="true" headerClass="blue-med" />
									<display:column property="customerNumber"
										title="Customer Number" sortable="true" headerClass="blue-med" />
									<display:column property="hardwareStatus" title="ATP status"
										sortable="true" headerClass="blue-med" />
								</display:table>



							</div>
						</div>




					</div>




					<!-- FEATURES_BEGIN -->
					<div id="ibm-content-sidebar">
						<div class="ibm-container">
							<h2 class="ibm-rule">
								Actions&nbsp;<a class="ibm-question-link" href="help/help.do"></a>
							</h2>
							<div class="ibm-container-body">
								<ul class="ibm-link-list">
									<!-- Exclude Account -->
									<li><a class="ibm-add1-link"
										href="/BRAVO/account/banklist.do?accountId=${account.customer.accountNumber}">Bank
											Account Inclusion List</a></li>

									<!-- Create Contact -->
									<li><a class="ibm-add1-link"
										href="/BRAVO/contact/create.do?context=ACCOUNT&accountId=${account.customer.accountNumber}&id=&lparId=&customerid=${account.customer.customerId}">Create
											Account Contacts</a></li>

									<!-- Refresh/Update Existing Account Contacts -->
									<li><a class="ibm-forward-link"
										href="/BRAVO/contact/update.do?accountId=${account.customer.accountNumber}&context=ACCOUNT&id=&lparId=&customerid=${account.customer.customerId}">Update
											Account Contacts</a></li>

									<!-- Upload Tar Files -->
									<li><a class="ibm-upload-link"
										href="/BRAVO/upload/tivoli.do?id=${account.customer.accountNumber}">Upload
											TCM Script TAR File</a></li>

									<!-- Upload Discrepancies Software -->
									<li><a class="ibm-upload-link"
										href="/BRAVO/upload/softwareDiscrepancy.do?id=${account.customer.accountNumber}">Upload
											SW Discrepancy</a></li>

									<c:if
										test="${account.customer.customerType.customerTypeName == 'NEVER'}">
										<!-- Upload SCRT Report -->
										<li><a class="ibm-upload-link"
											href="/BRAVO/upload/scrtReport.do?id=${account.customer.accountNumber}">Upload
												SCRT Report</a></li>
										<br />
										<br />
									</c:if>

									<!-- Upload TLCMz -->
									<li><a class="ibm-upload-link"
										href="/BRAVO/upload/softAudit.do?id=${account.customer.accountNumber}">Upload
											TLCMz Software</a></li>

									<!-- Upload Dorana file -->
									<li><a class="ibm-upload-link"
										href="/BRAVO/upload/dorana.do?id=${account.customer.accountNumber}">Upload
											Dorana Scan</a></li>

									<!-- Delete SWASSET data -->
									<li><a class="ibm-delete-link"
										href="/BRAVO/swasset/view.do?accountId=${account.customer.accountNumber}">Delete
											Scan Data</a></li>

									<c:if test="${isAPMMAccount}">
										<!-- Upload authorized Assets -->
										<li><a class="ibm-delete-link"
											href="/BRAVO/upload/authorizedAssets.do?id=${account.customer.accountNumber}">Upload
												authorized Assets</a></li>
										<br />
									</c:if>
								</ul>



								<h2 class="ibm-rule">
									Reports&nbsp;<a class="ibm-question-link" href="help/help.do"></a>
								</h2>

								<ul class="ibm-link-list">

									<!-- Account Discrepancies Report -->
									<li><a class="ibm-download-link"
										href="/BRAVO/download/accountDiscrepancies.${account.customer.accountNumber}.tsv?name=accountDiscrepancies&accountId=${account.customer.accountNumber}">Account
											Discrepancies</a></li>

									<!-- Account Asset Report -->
									<li><a class="ibm-download-link"
										href="/BRAVO/download/accountAssets.${account.customer.accountNumber}.tsv?name=accountAssets&accountId=${account.customer.accountNumber}">Account
											Assets</a></li>

									<!-- Software Downloads Multi Report -->
									<li><c:if test="${account.multiReport}">
											<a class="ibm-download-link"
												href="/BRAVO/download/MULTI.${account.customer.accountNumber}.zip?name=softwareMulti&accountId=${account.customer.accountNumber}">
												Software Multi Report </a>
										</c:if> <c:if test="${!account.multiReport}">
											Software Multi Report
										</c:if></li>

									<!-- Trails reports -->
									<li><a class="ibm-download-link"
										href="javascript:popupTrailsReports(${account.customer.customerId})">Trails
											Reports</a></li>

									<c:if test="${isAPMMAccount}">

										<!-- Authorized Asset Search -->
										<li><a class="ibm-download-link"
											href="/authorizedAsset/search.do?accountId=${account.customer.accountNumber}">Authorized
												assets search</a></li>
									</c:if>


								</ul>

								<br />

								<h2 class="ibm-rule">Account Contacts</h2>
								<ul class="ibm-link-list">
									<c:forEach items="${contactList}" var="contact">
										<li><a
											href="/BRAVO/contact/view.do?context=ACCOUNT&accountId=${account.customer.accountNumber}&lparId=&customerid=${account.customer.customerId}&id=${contact.contact.id}">
												<c:out value="${contact.contact.name}" />
										</a></li>
									</c:forEach>
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
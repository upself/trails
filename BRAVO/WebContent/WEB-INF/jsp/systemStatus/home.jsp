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

<title>System Status</title>
<link href="//1.w3.s81c.com/common/v17/css/w3.css" rel="stylesheet"
	title="w3" type="text/css" />
<script src="//1.w3.s81c.com/common/js/dojo/w3.js"
	type="text/javascript"></script>

<link rel="stylesheet"
	href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css" />

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
							<html:link page="/">BRAVO</html:link>
							&gt;
							<html:link page="/systemStatus/home.do">System status</html:link>
						</p>
						<br />
						<h1>System Status Home</h1>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">

								<br />
								<html:form action="/systemStatus/submit_form"
									styleClass="ibm-column-form">

									<table border="0" width="100%" cellspacing="10" cellpadding="0">
										<tbody>
											<tr>
												<td style="width: 10%"><label for="id_type">Bank
														account:</label></td>

												<td style="width: 30%"><html:select
														property="bankAccount">
														<html:option value="0">Show All Bank Accounts</html:option>
														<html:options collection="bankAccountNames"
															labelProperty="name" property="id" />
													</html:select></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label for="id_type">Module/Loader:</label></td>
												<td><select name="moduleLoader" id="moduleLoader">
														<option value="Show All">Show All</option>
														<option value="SCAN RECORD">SCAN RECORD</option>
														<option value="SCAN SOFTWARE">SCAN SOFTWARE</option>
														<option value="SOFTWARE SIGNATURE">SOFTWARE
															SIGNATURE</option>
														<option value="SOFTWARE FILTER">SOFTWARE FILTER</option>
														<option value="PROCESSOR">PROCESSOR</option>
														<option value="HDISK">HDISK</option>
														<option value="MEMMOD">MEMMOD</option>
														<option value="IP ADDRESS">IP ADDRESS</option>
												</select></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label for="id_type">Include delta loads</label></td>
												<td><html:checkbox property="delta_checkbox"
														styleClass="ibm-styled" /></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label for="id_type">Loader status:</label></td>
												<td><html:select property="loaderStatus">
														<html:option value="Show All">Show All</html:option>
														<html:option value="COMPLETE">COMPLETE</html:option>
														<html:option value="PENDING">PENDING</html:option>
														<html:option value="ERROR">ERROR</html:option>
													</html:select></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label for="id_type">Bank Account Type:</label></td>
												<td><html:select property="type">
														<html:option value="Show All">Show All</html:option>
														<html:option value="TCM">TCM</html:option>
														<html:option value="TLM">TLM</html:option>
														<html:option value="SMS">SMS</html:option>
														<html:option value="SNAPSHOT">SNAPSHOT</html:option>
														<html:option value="EESM">EESM</html:option>
														<html:option value="BLAZANT">BLAZANT</html:option>
														<html:option value="ALTIRIS">ALTIRIS</html:option>
														<html:option value="IDD">IDD</html:option>
														<html:option value="TADZ">TADZ</html:option>
														<html:option value="FACTS">FACTS</html:option>
														<html:option value="TAD4D">TAD4D</html:option>
													</html:select></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label for="id_type">Connection Type:</label></td>
												<td><html:select property="connectionType">
														<html:option value="Show All">Show All</html:option>
														<html:option value="DISCONNECTED">DISCONNECTED</html:option>
														<html:option value="CONNECTED">CONNECTED</html:option>
													</html:select></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label>Date from:</label></td>
												<td><html:text styleId="datepicker_from"
														property="date_from" styleClass="ibm-styled" /></td>


											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label>Date to:</label></td>
												<td><html:text styleId="datepicker_to"
														property="date_to" styleClass="ibm-styled" /></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><label for="id_type">Include system status</label>
												</td>
												<td><html:checkbox property="systemStatus_checkbox"
														styleClass="ibm-styled" /></td>
											</tr>
											<tr>
												<td>&nbsp;</td>
											</tr>
											<tr>
												<td><span class="ibm-btn-view-pri"> <html:submit
															property="action" value="Submit"
															styleClass="ibm-btn-view-pri" />
												</span></td>
											</tr>
										</tbody>
									</table>
								</html:form>
								<br /> <br />

								<script>
									$(function() {
										$("#datepicker_from").datepicker({
											dateFormat : 'yy-mm-dd'
										}).val();
									});
								</script>

								<script>
									$(function() {
										$("#datepicker_to").datepicker({
											dateFormat : 'yy-mm-dd'
										}).val();
									});
								</script>

								<h1>Bank account jobs</h1>
								<display:table cellspacing="2" cellpadding="0"
									name="bankAccountJobList" id="table_bank_account_jobs_row"
									requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two ibm-table-scroll"
									defaultsort="1" defaultorder="ascending">
									<display:setProperty name="basic.empty.showtable" value="true" />
									<display:column property="bankAccount.name"
										title="Bank account name" sortable="true"
										headerClass="blue-med" group="1">
									</display:column>

									<display:column property="name" title="Module" sortable="true"
										headerClass="blue-med" />
									<display:column property="comments" title="Comments"
										sortable="true" headerClass="blue-med" />
									<display:column property="startTime" class="date"
										format="{0,date,MM-dd-yyyy HH:mm:ss}" title="Start time"
										sortable="true" headerClass="blue-med" />
									<display:column property="endTime" class="date"
										format="{0,date,MM-dd-yyyy HH:mm:ss}" title="End time"
										sortable="true" headerClass="blue-med" />
									<display:column property="elapsedTime" title="Elapsed time"
										sortable="false" headerClass="blue-med"
										style="white-space:nowrap" />
									<display:column property="bankAccount.type"
										title="Account Type" sortable="true" headerClass="blue-med"
										style="white-space:nowrap" />
									<display:column property="bankAccount.connectionType"
										title="Connection Type" sortable="true" headerClass="blue-med"
										style="white-space:nowrap" />
									<display:column property="status" title="Status"
										sortable="true" headerClass="blue-med" />
									<display:column property="firstErrorTime" class="date"
										format="{0,date,MM-dd-yyyy HH:mm:ss}" title="First error time"
										sortable="true" headerClass="blue-med" />							
								</display:table>

								<h1>System status</h1>
								
								<display:table export="true" cellspacing="2" cellpadding="0"
									name="systemScheduleStatusList" id="table_system status_row"
									requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two ibm-vertical-dividers-color-labels"
									defaultsort="1" defaultorder="ascending">
									<display:setProperty name="basic.empty.showtable" value="true" />
									<display:column property="name" title="Module" sortable="true"
										headerClass="blue-med" />
									<display:column property="comments" title="Comments"
										sortable="true" headerClass="blue-med" />
									<display:column property="startTime" class="date"
										format="{0,date,MM-dd-yyyy HH:mm:ss}" title="Start time"
										sortable="true" headerClass="blue-med" />
									<display:column property="endTime" class="date"
										format="{0,date,MM-dd-yyyy HH:mm:ss}" title="End time"
										sortable="true" headerClass="blue-med" />
									<display:column property="elapsedTime" title="Elapsed time"
										sortable="false" headerClass="blue-med"
										style="white-space:nowrap" />
									<display:column property="status" title="Status"
										sortable="true" headerClass="blue-med" />
<%-- 									<display:setProperty name="export.pdf" value="true" /> --%>
									<display:setProperty name="export.csv" value="true" />
								</display:table>

							</div>
						</div>
					</div>
					<!-- END MAIN CONTENT -->

					<!-- CONTENT_BODY_END -->
				</div>
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
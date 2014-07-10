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

<title>Bravo LPAR: <c:out value="${lpar.name}" /></title>
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
							&gt;
							<html:link
								page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}&hwId=${lpar.hwId}&swId=${lpar.swId}">
								<c:out value="${lpar.name}" />
							</html:link>
						</p>
						<h1>
							Lpar Detail: <font class="green-dark"> <c:out
								value="${lpar.name}" /></font>
						</h1>
						<p class="confidential">IBM Confidential</p>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">




								<div class="indent">
									<h3>
										Hardware <a class="ibm-question-link"
											href="BRAVO/help/help.do"></a>
									</h3>
								</div>
								<table
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<thead>
										<tr>
											<th class="blue-med" width="1%"></th>
											<th class="blue-med">Country</th>
											<th class="blue-med">Asset Type</th>
											<th class="blue-med">Machine Type</th>
											<th class="blue-med">Serial</th>
											<th class="blue-med">Proc mfg</th>
											<th class="blue-med">Proc type</th>
											<th class="blue-med">Proc model</th>
											<th class="blue-med">Cores per chip</th>
											<th class="blue-med">HW chip</th>
											<th class="blue-med">HW proc</th>
											<th class="blue-med"># chips max</th>
											<th class="blue-med">Shared</th>
											<th class="blue-med">HW Owner</th>
											<th class="blue-med">ATP Status</th>
											<c:if
												test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
												<th class="blue-med">CPU IBM LSPR MIPS</th>
												<th class="blue-med">CPU Gartner MIPS</th>
												<th class="blue-med">CPU MSU</th>
											</c:if>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><img
												src="<c:out value="${lpar.hardwareLpar.hardware.statusIcon}"/>"
												width="12" height="10" /></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.country}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.machineType.type}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.machineType.name}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.serial}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.processorManufacturer}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.mastProcessorType}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.processorModel}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.nbrCoresPerChip}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.chips}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.processorCount}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.nbrOfChipsMax}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.shared}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.owner}" /></font></td>
											<td><font class="orange-dark"> <c:out
													value="${lpar.hardwareLpar.hardware.hardwareStatus}" /></font></td>
											<c:if
												test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
												<td><font class="orange-dark"> <c:out
														value="${lpar.hardwareLpar.hardware.cpuMIPS}" /></font></td>
												<td><font class="orange-dark"> <c:out
														value="${lpar.hardwareLpar.hardware.cpuGartnerMIPS}" /></font></td>
												<td><font class="orange-dark"> <c:out
														value="${lpar.hardwareLpar.hardware.cpuMSU}" /></font></td>
											</c:if>
										</tr>
									</tbody>
								</table>
								<div class="indent">
									<h3>
										Hardware LPAR <a class="ibm-question-link"
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
											<th class="blue-med">Server Type</th>
											<th class="blue-med">Eff Proc</th>
											<th class="blue-med">Sysplex</th>
											<th class="blue-med">SPLA</th>
											<th class="blue-med">Internet Acc</th>
											<th class="blue-med">Lpar Status</th>
											<th class="blue-med">HW_EXT_ID</th>
											<th class="blue-med">HW_TI_ID</th>
											<c:if
												test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
												<th class="blue-med">Part IBM LSPR MIPS</th>
												<th class="blue-med">Part Gartner MIPS</th>
												<th class="blue-med">Part MSU</th>
											</c:if>
										</tr>
									</thead>
									<tbody>
										<tr>
											<c:choose>
												<c:when test="${lpar.hardwareLpar == null}">
													<td colspan="7" align="center"><font
														class="orange-dark"> <html:link
															page="/hardware/lpar/create.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}">
															No Hardware Record
														</html:link> </font></td>
												</c:when>
												<c:otherwise>
													<td><c:choose>
															<c:when test="${lpar.hardwareLpar.status == 'ACTIVE'}">
																<img alt="ACTIVE"
																	src="<c:out value="${lpar.hardwareLpar.statusIcon}"/>"
																	width="12" height="10" />
															</c:when>
															<c:otherwise>
																<img alt="INACTIVE"
																	src="<c:out value="${lpar.hardwareLpar.statusIcon}"/>"
																	width="12" height="10" />
															</c:otherwise>
														</c:choose></td>
													<td><font class="orange-dark"> <html:link
															page="/hardware/home.do?lparId=${lpar.hardwareLpar.id}">
															<c:out value="${lpar.hardwareLpar.name}" />
														</html:link> </font></td>

													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.hardware.serverType}" /> </font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.hardwareLparEff.processorCount}" />
													</font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.sysplex}" /> </font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.spla}" /> </font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.internetIccFlag}" /> </font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.lparStatus}" /> </font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.extId}" /> </font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.hardwareLpar.techImageId}" /> </font></td>
													<c:if
														test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
														<td><font class="orange-dark"> <c:out
																value="${lpar.hardwareLpar.partMIPS}" /> </font></td>
														<td><font class="orange-dark"> <c:out
																value="${lpar.hardwareLpar.partGartnerMIPS}" /></font></td>
														<td><font class="orange-dark"> <c:out
																value="${lpar.hardwareLpar.partMSU}" /> </font></td>
													</c:if>
												</c:otherwise>
											</c:choose>
										</tr>
									</tbody>
								</table>




								<div class="indent">
									<h3>
										Software LPAR <a class="ibm-question-link"
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
											<th class="blue-med">Proc</th>
											<th class="blue-med">BIOS Serial</th>
											<c:if
												test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
												<th class="blue-med">SW_TI_ID</th>
											</c:if>
											<th class="blue-med">Scan Time</th>
											<th class="blue-med">Acquisition Time</th>
											<th class="blue-med">SW_EXT_ID</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<c:choose>
												<c:when test="${lpar.softwareLpar == null}">
													<td colspan="4" align="center"><font
														class="orange-dark"> <html:link
															page="/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}&lparId=${lpar.softwareLpar.id}">
															No Software Records
														</html:link> </font></td>
												</c:when>
												<c:otherwise>
													<td><c:choose>
															<c:when test="${lpar.softwareLpar.status == 'ACTIVE'}">
																<img alt="ACTIVE"
																	src="<c:out value="${lpar.softwareLpar.statusIcon}"/>"
																	width="12" height="10" />
															</c:when>
															<c:otherwise>
																<img alt="INACTIVE"
																	src="<c:out value="${lpar.softwareLpar.statusIcon}"/>"
																	width="12" height="10" />
															</c:otherwise>
														</c:choose></td>
													<td><font class="orange-dark"> <html:link
															page="/software/home.do?lparId=${lpar.softwareLpar.id}">
															<c:out value="${lpar.softwareLpar.name}" />
														</html:link> </font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.softwareLpar.processorCount}" /></font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.softwareLpar.biosSerial}" /></font></td>

													<c:if
														test="${lpar.hardwareLpar.hardware.machineType.type == 'MAINFRAME'}">
														<td><font class="orange-dark"> <c:out
																value="${lpar.softwareLpar.sw_ti_id}" /></font></td>
													</c:if>

													<td><font class="orange-dark"> <c:out
															value="${lpar.softwareLpar.scantimeDate}" /></font></td>
													<td><font class="orange-dark"> <c:out
															value="${lpar.softwareLpar.acquisitionDate}" /></font></td>
													<td><font class="orange-dark"><c:out
						                                    value="${lpar.softwareLpar.extId}" /></font></td>
												</c:otherwise>
											</c:choose>
										</tr>
									</tbody>
								</table>




								<c:set var="checkAll">
									<input type="checkbox" name="allbox"
										onclick="checkAll(this.form)" style="margin: 0 0 0 4px" />
								</c:set>
								<html:form action="/software/validate">
									<html:hidden property="context" value="lpar" />
									<html:hidden property="accountId"
										value="${account.customer.accountNumber}" />
									<html:hidden property="lparName" value="${lpar.name}" />
									<html:hidden property="lparId" value="${lpar.softwareLpar.id}" />

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
											value='<tr class="empty" align="center"><td colspan="{0}"><a href="/BRAVO/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${lpar.name}&lparId=${lpar.softwareLpar.id}">No Software Records</a></td></tr>' />

										<display:column title="${checkAll}" headerClass="blue-med">
											<html:multibox property="validateSelected"
												style="margin: 0 0 0 4px" disabled="${software.disabled}">
												<c:out value="${software.id}" />
											</html:multibox>
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
										<display:column property="keyManaged" title="Key Managed"
											sortable="true" headerClass="blue-med" />

									</display:table>

									<div class="indent">

										<span class="ibm-btn-view-pri"> <input type="submit"
											name="action" value="Validate" />
										</span>
									</div>
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

									<!-- Create Software Discrepancy -->
									<c:if test="${lpar.softwareLpar != null}">
										<!-- Only show this link if the software lpar is defined -->
										<li><a class="ibm-add1-link"
											href="/BRAVO/software/selectInit.do?accountId=${account.customer.accountNumber}&lparName=${lpar.hardwareLpar.name}&lparId=${lpar.softwareLpar.id}">Add
												Missing Software Product</a></li>
									</c:if>

									<!-- Add New Contact -->
									<li><a class="ibm-add1-link"
										href="/BRAVO/contact/create.do?lparName=${lpar.hardwareLpar.name}&context=LPAR&accountId=
											${account.customer.accountNumber}&id=${lpar.hardwareLpar.id}&lparId=&customerid=
											${account.customer.customerId}">Create
											LPAR Contacts</a></li>

									<!-- Refresh/Update Existing Account Contacts -->
									<li><a class="ibm-forward-link"
										href="/BRAVO/contact/update.do?accountId=${account.customer.accountNumber}&lparName=${lpar.hardwareLpar.name}&context=LPAR&id=${lpar.hardwareLpar.id}&lparId=&customerid=${account.customer.customerId}">Update
											LPAR Contacts</a></li>

									<!-- Copy this LPAR to others -->
									<li><a class="ibm-forward-link"
										href="/BRAVO/software/copy.do?lparId=${lpar.softwareLpar.id}">Copy
											this LPAR</a></li>
								</ul>

								<br />

								<div class="callout" id="contacts">

									<h2 class="ibm-rule">Account Contacts</h2>
									<ul class="ibm-link-list">
										<c:forEach items="${contactList}" var="contact">
											<li><a
												href="/BRAVO/contact/view.do?context=LPAR&accountId=${account.customer.accountNumber}&lparName=${lpar.hardwareLpar.name}&customerid=${account.customer.customerId}&id=${contact.contact.id}">
													<c:out value="${contact.contact.name}" />
											</a></li>
										</c:forEach>
									</ul>
								</div>
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
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

<title><c:out value="${software.action}" /> Software: <c:out
		value="${software.software.softwareName}" /></title>
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

							<c:choose>
								<c:when
									test="${software.lparId == null || software.lparId == ''}">
									&gt;
									<c:out value="${software.lparName}" />
									&gt;
									Software
								</c:when>
								<c:otherwise>
									&gt;
									<html:link
														page="/lpar/view.do?accountId=${account.customer.accountNumber}&lparName=${software.lparName}">
														<c:out value="${software.lparName}" />
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
									<html:link
														page="/software/select.do?accountId=${account.customer.accountNumber}&lparName=${software.lparName}&lparId=${software.lparId}">
										${software.softwareName}	
									</html:link>
									&gt;
									<html:link
														page="/software/create.do?accountId=${account.customer.accountNumber}&lparId=${software.lparId}&softwareId=${software.software.id}&lparName=${software.lparName}">
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

						<h1>
							<c:out value="${software.action}" />
							Software: <font class="green-dark">
							<c:out value="${software.softwareName}" /></font>
						</h1>
						<p class="confidential">IBM Confidential</p>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">


								<html:form action="/software/edit">
									<html:hidden property="id" />
									<html:hidden property="softwareId" />
									<html:hidden property="lparId" />
									<html:hidden property="lparName" />
									<html:hidden property="accountId" />
									<html:hidden property="processorCount" value="1" />
									<html:hidden property="users" value="1" />
									<table border="0" width="80%" cellspacing="10" cellpadding="0">
										<tbody>
											<tr>
												<td nowrap="nowrap">Software Name:</td>
												<td><html:text property="softwareName"
														styleClass="inputlong"
														readonly="${software.readOnly['softwareName']}" /></td>
												<td class="error"><html:errors property="softwareName" /></td>
											</tr>
											<tr>
												<td nowrap="nowrap">Manufacturer:</td>
												<td><html:text property="manufacturer"
														styleClass="inputlong"
														readonly="${software.readOnly['manufacturer']}" /></td>
												<td class="error"><html:errors property="manufacturer" /></td>
											</tr>
											<tr>
												<td nowrap="nowrap">License Level:</td>
												<td><html:text property="licenseLevel"
														styleClass="inputlong"
														readonly="${software.readOnly['licenseLevel']}" /></td>
												<td class="error"><html:errors property="level" /></td>
											</tr>
											<tr>
												<td nowrap="nowrap">Discrepancy:</td>
												<td><c:choose>
														<c:when
															test="${software.readOnly['discrepancyType'] == true}">
															<html:hidden property="discrepancyTypeId" />
															<input type="text" class="inputlong"
																value="${software.discrepancyType.name}"
																readonly="readonly" />
														</c:when>
														<c:otherwise>
															<html:select property="discrepancyTypeId"
																styleClass="inputlong">
																<html:optionsCollection property="discrepancyTypeList" />
															</html:select>
														</c:otherwise>
													</c:choose></td>
												<td class="error"><html:errors
														property="discrepancyType" /></td>
											</tr>
											<tr>
												<td nowrap="nowrap">Invalid Software Category:</td>
												<td><html:select property="invalidCategory"
														styleClass="inputlong"
														disabled="${software.readOnly['invalidCategory']}">
														<!--  DONNIE REMOVED disabled="${software.readOnly['invalidCategory']}" -->
														<html:optionsCollection property="invalidCategoryList" />
													</html:select></td>
												<td class="error"><html:errors
														property="invalidCategory" /></td>
											</tr>
											<tr>
												<td nowrap="nowrap">Comment:</td>
												<td><html:textarea property="comment"
														styleClass="inputlong" rows="3"
														readonly="${software.readOnly['comment']}" />
													<!--  DONNIE REMOVED readonly="${software.readOnly['comment']}"-->
												</td>
												<td class="error"><html:errors property="comment" /></td>
											</tr>
											<tr>
												<td></td>
												<td nowrap="nowrap"><span class="ibm-btn-view-pri">
														<html:submit property="action" value="${software.action}"
															disabled="${software.readOnly['comment']}"
															styleClass="ibm-btn-view-pri" /> <html:submit
															property="action" value="Cancel"
															disabled="${software.readOnly['comment']}"
															styleClass="ibm-btn-view-pri" />
												</span></td>
											</tr>
											<tr>
												<td></td>
												<td><font color="RED">
													<html:errors property="db" /></font></td>
											</tr>
										</tbody>
									</table>
								</html:form>

								<br />

								<table
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									border="0" cellpadding="2" cellspacing="0" width="100%">
									<tr>
										<td width="40%"><font style="color:#7a3" class="caption">Discrepancy
											Glossary:</font></td>
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
										<td>Softaudit identifies a product that is not installed
											on the system</td>
									</tr>
									<tr>
										<th>INVALID</th>
										<td></td>
									</tr>
									<tr>
										<th>TADZ</th>
										<td>It is kind of TADZ data</td>
									</tr>
									<tr>
										<td></td>
									</tr>
									<tr>
										<td width="40%"><font style="color:#7a3" class="caption">Invalid
											Software Categories:</font></td>
										<td><font style="color:#7a3" class="caption">&nbsp;</font></td>
									</tr>
									<tr>
										<td colspan=2><div class="hrule-dots"></div></td>
									</tr>
									<tr>
										<th>Blocked in IFAPRD</th>
										<td>When the product is listed in the IFAPRD member as
											"Disable"</td>
									</tr>
									<tr>
										<th>Customer managed</th>
										<td>The customer manages the support and installation of
											the product</td>
									</tr>
									<tr>
										<th>Duplicate product - In Use</th>
										<td>If SoftAudit has identified a product multiple times,
											mark this one as duplicate product and add a comment as to
											the product name it is a duplicate of. Make sure that the
											correct occurrence is marked as a valid product</td>
									</tr>
									<tr>
										<th>Misidentification</th>
										<td>Softaudit identified this as one product but it is
											really another product. Add a comment as to the correct
											product name</td>
									</tr>
									<tr>
										<th>Part of Another Product</th>
										<td>If the product is a free feature of or included in
											another product and not available separately. Add a comment
											as to what product this is part of</td>
									</tr>
									<tr>
										<th>Shared DASD (not in use on this LPAR)</th>
										<td>Product is on Shared DASD and used on another system
											but not needed on this system. Add comment as to what LPAR
											this product is used on</td>
									</tr>
									<tr>
										<th>Vendor Key Required but Not Present</th>
										<td>If the product is installed but cannot run because a
											key is required and has not been installed</td>
									</tr>
									<tr>
										<th>Restrictive vendor key</th>
										<td>A vendor packages many related products together and
											then supplies a key specific to some combination of those
											products. (aka. the ones you have licensed). The other
											products are installed but are not accessable by this
											restricted key. (ex. SAS) Mark these other products that can
											not be accessed as: Invalid. Restrictive Vendor Key. Add a
											comment to state what product package they are part of</td>
									</tr>
									<tr>
										<td></td>
									</tr>
									<tr>
										<th colspan="2">NOTE: If the product does not fall into
											any of the categories above, it should be marked "Valid"</th>
									</tr>
								</table>


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
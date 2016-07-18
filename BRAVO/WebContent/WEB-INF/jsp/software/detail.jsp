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

<title>Bravo Software: <c:out
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
							&gt;
							<html:link page="/software/view.do?id=${software.id}">
								${software.software.softwareName}
							</html:link>
						</p>
						<h1>
							Software Detail: <font class="green-dark"> <c:out
								value="${software.software.softwareName}" /></font>
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
										Software <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<table
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<thead>
										<tr>
											<th class="blue-med" width="1%"></th>
											<th class="blue-med">Name</th>
											<th class="blue-med">Manufacturer</th>
											<th class="blue-med">License Level</th>
											<th class="blue-med">Discrepancy</th>
										</tr>
									</thead>
									<tbody>
										<tr>
											<td><c:choose>
													<c:when test="${software.status == 'ACTIVE'}">
														<img alt="ACTIVE"
															src="<c:out value="${software.statusIcon}"/>" width="12"
															height="10" />
													</c:when>
													<c:otherwise>
														<img alt="INACTIVE"
															src="<c:out value="${software.statusIcon}"/>" width="12"
															height="10" />
													</c:otherwise>
												</c:choose>
												<td><font class="orange-dark"> <html:link
														page="/software/update.do?id=${software.id}">
														<c:out value="${software.software.softwareName}" />
													</html:link> <br />
												</font></td>
												<td><font class="orange-dark"> <c:out
														value="${software.software.manufacturer.manufacturerName}" /></font></td>
												<td><font class="orange-dark"> <c:out
														value="${software.licenseLevel}" /></font></td>
												<td><font class="orange-dark"> <c:out
														value="${software.discrepancyType.name}" /></font></td> <%
 	/*
 %>
												<td><img
													src="<c:out value="${account.customer.statusIcon}"/>"
													width="12" height="10" /></td> <%
 	*/
 %>
										</tr>
									</tbody>
								</table>

								<div class="indent">
									<h3>
										Tivoli Signatures <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="signatureList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<display:setProperty name="basic.empty.showtable" value="true" />

									<display:column property="softwareSignature.fileName"
										title="Name" headerClass="blue-med" />
									<display:column property="softwareSignature.fileSize"
										title="Size" headerClass="blue-med" />
									<display:column property="softwareSignature.softwareVersion"
										title="Version" headerClass="blue-med" />
									<display:column property="path" title="Path"
										headerClass="blue-med" />

								</display:table>

								<div class="indent">
									<h3>
										Tivoli Filters <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="filterList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<display:setProperty name="basic.empty.showtable" value="true" />

									<display:column property="softwareFilter.softwareName"
										title="Name" headerClass="blue-med" />
									<display:column property="softwareFilter.softwareVersion"
										title="Version" headerClass="blue-med" />
								</display:table>

								<div class="indent">
									<h3>
										Soft Audit Products <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="softAuditList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<display:setProperty name="basic.empty.showtable" value="true" />

									<display:column property="saProduct.saProduct"
										title="Soft Audit Product ID" headerClass="blue-med" />
									<display:column property="saProduct.version" title="Version"
										headerClass="blue-med" />
								</display:table>

								<div class="indent">
									<h3>
										VM Products <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="vmList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<display:setProperty name="basic.empty.showtable" value="true" />

									<display:column property="vmProduct.vmProduct" title="Name"
										headerClass="blue-med" />
									<display:column property="vmProduct.version" title="Version"
										headerClass="blue-med" />
								</display:table>

								<div class="indent">
									<h3>
										Software Script <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="scriptList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<display:setProperty name="basic.empty.showtable" value="true" />

									<display:column property="softwareScript.softwareName"
										title="Software Script Software Name" headerClass="blue-med" />
									<display:column property="softwareScript.softwareVersion"
										title="Version" headerClass="blue-med" />
									<display:column property="softwareScript.status"
										title="Status" headerClass="blue-med" />
								</display:table>

								<div class="indent">
									<h3>
										TADZ Products <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="tadzList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two"
									id="small">
									<display:setProperty name="basic.empty.showtable" value="true" />

									<display:column property="softwareItem.name"
										title="FEATURE NAME" headerClass="blue-med" />

									<display:column title="MANUFACTURER" headerClass="blue-med">
										<c:if test="${small.softwareItem.mainframeVersion ne null}">
											<c:out
												value="${small.softwareItem.mainframeVersion.manufacturer.manufacturerName}" />
										</c:if>
										<c:if test="${small.softwareItem.mainframeFeature ne null}">
											<c:out
												value="${small.softwareItem.mainframeFeature.version.manufacturer.manufacturerName}" />
										</c:if>
									</display:column>
									<display:column title="Version" headerClass="blue-med">
										<c:if test="${small.softwareItem.mainframeVersion ne null}">
											<c:out value="${small.softwareItem.mainframeVersion.version}" />
										</c:if>
										<c:if test="${small.softwareItem.mainframeFeature ne null}">
											<c:out
												value="${small.softwareItem.mainframeFeature.version.version}" />
										</c:if>
									</display:column>
									<display:column property="useCount" title="USEcn"
										headerClass="blue-med" />
									<display:column property="lastUsed" title="LastUP"
										headerClass="blue-med" />
								</display:table>

								<div class="indent">
									<h3>
										Comment History <a class="ibm-question-link"
											href="/BRAVO/help/help.do"></a>
									</h3>
								</div>
								<display:table name="commentList" requestURI=""
									class="ibm-data-table ibm-sortable-table ibm-alternate-two">
									<display:setProperty name="basic.empty.showtable" value="true" />

									<display:column property="action" title="Action"
										headerClass="blue-med" />
									<display:column property="remoteUser" title="User"
										headerClass="blue-med" />
									<display:column property="recordTime" title="Record Time"
										headerClass="blue-med" />
									<display:column property="comment" title="Comment"
										headerClass="blue-med" />
								</display:table>

							</div>
						</div>
					</div>


					<!-- FEATURES_BEGIN -->
					<div id="ibm-content-sidebar">
						<div class="ibm-container">
							<h2 class="ibm-rule">
								Actions <a class="ibm-question-link" href="/BRAVO/help/help.do"></a>
							</h2>
							<div class="ibm-container-body">
								<ul class="ibm-link-list">

									<!-- Update Software Discrepancy (Update Software Discrepancy) -->
									<li><a class="ibm-forward-link"
										href="/BRAVO/software/update.do?id=${software.id}">Update
											Software Discrepancy</a></li>
								</ul>

								<h2 class="ibm-rule">
									Reports <a class="ibm-question-link" href="/BRAVO/help/help.do"></a>
								</h2>
								<ul class="ibm-link-list">
									<!-- Global Discrepancies Report -->
									<li><a class="ibm-download-link"
										href="/BRAVO/download/${software.software.softwareName} on ${account.customer.accountNumber}.tsv?name=accountSoftware&softwareId=${software.software.softwareId}&accountId=${account.customer.accountNumber}">All
											LPARs With This Software</a></li>

								</ul>

								<div class="indent">
									<font color="red" size="1"> Signatures, filters, and
									product id's are considered IBM confidential intellectual
									capital. Do NOT share these with outside organizations and
									customers. </font>
								</div>
								<br />

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

					<li id="ibm-parent-link"><a href="https://ibm.biz/gamwiki">Asset
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

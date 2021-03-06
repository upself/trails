<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" lang="en" xml:lang="en">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
<link rel="schema.DC" href="http://purl.org/DC/elements/1.0/" />
<link rel="SHORTCUT ICON" href="http://www.ibm.com/favicon.ico" />
<meta name="DC.Rights" content="� Copyright IBM Corp. 2011" />
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
<%@ taglib uri="http://jakarta.apache.org/struts/tags-tiles"
	prefix="tmp"%>
<%@ taglib prefix="req"
	uri="http://jakarta.apache.org/taglibs/request-1.0"%>

<title>Machine Type Search</title>
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
					<li id="ibm-home"><a href="http://www.ibm.com/">IBM�</a></li>
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
							<html:link page="/admin/home.do">
								Administration
							</html:link>
							&gt;
							<html:link page="/admin/machinetype/home.do">
								Machine Types
							</html:link>
						</p>
						<h1>Machine Type Search</h1>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">

								<html:img alt="Scenic overlook telescope"
									page="/images/p1_w3v8_19.jpg" align="left" hspace="10"
									vspace="10" />
								<br />
								<p style="color: #c60" class="caption">Machine Type Search</p>
								<br /> Navigate using the toolbar to the left or <b><font
									style="color: #7a3" class="caption">search</font></b> below.<br />
								<br clear="all" />

								<req:isUserInRole role="com.ibm.ea.bravo.user">
									<html:form action="/search">
										<html:hidden property="context" value="machineType" />
										<table border="0" width="80%" cellspacing="10" cellpadding="0">
											<tbody>
												<tr align="center">
													<td nowrap="nowrap">
														<div class="invalid">
															<html:errors property="search" />
														</div>
													</td>
												</tr>
												<tr align="center">
													<td nowrap="nowrap"><html:text property="search"
															styleClass="input" /></td>
												</tr>
												<tr align="center">
													<td nowrap="nowrap"><span class="button-blue"><html:submit
																property="type" value="Name" /></span> <span
														class="button-blue"><html:submit property="type"
																value="Type" /></span> <span class="button-blue"><html:submit
																property="type" value="Definition" /></span></td>
												</tr>
											</tbody>
										</table>
									</html:form>
								</req:isUserInRole>
								
								<br />
								<br />
								<table border="0" cellpadding="2" cellspacing="0" width="100%">
									<tr>
										<td width="33%"><font style="color: #7a3" class="caption">Quick
											Links:</font></td>
										<td width="33%" style="color: #7a3" class="caption">Quick
											Search:</td>
										<td width="33%" style="color: #7a3" class="caption">Help
											Contacts:</td>
									</tr>
									<tr>
										<td colspan=3>
											<div class="hrule-dots"></div>
										</td>
									</tr>
									<tr>
										<td><img alt=""
											src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
											width="13" height="13" /> <html:link page="/access/init.do">Register for access to BRAVO</html:link>
											<br /> <br /></td>
										<td><img alt=""
											src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
											width="13" height="13" /> <html:link
												page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=all">All Active Types</html:link>
										</td>
										<td>Please direct all inquires to:<br />
										</td>
									</tr>
									<tr>
										<td></td>
										<td><img alt=""
											src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
											width="13" height="13" /> <html:link
												page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=all">All Records</html:link>
										</td>
										<td></td>
									</tr>
									<tr>
										<td></td>
										<td><img alt=""
											src="//w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
											width="13" height="13" /> <html:link
												page="/admin/machinetype/quicksearch.do?action=LIST&search=&searchtype=recentadd">Recently Added Types</html:link>
										</td>
										<td></td>
									</tr>
								</table>
								<br /> <br />

							</div>

						</div>
					</div>
				</div>
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
	</div>
	<div id="ibm-metrics">
		<script src="//www.ibm.com/common/stats/stats.js"
			type="text/javascript">
			//
		</script>
	</div>
  </body>
</html>

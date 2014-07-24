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
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>


<title>Bank accounts - <logic:equal scope="request"
		name="bankAccountForm" property="connectionType" value="CONNECTED">Connected</logic:equal><logic:equal
		scope="request" name="bankAccountForm" property="connectionType"
		value="DISCONNECTED">Disconnected</logic:equal> - Add/Edit
</title>

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
							<html:link page="/">BRAVO</html:link>
							&gt;
							<html:link page="/bankAccount/home.do">Bank accounts</html:link>
							&gt;
							<logic:equal scope="request" name="bankAccountForm"
								property="connectionType" value="CONNECTED">
								<html:link page="/bankAccount/connected.do">Connected</html:link>
							</logic:equal>
							<logic:equal scope="request" name="bankAccountForm"
								property="connectionType" value="DISCONNECTED">
								<html:link page="/bankAccount/disconnected.do">Disconnected</html:link>
							</logic:equal>
						</p>
					</div>
				</div>
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">
								<h1>
									Add/Edit
									<logic:equal scope="request" name="bankAccountForm"
										property="connectionType" value="CONNECTED">connected</logic:equal>
									<logic:equal scope="request" name="bankAccountForm"
										property="connectionType" value="DISCONNECTED">disconnected</logic:equal>
									bank account
								</h1>
								<p>
									Use this form to
									<logic:empty scope="request" name="bankAccountForm"
										property="id">request a new</logic:empty>
									<logic:notEmpty scope="request" name="bankAccountForm"
										property="id">update a</logic:notEmpty>
									<logic:equal scope="request" name="bankAccountForm"
										property="connectionType" value="CONNECTED">connected</logic:equal>
									<logic:equal scope="request" name="bankAccountForm"
										property="connectionType" value="DISCONNECTED">disconnected</logic:equal>
									bank account. When you are finished, press the Submit button.
									Press the Cancel button to discard your changes.
								</p>
								<p>Required fields are marked with an asterisk(*) and must
									be filled in to complete the form.</p>
								<p class="hrule-dots" />

								<p>
									<logic:notEmpty scope="request" name="bankAccountForm"
										property="id">
					To change this bank account to a
					<logic:equal scope="request" name="bankAccountForm"
											property="connectionType" value="CONNECTED">disconnected</logic:equal>
										<logic:equal scope="request" name="bankAccountForm"
											property="connectionType" value="DISCONNECTED">connected</logic:equal>
					bank account click
					<html:submit onclick="setChange()">here</html:submit>.
				</logic:notEmpty>
								</p>

								<logic:messagesPresent>
									<html:messages id="msg">
										<li class="red-dark"><bean:write name="msg" /></li>
									</html:messages>
								</logic:messagesPresent>
								<html:form action="/bankAccount/bankAccountSave">
									<html:hidden styleId="id" property="id" />
									<html:hidden styleId="connectionType" property="connectionType" />
									<html:hidden styleId="connectionStatus"
										property="connectionStatus" />
									<logic:empty scope="request" name="bankAccountForm"
										property="id">
										<html:hidden styleId="status" property="status" />
									</logic:empty>
									<table cellpadding="2" cellspacing="1" border="0">
										<tbody>
											<logic:notEmpty scope="request" name="bankAccountForm"
												property="id">
												<tr>
													<td></td>
													<td>Bank account ID:</td>
													<td><bean:write name="bankAccountForm" property="id" /></td>
												</tr>
											</logic:notEmpty>
											<tr>
												<td>*</td>
												<td><label for="name">Bank account name:</label></td>
												<td>
													<div class="input-note">maximum 32 characters</div> <html:text
														styleId="name" property="name" styleClass="input"
														size="40" maxlength="32" />
												</td>
											</tr>
											<tr>
												<td>*</td>
												<td><label for="description">Bank account
														description:</label></td>
												<td>
													<div class="input-note">maximum 128 characters</div> <html:text
														styleId="description" property="description"
														styleClass="input" size="40" maxlength="128" />
												</td>
											</tr>
											<tr>
												<td>*</td>
												<td><label for="type">Bank account type:</label></td>
												<td>
													<div class="input-note">Select one</div> <html:select
														styleId="type" property="type" styleClass="input">
														<html:option value="">-SELECT-</html:option>
														<html:option value="TCM">TCM</html:option>
														<html:option value="TLM">TLM</html:option>
														<html:option value="SMS">SMS</html:option>
														<html:option value="SNAPSHOT">SNAPSHOT</html:option>
														<html:option value="EESM">EESM</html:option>
														<html:option value="BLAZANT">BLAZANT</html:option>
														<html:option value="ALTIRIS">ALTIRIS</html:option>
														<html:option value="IDD">IDD</html:option>
														<html:option value="TADZ">TADZ</html:option>
														<logic:equal scope="request" name="bankAccountForm"
															property="connectionType" value="DISCONNECTED">
															<html:option value="FACTS">FACTS</html:option>
															<html:option value="TAD4D">TAD4D</html:option>
														</logic:equal>
														<logic:equal scope="request" name="bankAccountForm"
															property="connectionType" value="CONNECTED">
															<html:option value="ATP">ATP</html:option>
															<html:option value="SWCM">SWCM</html:option>
														</logic:equal>
													</html:select>
												</td>
											</tr>
											<tr>
												<td>*</td>
												<td><label for="version">Bank account version:</label></td>
												<td>
													<div class="input-note">Select one</div> <html:select
														styleId="version" property="version" styleClass="input">
														<html:option value="">-SELECT-</html:option>
														<html:option value="1.0">1.0</html:option>
														<html:option value="4.2">4.2</html:option>
														<html:option value="4.2.3.2">4.2.3 FixPack 2</html:option>
														<html:option value="8.1">8.1</html:option>
													</html:select>
												</td>
											</tr>
											<tr>
												<td>*</td>
												<td><label for="dataType">Data type:</label></td>
												<td>
													<div class="input-note">Select one</div> <html:select
														styleId="dataType" property="dataType" styleClass="input">
														<html:option value="">-SELECT-</html:option>
														<html:option value="ATP">ATP</html:option>
														<html:option value="BASELINE">BASELINE</html:option>
														<html:option value="INVENTORY">INVENTORY</html:option>
													</html:select>
												</td>
											</tr>
											<logic:equal scope="request" name="bankAccountForm"
												property="connectionType" value="CONNECTED">
												<tr>
													<td>*</td>
													<td><label for="databaseType">Database type:</label></td>
													<td>
														<div class="input-note">Select one</div> <html:select
															styleId="databaseType" property="databaseType"
															styleClass="input">
															<html:option value="">-SELECT-</html:option>
															<html:option value="DB2">DB2</html:option>
														</html:select>
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td><label for="databaseVersion">Database
															version:</label></td>
													<td>
														<div class="input-note">Select one</div> <html:select
															styleId="databaseVersion" property="databaseVersion"
															styleClass="input">
															<html:option value="">-SELECT-</html:option>
															<html:option value="8.1">8.1</html:option>
															<html:option value="8.2">8.2</html:option>
														</html:select>
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td><label for="databaseName">Database name:</label></td>
													<td>
														<div class="input-note">maximum 8 characters</div> <html:text
															styleId="databaseName" property="databaseName"
															styleClass="input" size="40" maxlength="8" />
													</td>
												</tr>
												<tr>
													<td></td>
													<td><label for="databaseSchema">Database
															schema:</label></td>
													<td>
														<div class="input-note">maximum 16 characters</div> <html:text
															styleId="databaseSchema" property="databaseSchema"
															styleClass="input" size="40" maxlength="16" />
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td><label for="databaseIp">Database IP:</label></td>
													<td>
														<div class="input-note">maximum 15
															characters(x.x.x.x)</div> <html:text styleId="databaseIp"
															property="databaseIp" styleClass="input" size="40"
															maxlength="15" />
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td><label for="databasePort">Database port:</label></td>
													<td>
														<div class="input-note">maximum 16 characters</div> <html:text
															styleId="databasePort" property="databasePort"
															styleClass="input" size="40" maxlength="16" />
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td><label for="databaseUser">Database user
															name:</label></td>
													<td>
														<div class="input-note">maximum 16 characters</div> <html:text
															styleId="databaseUser" property="databaseUser"
															styleClass="input" size="40" maxlength="16" />
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td><label for="databasePassword">Database
															password:</label></td>
													<td>
														<div class="input-note">maximum 16 characters</div> <html:password
															styleId="databasePassword" property="databasePassword"
															styleClass="input" size="40" maxlength="16" />
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td>Socks connection required:</td>
													<td>
														<div class="input-note">Select one:</div> <label
														for="radio_socks_y"></label> <html:radio
															styleId="radio_socks_y" property="socks" value="Y">YES</html:radio>
														<label for="radio_socks_n"></label> <html:radio
															styleId="radio_socks_n" property="socks" value="N">NO</html:radio>
													</td>
												</tr>
												<tr>
													<td>*</td>
													<td>SSH tunnel connection required:</td>
													<td>
														<div class="input-note">Select one:</div> <label
														for="radio_tunnel_y"></label> <html:radio
															styleId="radio_tunnel_y" property="tunnel" value="Y">YES</html:radio>
														<label for="radio_tunnel_n"></label> <html:radio
															styleId="radio_tunnel_n" property="tunnel" value="N">NO</html:radio>
													</td>
												</tr>
												<tr>
													<td></td>
													<td><label for="text_tunnelPort">Tunnel port:</label></td>
													<td>
														<div class="input-note">integer</div> <html:text
															styleId="text_tunnelPort" property="tunnelPort"
															styleClass="input" size="40" maxlength="16" />
													</td>
												</tr>
											</logic:equal>
											<tr>
												<td>*</td>
												<td>Authenticated data:</td>
												<td>
													<div class="input-note">Select one:</div> <label
													for="radio_authenticationData_yes"></label> <html:radio
														styleId="radio_authenticationData_yes"
														property="authenticatedData" value="Y">YES</html:radio> <label
													for="radio_authenticationData_no"></label> <html:radio
														styleId="radio_authenticationData_no"
														property="authenticatedData" value="N">NO</html:radio>
												</td>
											</tr>

											<logic:equal scope="request" name="bankAccountForm"
												property="connectionType" value="CONNECTED">
												<tr>
													<td>*</td>
													<td>Synchronize signatures:</td>
													<td>
														<div class="input-note">Select one:</div> <label
														for="radio_syncSig_y"></label> <html:radio
															styleId="radio_syncSig_y" property="syncSig" value="Y">YES</html:radio>
														<label for="radio_syncSig_n"></label> <html:radio
															styleId="radio_syncSig_n" property="syncSig" value="N">NO</html:radio>
													</td>
												</tr>
											</logic:equal>

											<logic:notEmpty scope="request" name="bankAccountForm"
												property="id">
												<tr>
													<td>*</td>
													<td><label for="select_status">Status:</label></td>
													<td>
														<div class="input-note">Select one:</div> <html:select
															styleId="select_status" property="status"
															styleClass="input">
															<html:option value="ACTIVE">ACTIVE</html:option>
															<html:option value="INACTIVE">INACTIVE</html:option>
														</html:select>
													</td>
												</tr>
											</logic:notEmpty>

											<logic:equal scope="request" name="bankAccountForm"
												property="connectionType" value="CONNECTED">
												<tr>
													<td></td>
													<td><label for="text_technicalContact">Technical
															contact:</label></td>
													<td>
														<div class="input-note">maximum 255 characters</div> <html:text
															styleId="text_technicalContact"
															property="technicalContact" styleClass="input" size="40"
															maxlength="255" />
													</td>
												</tr>
												<tr>
													<td></td>
													<td><label for="text_businessContact">Business
															contact:</label></td>
													<td>
														<div class="input-note">maximum 255 characters</div> <html:text
															styleId="text_businessContact" property="businessContact"
															styleClass="input" size="40" maxlength="255" />
													</td>
												</tr>
											</logic:equal>

											<logic:equal scope="request" name="bankAccountForm"
												property="connectionType" value="DISCONNECTED">
												<tr>
													<td></td>
													<td><label for="text_technicalContact">Technical
															contact:</label></td>
													<td>
														<div class="input-note">maximum 255 characters</div> <html:text
															styleId="text_technicalContact"
															property="technicalContact" styleClass="inputlong"
															size="40" maxlength="255" />
													</td>
												</tr>
												<tr>
													<td></td>
													<td><label for="text_businessContact">Business
															contact:</label></td>
													<td>
														<div class="input-note">maximum 255 characters</div> <html:text
															styleId="text_businessContact" property="businessContact"
															styleClass="inputlong" size="40" maxlength="255" />
													</td>
												</tr>
											</logic:equal>
										</tbody>
									</table>
									<p />
									<div class="hrule-dots"></div>
									<div class="clear"></div>
									<div class="button-bar">
										<div class="buttons">
											<span class="button-blue"> <html:submit>Submit</html:submit>
												<html:cancel onkeypress="return(this.onclick());">Cancel</html:cancel>
											</span>
										</div>
									</div>
								</html:form>
								<br /> <br />
							</div>
						</div>
					</div>

					<!-- FEATURES_BEGIN -->
					<div id="ibm-content-sidebar">
						<div class="ibm-container">
							<h2 class="ibm-first">
								Actions <a class="ibm-question-link"
									href="BRAVO/help/help.do#H9"></a>
							</h2>
							<div class="ibm-container-body"></div>
						</div>
					</div>

					<!-- FEATURES_END -->
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
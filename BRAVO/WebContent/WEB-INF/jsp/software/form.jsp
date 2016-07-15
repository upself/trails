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

<%-- <script src="${pageContext.request.contextPath}/WebContent/js/jquery/jquery.js"></script> --%>
<script src="/BRAVO/javascript/jquery.js"></script>
<script type="text/javascript">

	function validateDescripancy(){

		var descrepancyType = document.getElementsByName("discrepancyTypeId")[0];
		var isDiscFalseHit = false;
		var isDiscValid = false;
		var isDiscNone = false;
		var isDiscInvalid = false;
		var isSwCatComplex = false;
		var isSwCatEmpty = false;
		var isSwCatIBM = false;
		var isSwCatIFAPRD = false;
		
		for(var i = 0; i < descrepancyType.length; i++){
			if(descrepancyType.options[i].selected){
				var descreVal = descrepancyType.options[i].text;
				if(descreVal == "FALSE HIT"){
					isDiscFalseHit = true;
				} else if (descreVal == "VALID"){
					isDiscValid = true;
				} else if (descreVal == "NONE"){
					isDiscNone = true;
				} else if (descreVal == "INVALID"){
					isDiscInvalid = true;
				}
			}
		}
		
		var invalideCate = document.getElementsByName("invalidCategory")[0];
		for(var j = 0 ; j < invalideCate.length; j++){
			if(invalideCate.options[j].selected){
			   var swCategory = invalideCate.options[j].text;
			   if(swCategory == ""){
					isSwCatEmpty = true;
				} else if (swCategory == "Blocked in IFAPRD"){
					isSwCatIFAPRD = true;
			   } else if (swCategory == "Complex discovery"){
					isSwCatComplex = true;
			   } else if (swCategory == "IBM SW GSD Build"){
					isSwCatIBM = true;
			   }
			}
		}
		
		if(isSwCatIFAPRD){
			if(!isDiscInvalid){
				alert ("The Software Category \"Blocked in IFAPRD\" is only valid for the Discrepancy \"INVALID\"");
				return false;
			}
		}
		
		if(isSwCatIBM){
			if(!isDiscInvalid){
				alert ("The Software Category \"IBM SW GSD Build\" is only valid for the Discrepancy \"INVALID\"");
				return false;
			}
		}

		if(isSwCatEmpty){
			if(!isDiscValid || !isDiscNone){
				alert ("The Software Category \"empty\" is only valid for the Discrepancy \"VALID\" and \"NONE\"");
				return false;
			}
		}

		if(isSwCatComplex){
			if(!isDiscFalseHit){
				alert ("The Software Category \"Complex discovery\" is only valid for the Discrepancy \"FALSE HIT\"");
				return false;
			}
		}
	}

	function discrepancyChange(){
		var descrepancyType = document.getElementsByName("discrepancyTypeId")[0];
		var softwareCategory = document.getElementsByName("invalidCategory")[0];
		var empty, IFAPRD, complexDisc, IBM;
		
	    for(var i = 0; i < softwareCategory.length; i++){
	    	if (softwareCategory.options[i].value == '') {
	    		empty = softwareCategory.options[i];
	    		empty.style.display = "";
			}
	    	if (softwareCategory.options[i].value == 'Blocked in IFAPRD') {
				IFAPRD = softwareCategory.options[i];
				IFAPRD.style.display = "";
			}
			if (softwareCategory.options[i].value == 'Complex discovery') {
				complexDisc = softwareCategory.options[i];
				complexDisc.style.display = "";
			}
			if (softwareCategory.options[i].value == 'IBM SW GSD Build') {
				IBM = softwareCategory.options[i];
				IBM.style.display = "";
			}
	    }

	    for(var i = 0; i < descrepancyType.length; i++){
			if(descrepancyType.options[i].selected){
				var descreVal=descrepancyType.options[i].text;
				
				if(descreVal=="INVALID"){
					complexDisc.style.display = "none";
				} else if (descreVal == "VALID") {
					IFAPRD.style.display = "none";
					complexDisc.style.display = "none";
					IBM.style.display = "none";
				} else if (descreVal == "FALSE HIT") {
					IFAPRD.style.display = "none";
					complexDisc.style.display = "none";
					IBM.style.display = "none";
				} else if (descreVal == "NONE") {
					IFAPRD.style.display = "none";
					complexDisc.style.display = "none";
					IBM.style.display = "none";
				} else if (descreVal == "FH RESET") {
					empty.style.display = "none";
					IFAPRD.style.display = "none";
					complexDisc.style.display = "none";
					IBM.style.display = "none";
				}
			}
		}
	}

</script>

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
							testing 1
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
												<td>
													<c:choose>
														<c:when
															test="${software.readOnly['discrepancyType'] == true}">
															<html:hidden property="discrepancyTypeId" />
															<input type="text" class="inputlong"
																value="${software.discrepancyType.name}"
																readonly="readonly" />
														</c:when>
														<c:otherwise>
														<!-- ab added sprint9 story 27299 -->
															<html:select onchange="discrepancyChange()" property="discrepancyTypeId" styleClass="inputlong">
																<html:optionsCollection property="discrepancyTypeList" />
															</html:select>
														</c:otherwise>
													</c:choose>
												</td>
												<td class="error"><html:errors
														property="discrepancyType" /></td>
											</tr>
											<tr>
												<td nowrap="nowrap">Software Category:</td>
												<td><html:select onclick="discrepancyChange()" property="invalidCategory"
														styleClass="inputlong"
														disabled="${software.readOnly['invalidCategory']}">
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
															styleClass="ibm-btn-view-pri" onclick="return validateDescripancy()" /> <html:submit
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
										<td>Software component has not been validated yet</td>
									</tr>
									<tr>
										<th>FALSE HIT</th>
										<td>Incorrectly identified installed software component</td>
									</tr>
									<tr>
										<th>INVALID</th>
										<td>Indicates the software component which is confirmed as Blocked in IFAPRD</td>
									</tr>
									<tr>
										<th>FH RESET</th>
										<td>Software component was marked as FALSE HIT for longer then the allowed period and therefore returned back to the scope</td>
									</tr>
									<tr>
										<th>VALID</th>
										<td>The discovery of the software component is confirmed as valid</td>
									</tr>									
									<tr>
										<td></td>
									</tr>
									<tr>
										<td width="40%"><font style="color:#7a3" class="caption">
											Software Categories:</font></td>
										<td><font style="color:#7a3" class="caption">&nbsp;</font></td>
									</tr>
									<tr>
										<td colspan=2><div class="hrule-dots"></div></td>
									</tr>
									<tr>
										<th>IBM SW GSD Build</th>
										<td>Used to mark those products (with NO use) which may have been delivered in error and any removal may pose a risk due to the mixed product load libraries instance.  Will improve with GSD z/OS V2.2 where all PSF V4.5 features can exploit IFAPRDxx to disable the product.</td>
									</tr>
									<tr>
										<th>Complex discovery</th>
										<td>Used for managing complex discovery when components are discovered by advanced discovery method</td>
									</tr>
									<tr>
										<th>Blocked in IFAPRD</th>
										<td>When the software component is listed in the IFAPRD member as "Disable"</td>
									</tr>
									<tr>
										<td></td>
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

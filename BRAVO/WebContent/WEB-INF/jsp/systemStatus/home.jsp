<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="req"
	uri="http://jakarta.apache.org/taglibs/request-1.0"%>

<html lang="en">
<head>
<title>System Status Home</title>

<link rel="stylesheet"
	href="http://code.jquery.com/ui/1.10.3/themes/smoothness/jquery-ui.css" />
<script src="http://code.jquery.com/jquery-1.9.1.js"></script>
<script src="http://code.jquery.com/ui/1.10.3/jquery-ui.js"></script>
<link rel="stylesheet" href="/resources/demos/style.css" />

<tmp:insert page="/WEB-INF/jsp/common/w3Header.jsp" />
</head>

<body id="w3-ibm-com" class="article">
	<tmp:insert page="/WEB-INF/jsp/common/w3Accessibility.jsp" />
	<tmp:insert page="/WEB-INF/jsp/common/w3Masthead.jsp" />

	<!-- BEGIN CONTENT -->
	<div id="content">
		<h1 class="access">Start of main content</h1>

		<!-- BEGIN CONTENT HEAD -->
		<div id="content-head">
			<p id="date-stamp">New as of 26 January 2009</p>
			<div class="hrule-dots"></div>
			<p id="breadcrumbs">
				<html:link page="/">BRAVO</html:link>
				&gt;
				<html:link page="/systemStatus/home.do">System status</html:link>
			</p>
		</div>

		<!-- BEGIN MAIN CONTENT -->
		<div id="content-main">
			<!-- BEGIN PARTIAL-SIDEBAR -->
			<div id="partial-sidebar">
				<h2 class="access">Start of sidebar content</h2>

				<div class="action">
					<h2 class="bar-gray-med-dark">
						Actions
						<html:link page="/help/help.do#H9">
							<img alt="Help"
								src="//w3.ibm.com/ui/v8/images/icon-help-contextual-light.gif"
								width="14" height="14" alt="Contextual field help icon" />
						</html:link>
					</h2>
				</div>
				<br />

			</div>
			<!-- END PARTIAL-SIDEBAR -->

			<html:form action="/systemStatus/submit_form">
				<table border="0" width="40%" cellspacing="10" cellpadding="0">
					<tbody>
						<tr>
							<td><label for="id_type">Bank account</label>:</td>
							<td><html:select property="bankAccount">
									<html:option value="0">Show All Bank Accounts</html:option>
									<html:options collection="bankAccountNames"
										labelProperty="name" property="id" />
								</html:select></td>
						</tr>
						<tr>
							<td><label for="id_type">Module/Loader</label>:</td>
							<td><html:select styleId="id_type" property="moduleLoader"
									styleClass="inputlong">
									<html:option value="Show All">Show All</html:option>
									<html:option value="SCAN RECORD">SCAN RECORD</html:option>
									<html:option value="SOFTWARE SIGNATURE">SOFTWARE SIGNATURE</html:option>
									<html:option value="SOFTWARE FILTER">SOFTWARE FILTER</html:option>
									<html:option value="PROCESSOR">PROCESSOR</html:option>
									<html:option value="HDISK">HDISK</html:option>
									<html:option value="MEMMOD">MEMMOD</html:option>
									<html:option value="IP ADDRESS">IP ADDRESS</html:option>
								</html:select></td>
						</tr>
						<tr>
							<td></td>
							<td><html:checkbox property="delta_checkbox" /> <label
								for="id_type">Include delta loads</label></td>
						</tr>
						<tr>
							<td><label for="id_type">Loader status</label>:</td>
							<td><html:select styleId="id_type" property="loaderStatus"
									styleClass="inputlong">
									<html:option value="Show All">Show All</html:option>
									<html:option value="COMPLETE">COMPLETE</html:option>
									<html:option value="PENDING">PENDING</html:option>
									<html:option value="ERROR">ERROR</html:option>
									<%-- 									<html:option value="ERROR - Technical">ERROR - Technical</html:option> --%>
									<%-- 									<html:option value="ERROR - 15% Threshold">ERROR - 15% Threshold</html:option> --%>
									<%-- 									<html:option value="ERROR - Long Run">ERROR - Long Run</html:option> --%>
								</html:select></td>
						</tr>
						<tr>
							<td colspan="2">Date from:<html:text
									styleId="datepicker_from" property="date_from"
									styleClass="inputshortish" /> Date to:<html:text
									styleId="datepicker_to" property="date_to"
									styleClass="inputshortish" />
							</td>


						</tr>
						<tr>
							<td><span class="button-blue"> <html:submit
										property="action" value="Submit" />
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
				requestURI="" class="bravo" defaultsort="1"
				defaultorder="ascending">
				<display:setProperty name="basic.empty.showtable" value="true" />
				<display:column property="bankAccount.name"
					title="Bank account name" sortable="true" headerClass="blue-med"
					group="1">
				</display:column>

				<display:column property="name" title="Module" sortable="true"
					headerClass="blue-med" />
				<display:column property="comments" title="Comments" sortable="true"
					headerClass="blue-med" />
				<display:column property="startTime" class="date"
					format="{0,date,MM-dd-yyyy HH:mm:ss}" title="Start time"
					sortable="true" headerClass="blue-med" />
				<display:column property="endTime" class="date"
					format="{0,date,MM-dd-yyyy HH:mm:ss}" title="End time"
					sortable="true" headerClass="blue-med" />
				<display:column property="elapsedTime" title="Elapsed time"
					sortable="false" headerClass="blue-med" style="white-space:nowrap" />
				<display:column property="status" title="Status" sortable="true"
					headerClass="blue-med" />
			</display:table>
			
			<h1>System status</h1>
			<display:table cellspacing="2" cellpadding="0"
				name="systemScheduleStatusList" id="table_system status_row"
				requestURI="" class="bravo" defaultsort="1" defaultorder="ascending">
				<display:setProperty name="basic.empty.showtable" value="true" />
				<display:column property="name" title="Module" sortable="true"
					headerClass="blue-med" />
				<display:column property="comments" title="Comments" sortable="true"
					headerClass="blue-med" />
				<display:column property="startTime" class="date"
					format="{0,date,MM-dd-yyyy HH:mm:ss}" title="Start time"
					sortable="true" headerClass="blue-med" />
				<display:column property="endTime" class="date"
					format="{0,date,MM-dd-yyyy HH:mm:ss}" title="End time"
					sortable="true" headerClass="blue-med" />
				<display:column property="elapsedTime" title="Elapsed time"
					sortable="false" headerClass="blue-med" style="white-space:nowrap" />
				<display:column property="status" title="Status" sortable="true"
					headerClass="blue-med" />
			</display:table>
		</div>
		<!-- END MAIN CONTENT -->
	</div>
	<!-- END CONTENT -->
	<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
</body>
</html>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib prefix="req" uri="http://jakarta.apache.org/taglibs/request-1.0"%>

<html lang="en">
	<head>
		<title>Bank accounts - Connected</title>
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
				<p id="date-stamp">New as of 17 February 2009</p>
				<div class="hrule-dots"></div>
				<p id="breadcrumbs">
					<html:link page="/">BRAVO</html:link> &gt;
					<html:link page="/bankAccount/home.do">Bank accounts</html:link>
				</p>
			</div>

			<!-- BEGIN MAIN CONTENT -->
			<div id="content-main">
				<!-- BEGIN PARTIAL-SIDEBAR -->
				<div id="partial-sidebar">
					<h2 class="access">Start of sidebar content</h2>

					<div class="action">
						<h2 class="bar-gray-med-dark">Actions
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

				<h1>Connected bank accounts</h1>
				<display:table cellspacing="2" cellpadding="0" name="list" id="row"
					requestURI="" class="bravo" defaultsort="2" defaultorder="ascending">
					<display:setProperty name="basic.empty.showtable" value="true" />
					<display:column title="Status" property="statusImage"
						headerClass="blue-med" sortable="true" />
				<% boolean lbAdminRole = false; %>
					<req:isUserInRole role="com.ibm.tap.admin">
				<% lbAdminRole = true; %>
					</req:isUserInRole>
					<req:isUserInRole role="com.ibm.tap.sigbank.admin">
				<% lbAdminRole = true; %>
					</req:isUserInRole>
				<% if (lbAdminRole) { %>
					<display:column title="Name" property="name" headerClass="blue-med"
						sortable="true" href="connectedAddEdit.do" paramId="id"
						paramProperty="id" />
				<% } else { %>
					<display:column title="Name" property="name" headerClass="blue-med"
						sortable="true" />
				<% } %>
					<display:column title="Bank account ID" property="id"
						headerClass="blue-med" sortable="true" />
					<display:column title="Type" property="type" headerClass="blue-med"
						sortable="true" />
					<display:column title="Version" property="version"
						headerClass="blue-med" sortable="true" />
					<display:column title="Database type" headerClass="blue-med"
						property="databaseType" sortable="true" />
					<display:column title="Database version" headerClass="blue-med"
						property="databaseVersion" sortable="true" />
					<display:column title="Authenicated data" headerClass="blue-med"
						property="authenticatedData" sortable="true" />
					<display:column title="Synchronize signatures" headerClass="blue-med"
						property="syncSig" sortable="true" />
					<display:column title="Editor" headerClass="blue-med"
						property="remoteUser" sortable="true" />
					<display:column title="Last edited" headerClass="blue-med"
						property="recordTime" sortable="true" class="date"
						format="{0,date,MM-dd-yyyy HH:mm:ss}" />
					<display:column title="Connection status" property="connectionStatus"
						headerClass="blue-med" sortable="true" href="connectionStatus.do"
						paramId="id" paramProperty="id" />
				</display:table>

			</div>
			<!-- END MAIN CONTENT -->
		</div>
		<!-- END CONTENT -->
		<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
	</body>
</html>

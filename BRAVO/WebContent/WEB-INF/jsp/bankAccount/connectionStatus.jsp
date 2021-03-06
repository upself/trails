<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@ page language="java" contentType="text/html"%>
<%@ taglib prefix="html" uri="http://struts.apache.org/tags-html"%>
<%@ taglib prefix="tmp" uri="http://struts.apache.org/tags-tiles"%>
<%@ taglib prefix="display" uri="http://displaytag.sf.net"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>

<html lang="en">
	<head>
		<title>Bank accounts - Connected - Connection Status</title>
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
					<html:link page="/bankAccount/home.do">Bank accounts</html:link> &gt;
					<html:link page="/bankAccount/connected.do">Connected</html:link>
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

				<h1>Bank account status detail</h1>
				<display:table cellspacing="2" cellpadding="0" name="bankAccount"
					id="row" requestURI="" class="ibm-data-table ibm-sortable-table ibm-alternate-two">
					<display:setProperty name="basic.empty.showtable" value="true" />
					<display:column title="Connection status" property="connectionStatus"
						headerClass="blue-med" />
					<display:column title="Error" property="comments"
						headerClass="blue-med" />
				</display:table>
				<br />
				<br />

				<a href="http://tap2.raleigh.ibm.com/reports/temp/staging/mapping/<bean:write name="bankAccount" property="name"/>.tsv">Unmapped computers</a>

			</div>
			<!-- END MAIN CONTENT -->
		</div>
		<!-- END CONTENT -->
		<tmp:insert page="/WEB-INF/jsp/common/w3Navigation.jsp" />
	  </body>
</html>

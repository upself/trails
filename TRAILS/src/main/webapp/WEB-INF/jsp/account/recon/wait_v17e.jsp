<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html lang="en-ZZ" xml:lang="en-ZZ" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />

<!-- Add meta tag to consistently detect the width on an iPad at 768px -->
<meta name="viewport" content="width=device-width, initial-scale=1" />
<link rel="schema.DC" href="http://purl.org/DC/elements/1.0/" />
<link rel="SHORTCUT ICON" href="http://www.ibm.com/favicon.ico" />
<meta name="DC.Rights" content="© Copyright IBM Corp. 2011" />
<meta name="Keywords" content="REPLACE" />
<meta name="DC.Date" scheme="iso8601" content="2012-09-19" />
<meta name="Source" content="v17 template generator, template 17.02 delivery:IBM  authoring:IBM" />
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
<meta content="v17 delivery:ECM/Filegen authoring:ECM/IConS Adopter Catch XXII - F991578J94954L46 - 09/08/2014 10:31 AM" name="Source" />

<!-- Please ensure appropriate meta tag values are aligned with the standards -->

<title>TRAILS 4.0 | TRAILS</title>
<!-- NOTE: link to static domain, i.e. 1.www.s81c.com -->

<%-- <link href="//1.www.s81c.com/common/v17e/css/ww.css" rel="stylesheet" title="www" type="text/css" />
<script src="//1.www.s81c.com/common/v17e/js/ww.js" type="text/javascript">
	//
</script> --%>
<link href="//1.w3.s81c.com/common/v17e/css/w3.css" rel="stylesheet" title="w3" type="text/css" />
<script src="//1.w3.s81c.com/common/v17e/js/w3.js" type="text/javascript"></script>
<link href="//1.w3.s81c.com/common/v17e/css/application.css" rel="stylesheet" title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/data.css" rel="stylesheet" title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/form.css" rel="stylesheet" title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/social.css" rel="stylesheet" title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/module.css" rel="stylesheet" title="w3" type="text/css" />

<script src="${pageContext.request.contextPath}/js/jquery/jquery.js"></script>

<script type="text/javascript">
	ibmweb.config.set({
		siteid : 'w3',
		greeting : {
			enabled : false
		},
		signin : {
			enabled : false
		},
		merchandising : {
			enabled : false
		},
		sbs : {
			enabled : false
		},
		feedback : {
			enabled : false
		}
	});
</script>
<script type="text/javascript">
	ibmweb.config.set({
		opinionlab : {
			floating : {
				enabled : true,
				type : 'overlay',
				hide : 3600
			}
		}
	});
</script>

<style type="text/css">
/* LEADSPACE STYLES */
#ibm-leadspace-head #ibm-leadspace-body {
	background: url(/i/v17/lead/leadspace-tall-main.png) no-repeat 100% 50%;
}
/* LEADSPACE STYLES */
.ibm-button-link a {
	font-weight: bold;
}

.syntaxhighlighter {
	width: 99.8% !important;
}

#ibm-content-main {
	width:100%;
}

#ibm-content-main>.ibm-columns>.ibm-col-1-1 {
	width: 95%;
	background: white;
}

#ibm-content-main>.ibm-columns>.ibm-col-1-1>table {
	background: white;
}
</style>


<meta http-equiv="refresh" content="10;url=<s:url includeParams="all" />"/>
</head>
<body id="ibm-com" class="ibm-type">
	<div id="ibm-top" class="ibm-landing-page" style="width:100%">
		<!-- MASTHEAD_BEGIN -->
		<div id="ibm-masthead">
			<div id="ibm-mast-options">
				<ul>
					<li id="ibm-home"><a href="http://w3.ibm.com/">w3</a></li>
				</ul>
			</div>
			<div id="ibm-universal-nav">

				<p id="ibm-site-title">
					<em>TRAILS</em>
				</p>
				<ul id="ibm-menu-links">
					<li><a href="http://w3.ibm.com/sitemap/">Site map</a></li>
				</ul>

				<div id="ibm-search-module">
					<form id="ibm-search-form"
						action="http://w3.ibm.com/search/do/search" method="get">
						<p>
							<label for="q"><span class="ibm-access">Search</span></label> <input
								type="text" maxlength="100" value="" name="qt" id="q" /> <input
								type="hidden" value="17" name="v" /> <input value="en"
								type="hidden" name="langopt" /> <input value="all"
								type="hidden" name="la" /> <input type="submit" id="ibm-search"
								class="ibm-btn-search" value="Submit" />
						</p>
					</form>
				</div>
			</div>
		</div>

		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content" style="width:100%">
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<s:url id="settingsLink" action="settings" namespace="/account/recon"
							includeContext="true" includeParams="none">
						</s:url>

						<s:url id="workspaceLink" action="workspace?gotoV17e=y" namespace="/account/recon"
							includeContext="true" includeParams="none">
						</s:url>
						<div class="ibm-columns" style="width: 95%;">
							<div class="ibm-col-1-1" >
								<p id="breadcrumbs">
									<a href="${settingsLink}"> Workspace settings </a> &gt; <a href="${workspaceLink}"> Workspace</a> &gt;
								</p>
								<h1>
									Reconcile workspace: <s:property value="account.name" />(<s:property value="account.account" />)
								</h1>
								<p class="ibm-important">IBM Confidential</p>
								<h2>Reconciliation processing</h2>
								<p style="margin-top: 100px;">Please wait while we process your request.</p>
								<p>Please do not press your browser's back button while the alerts are being processed.</p>
								<p>Processed <s:if test="recon.reconcileType.id == 10 || recon.reconcileType.id == 11"><s:property value="alertService.alertsProcessed" /></s:if><s:else><s:property value="reconWorkspaceService.alertsProcessed" /></s:else> alert(s) out of <s:if test="recon.reconcileType.id == 10 || recon.reconcileType.id == 11"><s:property value="alertService.alertsTotal" /></s:if><s:else><s:property value="reconWorkspaceService.alertsTotal" /></s:else> total.</p>
							</div>
						</div>
					</div>
					<!-- FEATURES_BEGIN -->
					<div id="ibm-content-sidebar">
						<div id="ibm-contact-module">
							<!--IBM Contact Module-->
						</div>
						<div id="ibm-merchandising-module">
							<!--IBM Web Merchandising Module-->
						</div>
					</div>
					<!-- FEATURES_END -->
					<!-- CONTENT_BODY_END -->
				</div>
			</div>
			<!-- CONTENT_END -->
			<!-- NAVIGATION_BEGIN -->
			<div id="ibm-navigation"></div>
			<!-- NAVIGATION_END -->
		</div>
		<div id="ibm-related-content"></div>

		<!-- FOOTER_BEGIN -->
		<div id="ibm-footer-module"></div>
		<div id="ibm-footer">
			<h2 class="ibm-access">Footer links</h2>
			<ul>
				<li><a href="http://www.ibm.com/contact/us/en/">Contact</a></li>
				<li><a href="http://www.ibm.com/privacy/us/en/">Privacy</a></li>
				<li><a href="http://www.ibm.com/legal/us/en/">Terms of use</a></li>
				<li><a href="http://www.ibm.com/accessibility/us/en/">Accessibility</a></li>
			</ul>
		</div>
		<!-- FOOTER_END -->
	</div>
<%-- 	<div id="ibm-metrics">
		<script src="//www.ibm.com/common/stats/stats.js"
			type="text/javascript">
			//
		</script>
	</div> --%>
		<div id="ibm-metrics">
		<script type="text/javascript"
			src="//w3.ibm.com/w3webmetrics/js/ntpagetag.js">
			//
		</script>
	</div>
</body>
</html>
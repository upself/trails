<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html lang="en-ZZ" xml:lang="en-ZZ" xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta content="text/html; charset=UTF-8" http-equiv="Content-Type" />
<link href="http://purl.org/DC/elements/1.0/" rel="schema.DC" />
<link rel="SHORTCUT ICON" href="//w3.ibm.com/favicon.ico" />
<link href="http://w3.ibm.com/" rel="canonical" />
<meta content="width=device-width, initial-scale=1" name="viewport" />
<meta
	content="v17 delivery:ECM/Filegen authoring:ECM/IConS Adopter 14 - E685254H30287F35 - 07/22/2015 02:07:13 PM"
	name="Source" />
<meta content="internal use only" name="Security" />
<meta content="IBM Corporation" name="DC.Publisher" />
<meta content="SSW Home page" name="Description" />
<meta content="ZZ" name="IBM.Country" />
<meta content="software, sales enablement" name="Keywords" />
<meta content="zyizhang@CN.IBM.COM" name="Owner" />
<meta content="index,follow" name="Robots" />
<meta content="2015-07-22" scheme="W3CDTF" name="IBM.Effective" />
<meta content="2019-07-21" scheme="W3CDTF" name="IBM.Expires" />
<meta content="en-ZZ" scheme="rfc1766" name="DC.Language" />
<meta content="2015-07-22" scheme="iso8601" name="DC.Date" />
<meta content="© Copyright IBM Corp. 2015" name="DC.Rights" />
<meta content="SW000" scheme="IBM_SubjectTaxonomy" name="DC.Subject" />
<meta content="CTF00" scheme="IBM_ContentClassTaxonomy" name="DC.Type" />
<meta content="ZZ" scheme="IBM_IndustryTaxonomy" name="IBM.Industry" />
<meta content="IBM Corporation" name="DC.Publisher" />
<meta content="SW sales enablement website" name="Description" />
<meta content="Copyright © IBM Corp. 2015" name="DC.Rights" />

<title>TRAILS 4.0 | TRAILS</title>

<link href="//1.w3.s81c.com/common/v17e/css/w3.css" rel="stylesheet"
	title="w3" type="text/css" />
<script src="//1.w3.s81c.com/common/v17e/js/w3.js"
	type="text/javascript"></script>
<link href="//1.w3.s81c.com/common/v17e/css/application.css"
	rel="stylesheet" title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/data.css" rel="stylesheet"
	title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/form.css" rel="stylesheet"
	title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/social.css" rel="stylesheet"
	title="w3" type="text/css" />
<link href="//1.w3.s81c.com/common/v17e/css/module.css" rel="stylesheet"
	title="w3" type="text/css" />


<style type="text/css">
#ibm-content-main>.ibm-columns>.ibm-col-1-1 {
	width: 95%;
	background: white;
}

#ibm-content-main>.ibm-columns>.ibm-col-1-1>table {
	background: white;
}

.nobreak {
	word-break: keep-all;
	white-space: nowrap;
}

.alert-go {
	color: #66CD00;
}

.alert-stop {
	color: red;
}

.orange-med {
	color: #FFC125;
}

ul.horizontal-list li {
	display: inline;
}
</style>
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
			enabled : true,
			style : 'overlay'
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
</head>


<body id="ibm-com" class="ibm-default">
	<div id="ibm-top">
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
		<!-- MASTHEAD_END -->

		<div id="ibm-pcon" style="width: inherit">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				<!-- LEADSPACE_BEGIN -->
				<div id="ibm-leadspace-head" class="ibm-alternate">
					<div id="ibm-leadspace-body">
						<div class="ibm-columns">
							<div class="ibm-col-1-1">
								<tmp:insertAttribute name="contentHead" />
							</div>
						</div>
					</div>
				</div>
				<!-- LEADSPACE_END -->

				<div id="ibm-content-body">
					<div id="ibm-content-main" style="width: 100%;">
						<tmp:insertAttribute name="content" />
					</div>
				</div>

				<!-- FEATURES_BEGIN -->
				<div id="ibm-content-sidebar">
					<tmp:insertAttribute name="contentSidebar" />
				</div>
				<!-- FEATURES_END -->
			</div>
			<!-- CONTENT_END -->

			<!-- NAVIGATION_BEGIN -->
			<tmp:insertAttribute name="navigation" />
			<!-- NAVIGATION_END -->
		</div>

		<div id="ibm-related-content">
			<!-- RELATED_CONTENT_BEGIN -->
			<div id="ibm-merchandising-module">
				<!-- ibm-merchandising-module -->
			</div>
			<!-- RELATED_CONTENT_END -->
		</div>

		<!-- FOOTER_BEGIN -->
		<div id="ibm-footer-module"></div>
		<div id="ibm-footer">
			<h2 class="ibm-access">Footer links</h2>
			<ul>
				<li><a href="http://w3.ibm.com/w3/info_terms_of_use.html">Terms
						of use</a></li>
			</ul>
		</div>
		<!-- FOOTER_END -->
	</div>
	<div id="ibm-metrics">
		<script type="text/javascript"
			src="//w3.ibm.com/w3webmetrics/js/ntpagetag.js">
			//
		</script>
	</div>
</body>
</html>

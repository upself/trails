<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tmp"%>
<%@ taglib prefix="s" uri="/struts-tags"%>

<!DOCTYPE html>
<html>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8"/>
	<!-- Add meta tag to consistently detect the width on an iPad at 768px -->
	<meta name="viewport" content="width=device-width, initial-scale=1"/>
    <link rel="schema.DC" href="http://purl.org/DC/elements/1.0/"/>
    <link rel="SHORTCUT ICON" href="http://www.ibm.com/favicon.ico"/>
    <meta name="DC.Rights" content="© Copyright IBM Corp. 2011"/>
    <meta name="Keywords" content="<tmp:getAsString name='keywords'/>"/>
    <meta name="DC.Date" scheme="iso8601" content="2012-09-19"/>
    <meta name="Source" content="v17 template generator, template 17.02 delivery:IBM  authoring:IBM"/>
    <meta name="Security" content="Public"/>
    <meta name="Abstract" content="Any feedback to vndwbwan@cn.ibm.com"/>
    <meta name="IBM.Effective" scheme="W3CDTF" content="2012-09-19"/>
    <meta name="DC.Subject" scheme="IBM_SubjectTaxonomy" content="REPLACE"/>
    <meta name="Owner" content="vndwbwan@CN.IBM.COM"/>
    <meta name="DC.Language" scheme="rfc1766" content="en"/>
    <meta name="IBM.Country" content="ZZ"/>
    <meta name="Robots" content="index,follow"/>
    <meta name="DC.Type" scheme="IBM_ContentClassTaxonomy" content="REPLACE"/>
    <meta name="Description" content="<tmp:getAsString name='description'/>"/>
    <meta content="v17 delivery:ECM/Filegen authoring:ECM/IConS Adopter Catch XXII - U879449Q83462V14 - 09/09/2014 11:45 AM" name="Source"/>
     
	<title>TRAILS 4.0 | TRAILS</title>
 
	<link href="//1.www.s81c.com/common/v17e/css/ww.css" rel="stylesheet" title="www" type="text/css" />
	<script src="//1.www.s81c.com/common/v17e/js/ww.js" type="text/javascript"></script>
	<link href="//1.www.s81c.com/common/v17e/css/application.css" rel="stylesheet" title="www" type="text/css"/>
	<link href="//1.www.s81c.com/common/v17e/css/data.css" rel="stylesheet" title="www" type="text/css" />
	<link href="//1.www.s81c.com/common/v17e/css/form.css" rel="stylesheet" title="www" type="text/css" />
</head>

	
<body id="ibm-com" class="ibm-type">

	<div id="ibm-top" class="ibm-default">
		<!-- MASTHEAD_BEGIN -->
		<div id="ibm-masthead">
			<div id="ibm-mast-options">
				<ul>
					<li id="ibm-geo"><a href="http://www.ibm.com/planetwide/select/selector.html"><span class="ibm-access">Select a country/region: </span>Worldwide</a></li>
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
					<form id="ibm-search-form" action="http://www.ibm.com/Search/" method="get">
						<p>
							<label for="q"><span class="ibm-access">Search</span></label>
							<input type="text" maxlength="100" value="" name="q" id="q"/>
							<input type="hidden" value="17" name="v"/>
							<input type="hidden" value="utf" name="en"/>
							<input type="hidden" value="en" name="lang"/>
							<input type="hidden" value="zz" name="cc"/>
							<input type="submit" id="ibm-search" class="ibm-btn-search" value="Submit"/>
						</p>
					</form>
				</div>
			</div>
		</div>
		<!-- MASTHEAD_END -->
	
		<div id="ibm-pcon">
			<!-- CONTENT_BEGIN -->
			<div id="ibm-content">
				
				<div id="ibm-content-head">
					<!-- LEADSPACE_BEGIN -->
					<div id="ibm-leadspace-head" class="ibm-alternate">
						<div id="ibm-leadspace-body">
							<div class="ibm-columns">
								<div class="ibm-col-1-1">
									<h6><tmp:insertAttribute name="contentTitle" /></h6>
								</div>
							</div>
						</div>
					</div>
					<!-- LEADSPACE_END -->
				</div>
				
				<!-- CONTENT_BODY -->
				<div id="ibm-content-body">
					<div id="ibm-content-main">
						<tmp:insertAttribute name="content" />      
					</div>
		
					<!-- FEATURES_BEGIN -->
					<div id="ibm-content-sidebar">
						<tmp:insertAttribute name="contentSidebar" />
					</div>
					<!-- FEATURES_END -->
					
				</div>
				<!-- CONTENT_BODY_END -->
			
			</div>
			<!-- CONTENT_END -->
	
			<!-- NAVIGATION_BEGIN -->
			<tmp:insertAttribute name="navigation" />
			<!-- NAVIGATION_END -->
		</div>
		
		<div id="ibm-related-content"></div>
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
		<script src="http://www.ibm.com/common/stats/stats.js" type="text/javascript"></script>
	</div>
</body>
</html>

<%@ page language="java" contentType="text/html; charset=utf-8"%>
<%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tmp"%>
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
	
	 $(window).scroll(function(event) {
		 var footerModule = $("#ibm-footer-module"),
         offset = $(window).scrollLeft();
		 footerModule.css("left", offset + "px");
		 
		 var footer = $("#ibm-footer"),
         offset = $(window).scrollLeft();
		 footer.css("left", offset + "px");
     });
</script>

<style type="text/css">
.trails-content-wrapper{
	clear:both;
	padding-left: 35px;
	padding-right: 35px;
}

.trails-fixed-masthead{
	position: fixed !important;
	left: 0px !important;
}

.trails-relative-footer{
	position: relative;
}

.trails-rule {
	margin: 10px 0 !important;
}

.trails-navigation-trail{
	padding: 0px !important;
}

.fluid{
	min-width: 100%;
	width:auto;
	float:left;
} 

#m-open-link{
	top: 0 !important;
	right: 0 !important;
}

.trails-fluid-columns {
	width: auto !important;
	padding: 0 !important;
}

.trails-form{
	
}

.trails-form input[type='text']{
	min-width: 220px;
}

.trails-form select{
	min-width: 225px;
}

.trails-form textarea{
	min-width: 223px;
	min-height: 120px;
}

.trails-form-table{
	width: auto;
}

.trails-form-table tr{
	margin-top: 5px;
}

.trails-form-table tr td{
	padding-left: 0px;
	padding-top: 5px;
	padding-right:10px;
	padding-bottom: 5px;
}

.errorMessage{
	color:#D9182D;
}

[class*="ibm-col-6-"]{
	margin:0;
}

table.ibm-data-table td, table.ibm-data-table th {
	font-size: 13px;
	font-size: 1.3rem;
}

table.ibm-data-table tbody tr:first-child td, table.ibm-data-table tbody tr:first-child th, table.ibm-data-table.ibm-alternating tbody tr:first-child td, table.ibm-data-table.ibm-alternating tbody tr:first-child th {
    border-top: 1px solid #999;
}

@media only screen and (min-width: 980px) {
	.ibm-columns.trails-fluid-columns .ibm-col-6-6 {
		width: 100%;
	}
	
	.ibm-columns.trails-fluid-columns .ibm-col-6-5 {
		width: 83%;
	}
	
	.ibm-columns.trails-fluid-columns .ibm-col-6-4 {
		width: 66%;
	}
	
	.ibm-columns.trails-fluid-columns .ibm-col-6-3 {
		width: 50%;
	}
	
	.ibm-columns.trails-fluid-columns .ibm-col-6-2 {
		width: 33%;
	}
	
	.ibm-columns.trails-fluid-columns .ibm-col-6-1 {
		width: 16%;
	}
}

@media only screen and (max-width: 800px) {
	.ibm-content-expand{
		padding-top:60px;
	}
}
</style>



</head>
<body id="ibm-com" class="ibm-type">
	<div id="ibm-top" class="ibm-liquid">
		<!-- MASTHEAD_BEGIN -->
		<div id="ibm-masthead" class="trails-fixed-masthead">
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
								class="ibm-btn-pri" value="Submit" />
						</p>
					</form>
				</div>
			</div>
		</div>
		<!-- MASTHEAD_END -->

		<!-- FLUID CONTENT BEGING -->
		<div class="ibm-content-expand">
			<div id="ibm-content-body" class="fluid" >
				<div class="trails-content-wrapper">
					<tmp:insertAttribute name="content" />
				</div>
			</div>
		</div>
		<!-- FLUID CONTENT END -->

		<!-- FOOTER_BEGIN -->
		<div id="ibm-footer-module" class="trails-relative-footer"></div>
		<div id="ibm-footer" class="trails-relative-footer">
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

	<div id="ibm-metrics">
		<script type="text/javascript"
			src="//w3.ibm.com/w3webmetrics/js/ntpagetag.js">
			//
		</script>
	</div>
</body>
</html>
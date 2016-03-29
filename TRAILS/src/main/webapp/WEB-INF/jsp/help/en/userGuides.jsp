<%@taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function openUserGuide(url) {
		if (url == "" || url == null) {
			url = "http://tap.raleigh.ibm.com/helpdocs/trails/en/trails_userguide_en.pdf";
		}
		if (confirm('Open the user guide in new window?')) {
			window.open(url, "UserGuide", "scrollbars,resizable");
		}
		return false;
	}
</script>
<div class="ibm-columns">
	<div class="ibm-col-1-1">
		<!-- Application Demonstrations -->
		<!-- Downloadable User Guides -->
		<h2>Downloadable User Guides</h2>
		<img src="//w3-workplace.ibm.com/ui/v8/images/icon-link-action.gif" alt="action link icon" width="17" height="15" /> <a
			href="#" onclick="openUserGuide()">TRAILS User Guide</a> (<a href="//www.adobe.com/products/acrobat/readermain.html">PDF
			Viewer Application</a>)<br />
		<br />
		<!-- Miscellaneous Downloads -->
		<!-- end help doc -->
	</div>
</div>


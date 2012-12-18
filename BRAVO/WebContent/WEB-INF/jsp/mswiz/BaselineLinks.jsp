<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<br>
<!-- 
<html:link
	href="http://tap.raleigh.ibm.com/templates/Microsoft_Hardware_Loader_Template.xls">
	<b>Hardware Baseline Template:</b>
	<br> Blank
		</html:link>
<br>
<br>
<html:link page="/HardwareBaselineReport.do"
	onclick="return confirm('This report will be sent via email.  Continue?')">
	<b>Hardware Baseline Template:</b>
	<br> Complete for this Account
	</html:link>
<br>
<br -->
<html:link
	href="http://tap.raleigh.ibm.com/templates/MS_Software_Loader_Template.xls">
	<b>Installed Software Baseline Template:</b>
	<br> Blank
		</html:link>
<br>
<br>
<html:link page="/InstalledSoftwareBaselineReport.do"
	onclick="return confirm('This report will be sent via email.  Continue?')">
	<b>Installed Software Baseline Template:</b>
	<br> Complete for this Account
	</html:link>
	

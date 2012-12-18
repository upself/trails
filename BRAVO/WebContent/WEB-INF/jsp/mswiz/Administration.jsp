<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Administrative Reports</h1>

<br>
<br>
<h3><html:link action="/SplaPoReport.do" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				SPLA PO report</html:link></h3>
The SPLA PO report is an excel spreadsheet formulated from data that is
pulled on a daily basis at 6:00 AM. The report consists of department,
industry, sector, customer type, customer license agreement, account ID,
customer name, total price, and po number(s). This report is only
available via email.
<br>
<br>
<h3><html:link action="/EsplaPoReport.do" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				ESPLA PO report <br>
</html:link></h3>
The ESPLA PO report is an excel spreadsheet formulated from data that is
pulled on a daily basis at 6:00 AM. The report consists of department,
industry, sector, customer type, customer license agreement, account ID,
customer name, total price, and po number(s). This report is only
available via email.
<br>
<br>
<!--
<h3><html:link action="/Q0xfHardwareBaselineReport.do"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Q0XF hardware baseline report <br>
</html:link></h3>
The Q0XF hardware baseline report contains a listing of all hardware
associated with the Q0XF department, regardless of customer status and
server status. This report is only availabe via email.
<br>
<br>
<h3><html:link action="/Q0xfSoftwareBaselineReport.do"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Q0XF software baseline report <br>
</html:link></h3>
The Q0XF software baseline report contains a listing of all software
associated with the Q0XF department, regardless of customer, server, or
software status. This report is only availabe via email.
<br>
<br>
-->
<h3><html:link page="/PodHardwareBaselineReport.do?pod=Q0HG" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Q0HG hardware baseline report <br>
</html:link></h3>
The Q0HG hardware baseline report contains a listing of all hardware
associated with the Q0HG department, regardless of customer status and
server status. This report is only availabe via email.
<br>
<br>
<h3><html:link page="/PodSoftwareBaselineReport.do?pod=Q0HG" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Q0HG software baseline report <br>
</html:link></h3>
The Q0HG software baseline report contains a listing of all software
associated with the Q0HG department, regardless of customer, server, or
software status. This report is only availabe via email.
<br>
<br>
<h3><html:link action="/DuplicateHostnameReport.do" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Duplicate hostname report <br>
</html:link></h3>
The duplicate hostname report contains a listing of all servers that
have duplicate hostnames across all accounts in the tool. This report is
only availabe via email.
<br>
<br>
<h3><html:link action="/DuplicatePrefixReport.do" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Duplicate prefix report <br>
</html:link></h3>
The duplicate prefix report contains a listing of all servers that have
duplicate hostnames across all accounts in the tool. In this report,
duplicate hostnames are calculated by stripping the fully qualified
hostname of its domain name and then comparing(e.g., tap =
tap.raleigh.ibm.com).
<br>
<br>
<h3><html:link action="/NoOperatingSystemReport.do">
				No Operating System Report <br>
</html:link></h3>
This report shows all server instances that have reported no operating
systems.
<br>
<br>
<h3><html:link action="/MissingScanReport.do" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Missing scan report <br>
</html:link></h3>
The missing scan report shows all customers that have no active scan data.
<br>
<br>
<h3><html:link action="/UnlockedAccountReport.do" onkeypress="return(this.onclick());"
	onclick="return confirm('This report will be sent via email. Continue?')">
				Unlocked Account Report <br>
</html:link></h3>
The Unlocked account report shows all registered, in scope accounts that
are currently unlocked.
<br>
<br>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->

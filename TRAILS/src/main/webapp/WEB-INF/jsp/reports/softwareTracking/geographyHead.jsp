<%@ taglib prefix="s" uri="/struts-tags"%>
<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/softwareTracking"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="geography" action="geography"
	namespace="/reports/softwareTracking" includeContext="true"
	includeParams="none">
</s:url>

<ul id="ibm-navigation-trail">
	<li><s:a href="%{trails}">TRAILS</s:a></li>
	<li><s:a href="%{reports}">Reports</s:a></li>
	<li><s:a href="%{alerts}">Software Tracking Only metrics</s:a></li>
</ul>


<h1>Geography</h1>
<h4>Software Tracking Only metrics reports</h4>
<p class="ibm-important">IBM Confidential</p>
<p>The following reports reflect metric purification where customer
	financial responsible software has been counted towards closed alerts
	where IBM has documented report delivery dates in Schedule F Report
	Date Tracking.</p>
<br />
Data last refreshed:
<span class="ibm-item-note"><s:date name="reportTimestamp"
		format="MM-dd-yyyy HH:mm:ss 'EST'" /></span>
<br />
Data age (in minutes):
<span class="ibm-item-note"> <s:property value="reportMinutesOld" />
</span>
<br />

<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/alerts" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="geography" action="geography" namespace="/reports/alerts" includeContext="true"
	includeParams="none">
</s:url>

<p id="breadcrumbs">
<s:a href="%{trails}">TRAILS</s:a> &gt;
<s:a href="%{reports}">Reports</s:a> &gt;
<s:a href="%{alerts}">Alerts</s:a> &gt;
</p>

<h1>Geography</h1>
<h4>Alerts report</h4>
<p class="confidential">IBM Confidential</p>
<p>The following reports reflect metric purification where customer financial responsible software has been counted towards closed alerts where IBM has documented report delivery dates in Schedule F Report Date Tracking.</p>
<br />

Data last refreshed: <s:date name="reportTimestamp" format="MM-dd-yyyy HH:mm:ss 'EST'" /><br />
Data age (in minutes): <s:property value="reportMinutesOld" /><br />

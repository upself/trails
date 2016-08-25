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


<ul id="ibm-navigation-trail">
	<li><s:a href="%{trails}">TRAILS</s:a></li>
	<li><s:a href="%{reports}">Reports</s:a></li>
	<li><s:a href="%{alerts}">Software Tracking Only metrics</s:a></li>
</ul>

<div style="font-size: 22px; display: inline">Software Tracking Only metrics
	reports by</div>
<h1 class="oneline">&nbsp;Account number</h1>
<br>





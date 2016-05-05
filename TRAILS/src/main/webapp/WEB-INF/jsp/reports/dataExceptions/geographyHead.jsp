<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="dataExceptions" action="home"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="geography" action="geography"
	namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<ul id="ibm-navigation-trail">
	<li><s:a href="%{trails}">TRAILS</s:a></li>
	<li><s:a href="%{reports}">Reports</s:a></li>
	<li><s:a href="%{dataExceptions}">Data exceptions</s:a></li>
</ul>

<h1>Geography</h1>
<h4>Data exceptions reports</h4>
<p class="ibm-important">IBM Confidential</p>
<br />

Data last refreshed:
<span class="ibm-item-note"> <s:date name="reportTimestamp"
		format="MM-dd-yyyy HH:mm:ss 'EST'" /></span>
<br />
Data age (in minutes):
<span class="ibm-item-note"> <s:property value="reportMinutesOld" /></span>
<br />

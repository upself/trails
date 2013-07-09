<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="dataExceptions" action="home" namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="geography" action="geography" namespace="/reports/dataExceptions" includeContext="true"
	includeParams="none">
</s:url>

<p id="breadcrumbs">
<s:a href="%{trails}">TRAILS</s:a> &gt;
<s:a href="%{reports}">Reports</s:a> &gt;
<s:a href="%{dataExceptions}">Data exceptions</s:a> &gt;
</p>

<h1>Geography</h1>
<h4>Data exceptions reports</h4>
<p class="confidential">IBM Confidential</p>
<br />

Data last refreshed: <s:date name="reportTimestamp" format="MM-dd-yyyy HH:mm:ss 'EST'" /><br />
Data age (in minutes): <s:property value="reportMinutesOld" /><br />

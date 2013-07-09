<%@ taglib prefix="s" uri="/struts-tags"%>

<s:url id="trails" action="home" namespace="/" includeContext="true"
	includeParams="none">
</s:url>

<s:url id="reports" action="home" namespace="/reports"
	includeContext="true" includeParams="none">
</s:url>

<s:url id="alerts" action="home" namespace="/reports/alertRedAging"
	includeContext="true" includeParams="none">
</s:url>

<p id="breadcrumbs"><s:a href="%{trails}">TRAILS</s:a> &gt; <s:a
	href="%{reports}">Reports</s:a> &gt; <s:a href="%{alerts}">Aging red alerts</s:a>
&gt; 
<br>
</p>

<h1 class="oneline">Aging red alerts</h1><div style="font-size:22px; display:inline">&nbsp;by Account</div>
<br>






<%@ taglib prefix="s" uri="/struts-tags" %>

<h1 class="oneline">Reports</h1><div style="font-size:22px; display:inline">&nbsp;listing</div>
<p class="confidential">IBM Confidential</p>
<br />
<br />

<h2 class="bar-blue-med-light">Account reports</h2><br />
<span class="download-link">
	<a href="/TRAILS/report/download/nonWorkstationAccounts.tsv?name=nonWorkstationAccounts">Non-workstation accounts with workstation assets</a>
</span>
<span class="download-link">
	<a href="/TRAILS/report/download/workstationAccounts.tsv?name=workstationAccounts">Workstation accounts with non-workstation assets</a>
</span>

<h2 class="bar-blue-med-light">Alert reports</h2><br />
<s:a href="/TRAILS/reports/alerts/home.htm">Alerts</s:a><br /><br />
<s:a href="/TRAILS/reports/operational/home.htm">Operational metrics</s:a><br /><br />
<s:a href="/TRAILS/reports/alertRedAging/home.htm">Aging red alerts</s:a><br /><br />
<s:a href="/TRAILS/reports/dataExceptions/home.htm">Data exceptions</s:a><br />

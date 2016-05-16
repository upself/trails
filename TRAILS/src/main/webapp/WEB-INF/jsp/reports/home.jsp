<%@ taglib prefix="s" uri="/struts-tags"%>

<div style="padding-left: 10px; width: 90%">
	<h2>Reports listing</h2>
	<p class="ibm-important">IBM Confidential</p>
	<br /> <br />

	<h2 style="background-color: #d7d7d8">Account reports</h2>
	<ul id="ibm-link-list">
		<li><s:a
				href="/TRAILS/report/download/nonWorkstationAccounts.tsv?name=nonWorkstationAccounts">Non-workstation
		accounts with workstation assets</s:a></li>
		<li><s:a
				href="/TRAILS/report/download/workstationAccounts.tsv?name=workstationAccounts">Workstation
		accounts with non-workstation assets</s:a></li>
	</ul>
	<br />

	<h2 style="background-color: #d7d7d8">Alert reports</h2>
	<br />
	<ul id="ibm-link-list">
		<li><s:a href="/TRAILS/reports/alerts/home.htm">Alerts</s:a></li>
		<li><s:a href="/TRAILS/reports/operational/home.htm">Operational metrics</s:a></li>
		<li><s:a href="/TRAILS/reports/alertRedAging/home.htm">Aging red alerts</s:a></li>
		<li><s:a href="/TRAILS/reports/dataExceptions/home.htm">Data exceptions</s:a></li>
	</ul>
</div>
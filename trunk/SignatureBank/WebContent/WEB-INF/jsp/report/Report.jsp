<%@ taglib uri="http://struts.apache.org/tags-html" prefix="html"%>
<%@ taglib uri="http://struts.apache.org/tags-logic" prefix="logic"%>
<%@ taglib uri="http://struts.apache.org/tags-bean" prefix="bean"%>
<%@ taglib uri="http://struts.apache.org/tags-tiles" prefix="tmp"%>

<h1>Reports</h1>
<br>

<html:img alt="Someone taking notes" page="/images/p1_w3v8_26.jpg"
	align="left" hspace="10" vspace="10" />

<p style="color: #c60" class="caption">Signature Bank Reporting</p>
<p>Below are various reports that will help with knowledge base
management.</p>

<br clear="all">
<p style="color: #969" class="caption">Reports:</p>
<div class="hrule-dots">&nbsp;</div>
<br>
<br>
<table border="0">
	<tr>
		<td><html:link
			page="/Download/signatures.tsv?id=softwareSignature"
			styleClass="download-link">Active Signatures</html:link></td>
		<td>- A full report of signatures in tsv format.</td>
	</tr>

	<tr>
		<td><html:link page="/Download/filters.tsv?id=softwareFilter"
			styleClass="download-link">Active Filters</html:link></td>
		<td>- A full report of software filters.</td>
	</tr>

	<tr>
		<td><html:link
			page="/Download/inactive_signatures.tsv?id=inactiveSoftwareSignature"
			styleClass="download-link">InActive Signatures</html:link></td>
		<td>- A full report of <b>inactive</b> software signatures.</td>
	</tr>

	<tr>
		<td><a href="/hit/sigHitReport.xls" class="download-link">Signature
		Hit Report</a></td>
		<td>- A Report of the Signatures and Environments they made
		matches.</td>
	</tr>
</table>


</div>
<!-- stop main content -->

</div>
<!-- stop content -->

<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<h1>Administrative Reports</h1>

<br>
<br>
<h3>Lock all accounts</h3>
This function locks all ESPLA/SPLA accounts that are currently unlocked
and that have a valid default LPID assigned via the account settings.
This function sends a job to the batch queue, notifying the user upon
completion.
<br>
<html:form action="/LockAccounts">
	<span class="button-blue"><html:submit>Lock/Approve all accounts</html:submit></span>
</html:form>
<br>
<br>
<h3>Unlock all accounts</h3>
This function unlocks all ESPLA/SPLA accounts that are currently locked.
<br>
<html:form action="/UnlockAccounts">
	<span class="button-blue"><html:submit>Unlock all accounts</html:submit></span>
</html:form>
<br>
<br>
<h3>Create SPLA MOET Report</h3>
<html:form action="/CreateSplaMoetReport">
	<label for="select_sku_usageDates"> The SPLA MOET report will
	generate a separate MOET report based on agreement number for all SPLA
	accounts that have been approved and have had their PO information
	entered. </label>
	<br>
	<html:select name="priceReportArchive" property="sku"
		styleId="select_sku_usageDates">
		<html:options name="usageDates" />
	</html:select>
	<span class="button-blue"><html:submit>Submit</html:submit></span>
</html:form>
<br>
<br>
<h3>Accept SPLA MOET Reports</h3>
<html:form action="/AcceptSplaMoetReport">
	<label for="select_sku_moetUsageDates"> This function is to be
	ran after the MOET report has been accepted and before the next cycle
	begins. It will mark all records as accepted and allow new price report
	cycle to be started for the next quarter. </label>
	<br>
	<html:select name="priceReportArchive" property="sku"
		styleId="select_sku_moetUsageDates">
		<html:options name="moetUsageDates" />
	</html:select>
	<span class="button-blue"><html:submit>SPLA Moet Accepted</html:submit></span>
</html:form>

</div>
<!-- stop main content -->
</div>
<!-- stop content -->

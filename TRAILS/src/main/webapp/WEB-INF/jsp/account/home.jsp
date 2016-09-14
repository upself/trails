<%@ taglib prefix="s" uri="/struts-tags"%>

<script type="text/javascript">
	function popupCNDB(accountId) {
		newWin = window
				.open(
						'https://ralbz001073.raleigh.ibm.com/cndbLegacy/faces/home/home.jsp',
						'popupWindow',
						'height=600,width=1200,resizable=yes,menubar=yes,status=yes,toolbar=yes,scrollbars=yes');
		newWin.focus();
		void (0);
	}
</script>

<s:if test="hasErrors()">
	<s:actionerror />
	<s:fielderror />
</s:if>
<h1>
	Customer Profile:
	<s:property value="account.name" />
</h1>
<p class="ibm-confidential">IBM Confidential</p>

		<h2 class="bar-blue-med-light">Customer Details</h2>

		<table cellspacing="0" cellpadding="0" class="ibm-data-table ibm-alternating">
			<tr>
				<td style="width: 20%"><span class="caption">Account Number</span></td>
				<td><s:url id="cndb"
						value="javascript:popupCNDB(%{#attr.account.id})"
						includeContext="false" includeParams="none">

					</s:url> <s:a href="%{cndb}">
						<s:property value="account.account" />
					</s:a></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Account Name</span></td>
				<td style="width: 20%"><s:property value="account.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Account Type</span></td>
				<td><s:property value="account.accountType.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Geography</span></td>
				<td><s:property
						value="account.countryCode.region.geography.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Region</span></td>
				<td><s:property value="account.countryCode.region.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Country</span></td>
				<td><s:property value="account.countryCode.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Department</span></td>
				<td><s:property value="account.department.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Sector</span></td>
				<td><s:property value="account.sector.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Industry</span></td>
				<td><s:property value="account.industry.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">DPE</span></td>
				<td><s:property value="account.dpe.name" /></td>
			</tr>
		</table>

		<h2 class="bar-blue-med-light">Reconciliation Details</h2>

		<table cellspacing="0" cellpadding="0" class="ibm-data-table ibm-alternating">
			<tr>
				<td style="width: 20%"><span class="caption">Reconciliation Scope</span></td>
				<td><s:property value="account.swlm" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">CNDB Status</span></td>
				<td><s:property value="account.status" /></td>
			</tr>
		</table>


		<h2 class="bar-blue-med-light">Service Details</h2>

		<table cellspacing="0" cellpadding="0" class="ibm-data-table ibm-alternating">
			<tr>
				<td style="width: 20%"><span class="caption">Software Contact Name</span></td>
				<td><s:property value="account.softwareContact.name" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Software Interlock Support</span></td>
				<td><s:property value="account.softwareInterlock" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Software Tracking Scope</span></td>
				<td><s:property value="account.softwareTracking" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Software License Management
						Scope</span></td>
				<td><s:property value="account.swlm" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Software Financial Management
						Scope</span></td>
				<td><s:property value="account.softwareFinancialManagement" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Compliance Mgmt of Customer
						Owned Assets Scope</span></td>
				<td><s:property value="account.softwareComplianceManagement" /></td>

			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">Assets that IBM is financially
						responsible for Software</span></td>
				<td><s:property value="account.softwareFinancialResponsibility" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">IBM Own or Lease Hardware for
						Customer</span></td>
				<td><s:property value="account.hardwareSupport" /></td>
			</tr>
			<tr>
				<td style="width: 20%"><span class="caption">IBM Own or Lease Software For
						Customer</span></td>
				<td><s:property value="account.softwareSupport" /></td>
			</tr>
		</table>
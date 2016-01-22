<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<div id="fourth-level">
<h1>Customer Profile for <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>
<!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/CustomerProfile.do" styleClass="active">Overview</html:link>
	|</li>
	<li><html:link page="/HardwareBaseline.do">Hardware</html:link>
	|</li>
	<li><html:link page="/InstalledSoftwareBaseline.do">Installed Software</html:link>
	|</li>
	<li><html:link page="/ConsentLetter.do">Consent Letters</html:link> |</li>
</ul>
</div>

<logic:empty name="user.container" property="customer.misldRegistration">
	<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
		alt="add icon - dark" width="13" height="13" />
	<html:link page="/CustomerRegistration.do">Register customer</html:link>
</logic:empty>

<logic:notEmpty name="user.container"
	property="customer.misldRegistration">
	<logic:notEqual name="user.container"
		property="customer.misldRegistration.status" value="LOCKED">
		<logic:notEmpty name="user.container"
			property="customer.misldAccountSettings">
			<logic:notEqual name="user.container"
				property="customer.misldAccountSettings.status" value="LOCKED">
				<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
					alt="add icon - dark" width="13" height="13" />
				<html:link page="/DestroyRegistration.do"
					onclick="return confirm('Are you sure you want to destroy this customers registration and settings?')">Destroy customer setup</html:link>
				<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
					alt="add icon - dark" width="13" height="13" />
				<html:link page="/UpdateRegistration.do">Update registration</html:link>
				<logic:notEqual name="user.container"
					property="customer.misldAccountSettings.status" value="COMPLETE">
					<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
						alt="add icon - dark" width="13" height="13" />
					<html:link page="/CustomerSettings.do">Complete settings</html:link>
				</logic:notEqual>
				<logic:equal name="user.container"
					property="customer.misldAccountSettings.status" value="COMPLETE">
					<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
						alt="add icon - dark" width="13" height="13" />
					<html:link page="/CustomerSettings.do">Update settings</html:link>
				</logic:equal>
			</logic:notEqual>
		</logic:notEmpty>
		<logic:empty name="user.container"
			property="customer.misldAccountSettings">
			<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
				alt="add icon - dark" width="13" height="13" />
			<html:link page="/DestroyRegistration.do"
				onclick="return confirm('Are you sure you want to destroy this customers registration and settings?')">Destroy customer setup</html:link>
			<logic:notEqual name="user.container"
				property="customer.misldRegistration.status" value="COMPLETE">
				<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
					alt="add icon - dark" width="13" height="13" />
				<html:link page="/CustomerRegistration.do">Register customer</html:link>
			</logic:notEqual>
			<logic:equal name="user.container"
				property="customer.misldRegistration.status" value="COMPLETE">
				<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
					alt="add icon - dark" width="13" height="13" />
				<html:link page="/UpdateRegistration.do">Update registration</html:link>
				<logic:equal name="user.container"
					property="customer.misldRegistration.inScope" value="true">
					<img src="https://w3.ibm.com/ui/v8/images/icon-link-add-dark.gif"
						alt="add icon - dark" width="13" height="13" />
					<html:link page="/CustomerSettings.do">Complete settings</html:link>
				</logic:equal>
			</logic:equal>
		</logic:empty>
	</logic:notEqual>
</logic:notEmpty>

<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
	width="100%" style="margin-top:2em;">

	<tr class="tablefont">
		<th colspan="10" style="white-space:nowrap; background-color:#bd6;">Customer
		Profile</th>
	</tr>
	<tr style="background-color:#dfb;" class="tablefont">
		<th nowrap="nowrap">Attribute</th>
		<th nowrap="nowrap">Value</th>
	</tr>

	<tr class="gray" style="font-size:8pt">
		<td>Account type</td>
		<td><bean:write name="user.container"
			property="customer.customerType.customerTypeName" /></td>
	</tr>
	<tr class="gray" style="font-size:8pt">
		<td>DPE</td>
		<td><bean:write name="user.container"
			property="customer.contactDPE.fullName" /></td>
	</tr>
	<tr class="gray" style="font-size:8pt">
		<td>Asset admin department</td>
		<td><bean:write name="user.container" property="customer.pod.podName" /></td>
	</tr>
	<tr class="gray" style="font-size:8pt">
		<td>Industry</td>
		<td><bean:write name="user.container"
			property="customer.industry.industryName" /></td>
	</tr>
	<tr class="gray" style="font-size:8pt">
		<td>Sector</td>
		<td><bean:write name="user.container"
			property="customer.sector.sectorName" /></td>
	</tr>
	<tr class="gray" style="font-size:8pt">
		<td>Account Id</td>
		<td><bean:write name="user.container"
			property="customer.accountNumber" /></td>
	</tr>

	<logic:notEmpty name="user.container"
		property="customer.misldRegistration">
		<tr class="gray" style="font-size:8pt">
			<td>Registration status</td>
			<td><bean:write name="user.container"
				property="customer.misldRegistration.status" /></td>
		</tr>
		<tr class="gray" style="font-size:8pt">
			<td>Account Settings status</td>
			<logic:empty name="user.container"
				property="customer.misldAccountSettings">
				<td>INCOMPLETE</td>
			</logic:empty>
			<logic:notEmpty name="user.container"
				property="customer.misldAccountSettings">
				<td><bean:write name="user.container"
					property="customer.misldAccountSettings.status" /></td>
			</logic:notEmpty>
		</tr>
		<tr class="gray" style="font-size:8pt">
			<td>In scope</td>
			<td><bean:write name="user.container"
				property="customer.misldRegistration.inScope" /></td>
		</tr>
		<logic:equal name="user.container"
			property="customer.misldRegistration.inScope" value="false">
			<tr class="gray" style="font-size:8pt">
				<td>Out of scope justification</td>
				<td><bean:write name="user.container"
					property="customer.misldRegistration.notInScopeJustification" /></td>
			</tr>
		</logic:equal>
		<tr class="gray" style="font-size:8pt">
			<td>Last registration update performed by</td>
			<td><bean:write name="user.container"
				property="customer.misldRegistration.remoteUser" /></td>
		</tr>
		<tr class="gray" style="font-size:8pt">
			<td>Last registration update date</td>
			<td><bean:write name="user.container"
				property="customer.misldRegistration.recordTime" /></td>
		</tr>
	</logic:notEmpty>

	<logic:notEmpty name="user.container"
		property="customer.misldAccountSettings">
		<logic:notEqual name="user.container"
			property="customer.misldAccountSettings.status" value="DRAFT">
			<tr class="gray" style="font-size:8pt">
				<td>Last settings update performed by</td>
				<td><bean:write name="user.container"
					property="customer.misldAccountSettings.remoteUser" /></td>
			</tr>
			<tr class="gray" style="font-size:8pt">
				<td>Last settings update date</td>
				<td><bean:write name="user.container"
					property="customer.misldAccountSettings.recordTime" /></td>
			</tr>
			<logic:iterate id="consents" name="consent.list">
				<logic:notEmpty name="consents" property="priceLevel">
					<logic:notEqual name="consents" property="priceLevel.priceLevel"
						value="">
						<tr class="gray" style="font-size:8pt">
							<td>Price level</td>
							<td><bean:write name="consents" property="priceLevel.priceLevel" /></td>
						</tr>
					</logic:notEqual>
				</logic:notEmpty>
			</logic:iterate>
			<logic:iterate id="consents" name="consent.list">
				<logic:notEmpty name="consents" property="esplaEnrollmentNumber">
					<tr class="gray" style="font-size:8pt">
						<td>eSPLA enrollment number</td>
						<td><bean:write name="consents" property="esplaEnrollmentNumber" />
						</td>
					</tr>
				</logic:notEmpty>
			</logic:iterate>
			<tr class="gray" style="font-size:8pt">
				<td>Qualified discount</td>
				<td><bean:write name="user.container"
					property="customer.misldAccountSettings.qualifiedDiscount.qualifiedDiscount" /></td>
			</tr>
			<tr class="gray" style="font-size:8pt">
				<td>Microsoft software owner</td>
				<td><bean:write name="user.container"
					property="customer.misldAccountSettings.microsoftSoftwareOwner" /></td>
			</tr>
			<tr class="gray" style="font-size:8pt">
				<td>Microsoft software buyer</td>
				<td><bean:write name="user.container"
					property="customer.misldAccountSettings.microsoftSoftwareBuyer" /></td>
			</tr>
			<tr class="gray" style="font-size:8pt">
				<td>License Agreement</td>
				<td><logic:present name="user.container"
					property="customer.misldAccountSettings.licenseAgreementType">
					<bean:write name="user.container"
						property="customer.misldAccountSettings.licenseAgreementType.licenseAgreementTypeName" />
				</logic:present></td>
			</tr>
			<tr class="gray" style="font-size:8pt">
				<td>Microsoft customer agreement(s)</td>
				<td>
				<ul>
					<logic:iterate id="agreements" name="customer.agreement.list">
						<li><bean:write name="agreements"
							property="customerAgreementType.customerAgreementType" />
						</li>
					</logic:iterate>
				</ul>
				</td>
			</tr>
			<tr class="gray" style="font-size:8pt">
				<td>Consent letters required</td>
				<td>
				<ul>
					<logic:iterate id="consents" name="consent.list">
						<li><bean:write name="consents"
							property="consentType.consentTypeName" />
						</li>
					</logic:iterate>
				</ul>
				</td>
			</tr>
		</logic:notEqual>
	</logic:notEmpty>
</table>
<br>

<logic:notEmpty name="user.container"
	property="customer.misldAccountSettings">
	<table class="basic-table" border="0" cellspacing="1" cellpadding="0"
		width="100%" style="margin-top:2em;">

		<tr class="tablefont">
			<th colspan="10" style="white-space:nowrap; background-color:#bd6;">Customer
			settings</th>
		</tr>
		<tr style="background-color:#dfb;" class="tablefont">
			<th nowrap="nowrap">Attribute</th>
			<th nowrap="nowrap">Value</th>
		</tr>

		<tr class="gray" style="font-size:8pt">
			<td>Can IBM release customer information to Microsoft according to
			the contract between IBM and the customer?</td>
			<td><bean:write name="user.container"
				property="customer.misldAccountSettings.releaseInformation" /></td>
		</tr>
		<tr class="gray" style="font-size:8pt">
			<td>Will the contract with this account end before <bean:write
				name="user.container" property="quarterQuestion" />?</td>
			<td><bean:write name="user.container"
				property="customer.misldAccountSettings.contractEnd" /></td>
		</tr>
		<tr class="gray" style="font-size:8pt">
			<td>Are all machines for this customer located in the United States?</td>
			<td><bean:write name="user.container"
				property="customer.misldAccountSettings.usMachines" /></td>
		</tr>
	</table>
</logic:notEmpty>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->

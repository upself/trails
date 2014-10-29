<%@ taglib uri="/WEB-INF/struts-html.tld" prefix="html"%>
<%@ taglib uri="/WEB-INF/struts-logic.tld" prefix="logic"%>
<%@ taglib uri="/WEB-INF/struts-bean.tld" prefix="bean"%>
<%@ taglib uri="/WEB-INF/struts-tiles.tld" prefix="tmp"%>

<div id="fourth-level">
<h1>Consent forms for <span class="orange-dark"><bean:write
	name="user.container" property="customer.customerName" /></span></h1>
<!-- forth level navigation -->
<ul class="text-tabs">
	<li><html:link page="/CustomerProfile.do">Overview</html:link> |</li>
	<li><html:link page="/HardwareBaseline.do">Hardware</html:link>
	|</li>
	<li><html:link page="/InstalledSoftwareBaseline.do">Installed Software</html:link>
	|</li>
	<li><html:link page="/ConsentLetter.do" styleClass="active">Consent Letters</html:link>
	|</li>
</ul>
</div>

<logic:iterate id="consentLetter" name="consent.list">
	<b><bean:write name="consentLetter"
		property="consentType.consentTypeName" /></b>
	<br>
	<logic:equal name="consentLetter"
		property="consentType.consentTypeName" value="ESPLA ENROLLMENT FORM">
		<p>The Microsoft License Wizard has identified that an eSPLA
		Enrollment Form is required. The IBM account team that supports this
		account must ensure that an eSPLA Enrollment Form is submitted to
		Microsoft. To fill out the eSPLA enrollment form the account must find
		the customer's headquarters address and find out what the customer's
		Microsoft select level agreement currently is for server software
		(A,B,C,D). The account team must provide the completed eSPLA
		enrollment form to Microsoft and asset management.</p>
		<html:img src="https://w3.ibm.com/images/v6/buttons/btn_aro_66f.gif"
			border="0" />
		<html:link page="/templates/eSPLA_Enrollment_Form.xls">
			Download Form Now (Right Click, Save Target As)
			</html:link>
		</p>
	</logic:equal>
	<logic:equal name="consentLetter"
		property="consentType.consentTypeName"
		value="SELECT HOSTING VERIFICATION FORM">
		<p>The Microsoft License Wizard Tool has identified that a Select
		Hosting License Verification Form is required. The IBM account team
		that supports this account must ensure that a Select Hosting License
		Verification Form is collected. Contact information must be collected
		for IBM and the customer (Company Name, Contact Name, Street Address,
		Contact E-mail Address, City, State/Province, Phone, Country, Postal
		Code, Fax and etc.). Also a list of the products, with the quantities
		of products that are being supported (hosted) by IBM must be provided
		in this form. The Select Hosting License Verification Form should be
		sent to the client (client must sign), the client should then send the
		form to Microsoft and Microsoft should then forward the Form to the
		IBM employee listed in the consent letter. The Hosting License
		Verification Form must then sent to asset management.</p>

		<p><html:img
			src="https://w3.ibm.com/images/v6/buttons/btn_aro_66f.gif" border="0" />
		<html:link
			page="/templates/Select_Hosting_License_Verification_Form.doc">
			Download Form Now (Right Click, Save Target As)
			</html:link></p>
		<p>
	</logic:equal>
	<logic:equal name="consentLetter"
		property="consentType.consentTypeName"
		value="ENTERPRISE HOSTING VERIFICATION FORM">
		<p>The Microsoft License Wizard Tool has identified that an Enterprise
		Hosting License Verification Form is required. The IBM account team
		that supports this account must ensure that an Enterprise Hosting
		License Verification Form is collected. Contact information must be
		collected for IBM and the customer (Company Name, Contact Name, Street
		Address, Contact E-mail Address, City, State/Province, Phone, Country,
		Postal Code and Fax). Also a list of the products, with the quantities
		of products that are being supported (hosted) by IBM must be provided
		in this form. The Enterprise Hosting License Verification Form should
		be sent to the client (client must sign), the client should then send
		the Form to Microsoft and Microsoft should then forward the Form to
		the IBM employee listed in the consent letter. Once the Select Hosting
		License Verification Form has been obtained and completed the form
		must be sent to asset management.</p>

		<p><html:img
			src="https://w3.ibm.com/images/v6/buttons/btn_aro_66f.gif" border="0" />
		<html:link
			page="/templates/Enterprise_Hosting_License_Verification_Form.doc">
			Download Form Now (Right Click, Save Target As)
			</html:link></p>
	</logic:equal>
	<logic:equal name="consentLetter"
		property="consentType.consentTypeName" value="PRO FORMA CONSENT">
		<p>The Microsoft License Wizard Tool has identified that a ProForma
		Consent Letter is required. The IBM account team that supports this
		account must ensure that a Proforma letter is collected. Below is the
		data that will need to be collected to complete the ProForma letter,
		the letter should be sent to the client. The client should then send
		the letter to Microsoft (Erica Hart 5335 Wisconsin Ave NW Suite 600
		Washington DC 20015) and Microsoft should then forward the letter to
		the IBM employee listed in the consent letter. Once the consent letter
		has been obtained it should be provided to asset management.</p>

		<p><html:img
			src="https://w3.ibm.com/images/v6/buttons/btn_aro_66f.gif" border="0" />
		<html:link
			page="/templates/ProForma_Consent_Letter_Approved_8.03.01.doc">
			Download Form Now (Right Click, Save Target As)
			</html:link></p>
		<p>
	</logic:equal>
	<logic:equal name="consentLetter"
		property="consentType.consentTypeName"
		value="ENTERPRISE OUTSOURCER ENROLLMENT AGREEMENT">
		<p>The Enterprise Outsourcer Enrollment is something that needs to be
		provided by Microsoft for the specific customer, it is not a standard
		document. The reason for this is that the document is customized per
		the customer. Therefore the account must work to obtain the document
		from the Microsoft representative for the customer. This is normally a
		customized agreement created to meet the customers needs. The account
		team should inform Asset Management once the Enterprise Outsourcer
		Enrollment agreement is completed and provide Asset Management with
		all documents concerning this agreement.</p>

	</logic:equal>
	<logic:equal name="consentLetter"
		property="consentType.consentTypeName"
		value="SELECT OUTSOURCER ENROLLMENT AGREEMENT">
		<p>The Microsoft Wizard Tool has identified that a Select Outsourcer
		Enrollment Forms is required. The IBM account team that supports this
		account must ensure that the Select Outsourcer Enrollment Form is
		collected. Two of these form must be sent in hardcopy (must have an
		original signature of all three parties (IBM contact, client, and the
		reseller)) to Microsoft. This form can not be faxed. It must have the
		original ink on the paper. Contact information must be collected for
		the supplier, IBM, and the customer (Company Name, Contact Name,
		Street Address, Contact E-mail Address, City, State/Province, Phone,
		Country, Postal Code and Fax). Select Outsourcer Enrollment Forms
		should be sent to the client (client must sign), the client should
		then send the Forms to the reseller (reseller must sign), the reseller
		should then forward the Forms to the Microsoft. Microsoft should then
		send the form back to the IBM contact listed on the Select Outsourcer
		Enrollment Form. Once the Outsourcer Enrollment Form has been obtained
		and completed a copy of the document should provided to the asset
		management team. When the Outsourcer agreement ends (when the IBM
		account team expects not to purchase or manage any more licenses for
		the customer) the IBM account team must notify the asset management
		team. The IBM account team must be expecting to purchase 750 points
		(750 points = 50 Windows Standard Licenses) worth of licenses. Once
		the Microsoft Select Outsourcer Enrollment form has been completed,
		orders should be processed through Asset Management or the Account
		Team's standard ordering process. The order should include the
		Microsoft Business Agreement number (if applicable), Select Agreement
		number (if applicable) and Outsourcer Enrollment number (if
		applicable). When submitting any order the buyer should be informed
		that this order is being submitted using the (Client Name) Microsoft
		Select Outsourcer Enrollment Agreement.</p>

		<p><html:img src="https://w3.ibm.com/images/v6/buttons/btn_aro_66f.gif"
			border="0" /> <html:link
			page="/templates/Select_Outsourcer_Enrollment_v6.1_9.2003.pdf">
			Download Form Now (Right Click, Save Target As)
			</html:link></p>
		<p>
	</logic:equal>
	<logic:notEqual name="user.container"
		property="customer.misldAccountSettings.status" value="LOCKED">
		<logic:notEqual name="user.container"
			property="customer.misldRegistration.status" value="LOCKED">
			<logic:notEqual name="consentLetter" property="status"
				value="COMPLETE">
				<html:img page="/images/redx.gif" border="0" />
			</logic:notEqual>
			<logic:equal name="consentLetter" property="status" value="A">
				<html:img page="/images/yellowx.gif" border="0" />
			</logic:equal>
			<logic:equal name="consentLetter" property="status" value="R">
				<html:img page="/images/greenx.gif" border="0" />
			</logic:equal>
			<logic:equal name="consentLetter" property="status" value="M">
				<html:img page="/images/yellowx.gif" border="0" />
			</logic:equal>
			<logic:equal name="consentLetter" property="status" value="Y">
				<html:img page="/images/greencheck.gif" border="0" />
			</logic:equal>
			<html:link page="/ConsentLetterQuestion.do" paramId="consentLetter"
				paramName="consentLetter" paramProperty="consentLetterId">
                Change Status of this Form
            </html:link>
		</logic:notEqual>
	</logic:notEqual>
	<hr>
</logic:iterate>
</div>
<!-- stop main content -->
</div>
<!-- stop content -->
